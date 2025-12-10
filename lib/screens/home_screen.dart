import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String selectedLanguage;

  const HomeScreen({this.selectedLanguage = ''});

  String _localizedGreeting() {
    if (selectedLanguage == 'العربية') {
      return 'مرحبًا بك في تطبيق القرآن';
    }
    if (selectedLanguage == 'اردو') {
      return 'قرآن لرن میں خوش آمدید';
    }
    return 'Welcome back to Quran Learn';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _localizedGreeting();
    final accentColor = const Color(0xFF11C86A);
    final cardSpacing = const SizedBox(height: 18);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 60) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFF181A1B),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.menu, size: 32, color: Colors.white),
                Text(
                  'Quran Learn',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFCFD8D4),
              ),
            ),
            const SizedBox(height: 18),
            _DatePrayerCard(accentColor: accentColor),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureCard(
                  width: cardWidth,
                  icon: Icon(
                    Icons.menu_book_rounded,
                    size: 45,
                    color: accentColor,
                  ),
                  title: 'Holy Quran',
                  subtitle: 'Read the Holy Quran',
                  onTap: () => Navigator.of(context).pushNamed('/holy-quran'),
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: Icon(Icons.graphic_eq, size: 45, color: accentColor),
                  title: 'Tajweed Quran',
                  subtitle: 'Learn pronunciation',
                  onTap: () => Navigator.of(context).pushNamed('/tajweed'),
                ),
              ],
            ),
            cardSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureCard(
                  width: cardWidth,
                  icon: Icon(
                    Icons.menu_book_outlined,
                    size: 45,
                    color: accentColor,
                  ),
                  title: 'Go To Page',
                  subtitle: 'Jump to a specific page',
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: Icon(
                    Icons.bookmark_rounded,
                    size: 45,
                    color: accentColor,
                  ),
                  title: 'Bookmarks',
                  subtitle: 'Access your saved pages',
                ),
              ],
            ),
            cardSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureCard(
                  width: cardWidth,
                  icon: Icon(Icons.mosque, size: 45, color: accentColor),
                  title: 'Prayer Timing',
                  subtitle: 'View daily schedules',
                ),
                _FeatureCard(
                  width: cardWidth,
                  icon: _CounterIcon(color: accentColor),
                  title: 'Tasbeeh Counter',
                  subtitle: 'Digital counter for dhikr',
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DatePrayerCard extends StatelessWidget {
  final Color accentColor;

  const _DatePrayerCard({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF0A2C14),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -20,
                    top: -10,
                    child: Opacity(
                      opacity: 0.08,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.access_time_filled,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Jumada al-Thani 17',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Monday, 8 December',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4EE08F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0D8A3B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.access_time, color: Colors.white, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Prayer Times',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final double width;
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FeatureCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: width,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Align(alignment: Alignment.centerLeft, child: icon),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7B8D84),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterIcon extends StatelessWidget {
  final Color color;

  const _CounterIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          '5',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
