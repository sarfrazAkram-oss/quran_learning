import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'onboarding/onboarding_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181A1B),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        // color removed from here
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.only(bottom: 40),
                width: 120,
                height: 120,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.asset(
                    'assets/image.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main Heading
              Text(
                'As-salamu alaykum',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              // Subtitle
              Text(
                'Begin your journey to perfect Quran recitation.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),

              SizedBox(height: 30),

              // Language Selection Title
              Text(
                'Choose your language',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // Language Buttons
              CustomButton(
                text: 'English',
                isSelected: selectedLanguage == 'English',
                onTap: () => setState(() => selectedLanguage = 'English'),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'اردو',
                isSelected: selectedLanguage == 'اردو',
                onTap: () => setState(() => selectedLanguage = 'اردو'),
              ),

              SizedBox(height: 30),

              // Get Started Button
              CustomButton(
                text: 'Get Started',
                isSelected: true,
                onTap: selectedLanguage.isNotEmpty
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingScreen(),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
