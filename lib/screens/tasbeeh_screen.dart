import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TasbeehEntry {
  const TasbeehEntry({
    required this.name,
    required this.meaning,
    required this.arabic,
    required this.initialCount,
    this.isCustom = false,
  });

  final String name;
  final String meaning;
  final String arabic;
  final int initialCount;
  final bool isCustom;
}

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  static const Color _cardColor = Color(0xFF111F16);
  static const Color _titleGreen = Color(0xFF3BFF8C);
  static const Color _captionColor = Color(0xFF8FA99B);
  static const Color _counterBackground = Color(0xFF1B2F21);
  static const Color _actionBackground = Color(0xFF1A2D1E);
  static const Color _accentGreen = Color(0xFF00FF66);

  final List<TasbeehEntry> _entries = const <TasbeehEntry>[
    TasbeehEntry(
      name: 'SubhanAllah',
      meaning: 'GLORY BE TO ALLAH',
      arabic: 'سُبْحَانَ ٱللّٰه',
      initialCount: 33,
    ),
    TasbeehEntry(
      name: 'Alhumdulillah',
      meaning: 'PRAISE BE TO ALLAH',
      arabic: 'ٱلْحَمْدُ لِلَّٰهِ',
      initialCount: 10,
    ),
    TasbeehEntry(
      name: 'Allah hu Akbar',
      meaning: 'ALLAH IS THE GREATEST',
      arabic: 'ٱللّٰهُ أَكْبَرُ',
      initialCount: 12,
    ),
    TasbeehEntry(
      name: 'Ya Hayyu Ya Qiyum',
      meaning: 'O LIVING, O SELF-SUBSISTING',
      arabic: 'يَا حَيُّ يَا قَيُّومُ',
      initialCount: 5,
    ),
    TasbeehEntry(
      name: 'Custom Counter',
      meaning: 'TRACK ANY GOAL',
      arabic: 'No specific phrase',
      initialCount: 0,
      isCustom: true,
    ),
  ];

  late final List<int> _counts = _entries
      .map((entry) => entry.initialCount)
      .toList();

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF181A1B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Tasbeeh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: ColoredBox(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: List.generate(_entries.length, (index) {
              final TasbeehEntry entry = _entries[index];
              final int count = _counts[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == _entries.length - 1 ? 0 : 22,
                ),
                child: _TasbeehCard(
                  backgroundColor: _cardColor,
                  titleColor: _titleGreen,
                  captionColor: _captionColor,
                  counterBackground: _counterBackground,
                  actionBackground: _actionBackground,
                  actionPrimary: _accentGreen,
                  name: entry.name,
                  meaning: entry.meaning,
                  arabic: entry.arabic,
                  count: count,
                  isCustom: entry.isCustom,
                  onReset: () => setState(() => _counts[index] = 0),
                  onIncrement: () => setState(() => _counts[index] += 1),
                  onDecrement: () => setState(() {
                    if (_counts[index] > 0) {
                      _counts[index] -= 1;
                    }
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TasbeehCard extends StatelessWidget {
  const _TasbeehCard({
    required this.backgroundColor,
    required this.titleColor,
    required this.captionColor,
    required this.counterBackground,
    required this.actionBackground,
    required this.actionPrimary,
    required this.name,
    required this.meaning,
    required this.arabic,
    required this.count,
    required this.onReset,
    required this.onIncrement,
    required this.onDecrement,
    required this.isCustom,
  });

  final Color backgroundColor;
  final Color titleColor;
  final Color captionColor;
  final Color counterBackground;
  final Color actionBackground;
  final Color actionPrimary;
  final String name;
  final String meaning;
  final String arabic;
  final int count;
  final VoidCallback onReset;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meaning,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: captionColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: counterBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              arabic,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCustom ? 18 : 26,
                fontWeight: isCustom ? FontWeight.w500 : FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              _SquareButton(
                size: 60,
                backgroundColor: actionBackground,
                icon: Icons.refresh,
                onTap: onReset,
              ),
              const SizedBox(width: 12),
              _SquareButton(
                size: 60,
                backgroundColor: actionBackground,
                icon: Icons.remove,
                onTap: onDecrement,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onIncrement,
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isCustom) {
      card = _DashedBorder(
        color: titleColor.withValues(alpha: 0.4),
        radius: 30,
        strokeWidth: 1.4,
        dashLength: 8,
        gapLength: 5,
        child: Padding(padding: const EdgeInsets.all(3), child: card),
      );
    }

    return card;
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.size,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });

  final double size;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 24),
          onPressed: onTap,
          splashRadius: 28,
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.child,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromLTRBR(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth / 2,
      size.height - strokeWidth / 2,
      Radius.circular(radius),
    );

    final ui.Path path = ui.Path()..addRRect(rrect);
    final ui.PathMetrics metrics = path.computeMetrics();

    for (final ui.PathMetric metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        final ui.Path extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
