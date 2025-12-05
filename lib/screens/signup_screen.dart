import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart'; // Import the HomeScreen

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title Section
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Begin your journey to perfect recitation.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),

              // Username Field
              _buildInputField(
                label: 'Username',
                hintText: 'Enter your username',
                icon: Icons.person,
              ),
              SizedBox(height: 18),

              // Email Field
              _buildInputField(
                label: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(height: 18),

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
              SizedBox(height: 18),

              // Confirm Password Field
              _buildInputField(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                icon: Icons.lock,
                isPassword: true,
                isVisible: isConfirmPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 25),

              // Create Account Button
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
                  'Create Account',
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
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 20),

              // Social Login Buttons
              _buildSocialButton(
                text: 'Sign up with Google',
                icon: Icons.g_mobiledata,
              ),
              SizedBox(height: 12),
              _buildSocialButton(
                text: 'Sign up with Facebook',
                icon: Icons.facebook,
              ),
              SizedBox(height: 30),

              // Bottom Text
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Log in',
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
            color: Color(0xFFE8FDE8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xFFC9E8C9)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, color: Colors.yellow),
              ),
              Expanded(
                child: TextField(
                  obscureText: isPassword && !isVisible,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (isPassword)
                IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.yellow,
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
