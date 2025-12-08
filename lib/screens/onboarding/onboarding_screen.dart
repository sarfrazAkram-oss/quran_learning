import 'package:flutter/material.dart';
import 'onboarding_page_1.dart';
import 'onboarding_page_2.dart';
import 'onboarding_page_3.dart';
import 'onboarding_page_4.dart';
import '../../widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: Duration(milliseconds: 350),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _backPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 350),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181A1B),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quran Learn',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingPage1(showTop: false),
                  OnboardingPage2(showTop: false),
                  OnboardingPage3(showTop: false),
                  OnboardingPage4(showTop: false),
                ],
              ),
            ),
            OnboardingIndicators(currentPage: _currentPage, totalPages: 4),
            OnboardingButtonBar(
              currentPage: _currentPage,
              totalPages: 4,
              onNext: _nextPage,
              onBack: _backPage,
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
