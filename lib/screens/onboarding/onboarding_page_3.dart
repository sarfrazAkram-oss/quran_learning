import 'package:flutter/material.dart';
import '../../widgets/onboarding_widgets.dart';

class OnboardingPage3 extends StatelessWidget {
  final bool showTop;
  const OnboardingPage3({this.showTop = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          OnboardingTitle(text: 'Multiple Fonts'),
          SizedBox(height: 16),
          OnboardingSubtitle(
            text:
                'Explore varied Quranic fonts for a personalized reading experience in our app.',
          ),
          SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/image3.jfif',
                height: 340,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
