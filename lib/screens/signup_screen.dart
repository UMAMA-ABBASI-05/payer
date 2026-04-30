import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Styling from Figma image_d2c77f.png (Registration)
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Main Title
              const Text(
                "Sign Up",
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 50),

              // Name Field (Person icon)
              CustomTextField(
                controller: nameController,
                hintText: "Enter your name",
                prefixIcon: Icons.person_outline_rounded,
              ),

              // Email Field (Mail icon)
              CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.mail_outline_rounded,
              ),

              // Password Field (Lock icon + Eye)
              CustomTextField(
                controller: passController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              // Blue Sign Up Button
              PrimaryButton(
                text: "Sign Up",
                onPressed: () {
                  // Handle signup logic
                },
              ),

              // Bottom Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Color(0xFF6B778C), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to Login
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFF4C84F3), // Figma Blue
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
