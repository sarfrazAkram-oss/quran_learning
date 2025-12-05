import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/star_pattern.png',
            ), // Replace with your star pattern asset
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Quran Icon Button
              Container(
                margin: EdgeInsets.only(top: 20), // Add spacing from the top
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFA7DCE5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/quran_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Main Heading
              Text(
                'As-salamu alaykum',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3A4A),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              // Subtitle
              Text(
                'Begin your journey to perfect Quran recitation.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A6F7F),
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D3A4A),
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
                text: 'العربية',
                isSelected: selectedLanguage == 'العربية',
                onTap: () => setState(() => selectedLanguage = 'العربية'),
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
                          builder: (context) =>
                              SignupScreen(selectedLanguage: selectedLanguage),
                        ),
                      )
                    : null,
              ),

              SizedBox(height: 30),

              // Bottom Login Text
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
                child: Column(
                  children: [
                    Text(
                      'Already have an account? Log In',
                      style: TextStyle(fontSize: 15, color: Color(0xFF5A6F7F)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20), // Add spacing below the text
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
