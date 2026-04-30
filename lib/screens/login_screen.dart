import 'package:flutter/material.dart';
import 'package:payer/screens/insurance_list_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
//import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    // 1. Basic Validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email aur password lazmi bharein!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. API Call
      final result = await _apiService.login(email, password);

      if (result != null && result.containsKey('user_id')) {
        // 3. Session mein user_id save karna
        await SessionService.saveUser(result['user_id']);

        // 4. Home Screen par navigate karna
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ghalat email ya password!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Server se rabta nahi ho saka")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
                prefixIcon: Icons.mail_outline_rounded,
              ),
              CustomTextField(
                controller: passController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              // Login Button with Loading indicator
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: CircularProgressIndicator(
                        color: Color(0xFF4C84F3),
                      ),
                    )
                  : PrimaryButton(
                      text: "Sign In",
                      onPressed: handleLogin, // Logic yahan attach hai
                    ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Color(0xFF6B778C)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF4C84F3),
                        fontWeight: FontWeight.bold,
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
