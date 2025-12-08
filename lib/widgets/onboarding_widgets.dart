import 'package:flutter/material.dart';

class OnboardingTitle extends StatelessWidget {
  final String text;
  const OnboardingTitle({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF7FFF00), // Green shade as in screenshot
      ),
      textAlign: TextAlign.center,
    );
  }
}

class OnboardingSubtitle extends StatelessWidget {
  final String text;
  const OnboardingSubtitle({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}

class OnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  const OnboardingIndicators({
    required this.currentPage,
    required this.totalPages,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          width: 24,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentPage ? Color(0xFF7FFF00) : Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class OnboardingButtonBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const OnboardingButtonBar({
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onBack,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentPage > 0)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(0xFFFFD600),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            )
          else
            SizedBox(width: 44),
          GestureDetector(
            onTap: onNext,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF7FFF00), width: 2),
                borderRadius: BorderRadius.circular(32),
                color: Colors.transparent,
              ),
              child: Text(
                currentPage == totalPages - 1 ? 'Next' : 'Next',
                style: TextStyle(
                  color: Color(0xFF7FFF00),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
