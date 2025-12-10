import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../data/holy_quran_para_data.dart';

class QuranPageLocation {
  const QuranPageLocation({required this.para, required this.pageInPara});

  final HolyQuranPara para;
  final int pageInPara;
}

class QuranPageService {
  QuranPageService._();

  static final QuranPageService _instance = QuranPageService._();

  factory QuranPageService() => _instance;

  final List<_ParaRange> _ranges = <_ParaRange>[];
  Future<void>? _initializing;

  Future<void> _ensureInitialized() {
    return _initializing ??= _loadRanges();
  }

  Future<void> _loadRanges() async {
    int globalStart = 1;
    for (final HolyQuranPara para in holyQuranParas) {
      final Uint8List bytes = await _loadAssetBytes(para.pdfAsset);
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final int pageCount = document.pages.count;
      document.dispose();

      final int globalEnd = globalStart + pageCount - 1;
      _ranges.add(
        _ParaRange(
          para: para,
          startPage: globalStart,
          endPage: globalEnd,
          pageCount: pageCount,
        ),
      );
      globalStart = globalEnd + 1;
    }
  }

  Future<QuranPageLocation?> locate(int pageNumber) async {
    if (pageNumber < 1) {
      return null;
    }
    await _ensureInitialized();
    for (final _ParaRange range in _ranges) {
      if (pageNumber <= range.endPage) {
        final int pageInPara = pageNumber - range.startPage + 1;
        return QuranPageLocation(para: range.para, pageInPara: pageInPara);
      }
    }
    return null;
  }

  int get maxPage => _ranges.isEmpty ? 0 : _ranges.last.endPage;

  Future<Uint8List> _loadAssetBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }
}

class _ParaRange {
  const _ParaRange({
    required this.para,
    required this.startPage,
    required this.endPage,
    required this.pageCount,
  });

  final HolyQuranPara para;
  final int startPage;
  final int endPage;
  final int pageCount;
}
