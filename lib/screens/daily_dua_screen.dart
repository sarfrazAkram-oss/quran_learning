import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DailyDuaScreen extends StatefulWidget {
  const DailyDuaScreen({super.key});

  @override
  State<DailyDuaScreen> createState() => _DailyDuaScreenState();
}

class _DailyDuaScreenState extends State<DailyDuaScreen> {
  final PdfViewerController _controller = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Daily Du'aa",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF10201A),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF10201A)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SfPdfViewer.asset(
                'assets/duas.pdf',
                controller: _controller,
                enableDoubleTapZooming: false,
                canShowScrollHead: false,
                enableTextSelection: true,
                interactionMode: PdfInteractionMode.pan,
                pageLayoutMode: PdfPageLayoutMode.single,
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) =>
                      _handleTap(details.localPosition, constraints.maxWidth),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleTap(Offset position, double width) {
    final int totalPages = _controller.pageCount;
    final int currentPage = _controller.pageNumber;

    final bool tapOnRight = position.dx > width / 2;
    if (tapOnRight) {
      if (currentPage < totalPages) {
        _controller.nextPage();
      }
    } else {
      if (currentPage > 1) {
        _controller.previousPage();
      }
    }
  }
}
