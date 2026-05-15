import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedGender = "Male";
  String selectedPlan = "Gold";
  bool _loading = false;

  // Date Picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 18, 38, 80),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // YYYY-MM-DD format
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() => dobController.text = formatted);
    }
  }

  Widget _buildFigmaField(
    String label,
    TextEditingController ctrl,
    String hint, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B778C), fontSize: 14),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E9F0)),
          ),
          child: TextField(
            controller: ctrl,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: readOnly
                  ? const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF6B778C),
                      size: 18,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      _showSnack('Name required', Colors.red);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      _showSnack('Phone number required', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final int? uid = await SessionService.getUserId();
      final bool success = await ApiService.registerPatient({
        "name": nameController.text.trim(),
        "phone_no": phoneController.text.trim(),
        "gender": selectedGender,
        "date_of_birth": dobController.text.isNotEmpty
            ? dobController.text
            : null,
        "insurance_type": selectedPlan,
        "user_id": uid,
      });

      if (!mounted) return;

      if (success) {
        _showSnack('Patient registered successfully!', Colors.green);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      } else {
        _showSnack('Registration failed', Colors.red);
      }
    } catch (e) {
      _showSnack(e.toString().replaceAll('Exception: ', ''), Colors.red);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Submit New Insurance Claim",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFigmaField("Customer", nameController, "Enter Name"),
            _buildFigmaField(
              "Date of Birth",
              dobController,
              "YYYY-MM-DD",
              readOnly: true,
              onTap: _pickDate,
            ),
            _buildFigmaField("Phone-No", phoneController, "+92..."),

            const Text("Gender", style: TextStyle(color: Color(0xFF6B778C))),
            Row(children: [_genderOption("Male"), _genderOption("Female")]),

            const SizedBox(height: 25),
            const Text(
              "Insurance plan_type",
              style: TextStyle(color: Color(0xFF6B778C)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Bronze",
                "Silver",
                "Gold",
              ].map((p) => _planCard(p)).toList(),
            ),

            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 18, 38, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SUBMIT CLAIM",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderOption(String title) {
    return Row(
      children: [
        Radio(
          value: title,
          groupValue: selectedGender,
          activeColor: const Color.fromARGB(255, 18, 38, 80),
          onChanged: (val) => setState(() => selectedGender = val.toString()),
        ),
        Text(title),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _planCard(String title) {
    bool isSelected = selectedPlan == title;
    return GestureDetector(
      onTap: () => setState(() => selectedPlan = title),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 18, 38, 80)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 18, 38, 80)
                : const Color(0xFFE5E9F0),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6B778C),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
