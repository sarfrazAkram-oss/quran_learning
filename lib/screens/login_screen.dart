import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart'; // Import the HomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Logo
              Center(
                child: Image.asset(
                  'assets/image.png', // Ensure the image is visible
                  width: 110,
                  height: 110,
                ),
              ),
              SizedBox(height: 20),

              // Page Title
              Center(
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 25),

              // Email Field
              _buildInputField(
                label: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(height: 20),

              // Password Field
              _buildInputField(
                label: 'Password',
                hintText: 'Enter your password',
                icon: Icons.lock,
                isPassword: true,
                isVisible: isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Add forgot password functionality here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00C853),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(double.infinity, 55),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Divider with "or"
              Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFDADADA))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'or',
                      style: TextStyle(color: Color(0xFFDADADA)),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFDADADA))),
                ],
              ),
              SizedBox(height: 15),

              // Social Login Buttons
              _buildSocialButton(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata,
              ),
              SizedBox(height: 12),
              _buildSocialButton(
                text: 'Continue with Facebook',
                icon: Icons.facebook,
              ),
              SizedBox(height: 30),

              // Bottom Text
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF00C853),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xFFF5F5F5)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, color: Colors.grey),
              ),
              Expanded(
                child: TextField(
                  obscureText: isPassword && !isVisible,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Color(0xFFAFAFAF)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (isPassword)
                IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String text, required IconData icon}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: Size(double.infinity, 55),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
