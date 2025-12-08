import 'package:flutter/material.dart';
import '../../widgets/onboarding_widgets.dart';

class OnboardingPage2 extends StatelessWidget {
  final bool showTop;
  const OnboardingPage2({this.showTop = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          OnboardingTitle(text: 'Juzz / Surah Selection'),
          SizedBox(height: 16),
          OnboardingSubtitle(
            text:
                'Easily choose your Juzz or Surah with our intuitive feature.',
          ),
          SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/image2.jfif',
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
