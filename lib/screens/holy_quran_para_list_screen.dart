import 'package:flutter/material.dart';
import '../data/holy_quran_para_data.dart';
import 'holy_quran_para_detail_screen.dart';

class HolyQuranParaListScreen extends StatelessWidget {
  const HolyQuranParaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181A1B);
    const dividerColor = Color(0xFF272A2B);
    const accentColor = Color(0xFF11C86A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 20, 24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 24,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Holy Quran',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 52),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: holyQuranParas.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: dividerColor),
                itemBuilder: (context, index) {
                  final para = holyQuranParas[index];
                  return Material(
                    color: const Color(0xFF1F2223),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HolyQuranParaDetailScreen(para: para),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _HexagonBadge(
                              number: para.number,
                              accent: accentColor,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    para.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    para.subtitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF9AA79D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              para.arabicLabel,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
      ),
    );
  }
}

class _HexagonBadge extends StatelessWidget {
  final int number;
  final Color accent;

  const _HexagonBadge({required this.number, required this.accent});

  @override
  Widget build(BuildContext context) {
    final borderColor = accent.withOpacity(0.35);
    return CustomPaint(
      painter: _HexagonBorderPainter(borderColor),
      child: SizedBox(
        width: 44,
        height: 50,
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _HexagonBorderPainter extends CustomPainter {
  final Color borderColor;

  _HexagonBorderPainter(this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = _hexagonPath(size);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  Path _hexagonPath(Size size) {
    final width = size.width;
    final height = size.height;
    return Path()
      ..moveTo(width * 0.5, 0)
      ..lineTo(width, height * 0.25)
      ..lineTo(width, height * 0.75)
      ..lineTo(width * 0.5, height)
      ..lineTo(0, height * 0.75)
      ..lineTo(0, height * 0.25)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _HexagonBorderPainter oldDelegate) => false;
}
