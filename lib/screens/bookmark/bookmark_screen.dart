import 'package:flutter/material.dart';

import '../surah/surah_detail_screen.dart';

class BookmarkEntry {
  const BookmarkEntry({
    required this.englishName,
    required this.arabicName,
    required this.assetPath,
    this.isPdf = true,
  });

  final String englishName;
  final String arabicName;
  final String assetPath;
  final bool isPdf;
}

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  static const List<BookmarkEntry> _bookmarks = [
    BookmarkEntry(
      englishName: 'aytalKursi',
      arabicName: 'آيَةُ الْكُرْسِي',
      assetPath: 'assets/aytal kursi.jfif',
      isPdf: false,
    ),
    BookmarkEntry(
      englishName: 'Baqarah',
      arabicName: 'سُورَةُ البَقَرَة',
      assetPath: 'assets/surah bakra.pdf',
    ),
    BookmarkEntry(
      englishName: 'Al-Kahf',
      arabicName: 'سُورَةُ الكَهْف',
      assetPath: 'assets/surah kahf.pdf',
    ),
    BookmarkEntry(
      englishName: 'Ya-seen',
      arabicName: 'سُورَةُ يس',
      assetPath: 'assets/surah yaseen.pdf',
    ),
    BookmarkEntry(
      englishName: "Al-Waqi'ah",
      arabicName: 'سُورَةُ الوَاقِعَة',
      assetPath: 'assets/surah waqia.pdf',
    ),
    BookmarkEntry(
      englishName: 'Ar-Rehman',
      arabicName: 'سُورَةُ الرَّحْمٰن',
      assetPath: 'assets/surah rehman.pdf',
    ),
    BookmarkEntry(
      englishName: 'Al-Mulk',
      arabicName: 'سُورَةُ المُلْك',
      assetPath: 'assets/surah mulak.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          const _BookmarkHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: _bookmarks.length,
              separatorBuilder: (context, _) => const Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Color(0xFFE8EAE8),
              ),
              itemBuilder: (context, index) {
                final bookmark = _bookmarks[index];
                return InkWell(
                  onTap: () {
                    _openBookmark(context, bookmark);
                  },
                  child: SizedBox(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              bookmark.englishName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFCF9A27),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.bookmark_rounded,
                            size: 26,
                            color: Color(0xFFCF9A27),
                          ),
                          const SizedBox(width: 18),
                          Text(
                            bookmark.arabicName,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _openBookmark(BuildContext context, BookmarkEntry bookmark) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) =>
          SurahDetailScreen(
            englishName: bookmark.englishName,
            assetPath: bookmark.assetPath,
            isPdf: bookmark.isPdf,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final slide = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curve);
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    ),
  );
}

class _BookmarkHeader extends StatelessWidget {
  const _BookmarkHeader();

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
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'Bookmarks',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
                child: const Icon(
                  Icons.bookmark_add,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
