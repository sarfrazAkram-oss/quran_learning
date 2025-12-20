import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SurahDetailScreen extends StatelessWidget {
  const SurahDetailScreen({
    super.key,
    required this.englishName,
    required this.assetPath,
    this.isPdf = true,
  });

  final String englishName;
  final String assetPath;
  final bool isPdf;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A1B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _SurahHeader(englishName: englishName),
          Expanded(
            child: ColoredBox(
              color: backgroundColor,
              child: isPdf
                  ? SfPdfViewerTheme(
                      data: SfPdfViewerThemeData(
                        backgroundColor: backgroundColor,
                      ),
                      child: SfPdfViewer.asset(
                        assetPath,
                        canShowScrollHead: false,
                        canShowScrollStatus: false,
                        scrollDirection: PdfScrollDirection.horizontal,
                        pageLayoutMode: PdfPageLayoutMode.single,
                      ),
                    )
                  : Center(
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(assetPath, fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.englishName});

  final String englishName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3AB36B), Color(0xFF11C86A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      englishName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0x26102B18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
