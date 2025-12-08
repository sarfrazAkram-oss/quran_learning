import 'package:flutter/material.dart';
import '../../widgets/onboarding_widgets.dart';

class OnboardingPage4 extends StatelessWidget {
  final bool showTop;
  const OnboardingPage4({this.showTop = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF181A1B),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            OnboardingTitle(text: 'Prayer Times'),
            SizedBox(height: 16),
            OnboardingSubtitle(
              text:
                  'Customize your prayer times effortlessly with our unique app.',
            ),
            SizedBox(height: 32),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/image4.jfif',
                  height: 340,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
