import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // Figma specifications
    const Color inputBackground = Color(0xFFF9FAFB); // Very light grey
    const Color iconColor = Color(0xFFC0CCDA); // Grey icons

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 56, // Fixed height per Figma
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: const Color(0xFFE5E9F0)), // Border like Figma
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(widget.prefixIcon, color: iconColor, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF9EAAB7),
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (widget.isPassword)
            GestureDetector(
              onTap: () => setState(() => _obscureText = !_obscureText),
              child: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: iconColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
