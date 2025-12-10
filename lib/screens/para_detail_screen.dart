import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../data/para_data.dart';

class ParaDetailScreen extends StatefulWidget {
  final Para para;

  const ParaDetailScreen({super.key, required this.para});

  @override
  State<ParaDetailScreen> createState() => _ParaDetailScreenState();
}

class _ParaDetailScreenState extends State<ParaDetailScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  Size? _firstPageSize;
  double? _viewportHeight;
  double? _lastAppliedZoom;

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ParaDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.para.pdfAsset != widget.para.pdfAsset) {
      _firstPageSize = null;
      _lastAppliedZoom = null;
    }
  }

  void _updateZoomToFitHeight() {
    if (_firstPageSize == null || _viewportHeight == null) {
      return;
    }

    final pageHeight = _firstPageSize!.height;
    if (pageHeight <= 0) {
      return;
    }

    final desiredZoom = (_viewportHeight! / pageHeight)
        .clamp(0.5, 5.0)
        .toDouble();
    if (_lastAppliedZoom != null &&
        (_lastAppliedZoom! - desiredZoom).abs() < 0.02) {
      return;
    }

    _lastAppliedZoom = desiredZoom;
    _pdfController.zoomLevel = desiredZoom;
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A1B);
    final pdfAsset = widget.para.pdfAsset;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.para.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: pdfAsset != null
          ? LayoutBuilder(
              builder: (context, constraints) {
                _viewportHeight = constraints.maxHeight;
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) => _updateZoomToFitHeight(),
                );

                return SfPdfViewer.asset(
                  pdfAsset,
                  controller: _pdfController,
                  canShowPaginationDialog: false,
                  canShowScrollHead: false,
                  canShowScrollStatus: false,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  pageSpacing: 0,
                  scrollDirection: PdfScrollDirection.horizontal,
                  onDocumentLoaded: (details) {
                    _firstPageSize = details.document.pages[0].size;
                    _updateZoomToFitHeight();
                  },
                );
              },
            )
          : const Center(
              child: Text(
                'PDF coming soon...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCFD8D4),
                ),
              ),
            ),
    );
  }
}
