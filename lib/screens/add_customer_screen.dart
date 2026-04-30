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
  final api = ApiService();

  // Reusable Field Builder for Figma Style
  Widget _buildFigmaField(
    String label,
    TextEditingController ctrl,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF6B778C), fontSize: 14)),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 20),
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFE5E9F0)),
          ),
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFigmaField("Customer", nameController, "Enter Name"),
            _buildFigmaField("Date of Birth", dobController, "DD/MM/YYYY"),
            _buildFigmaField("Phone-No", phoneController, "+92..."),

            Text("Gender", style: TextStyle(color: Color(0xFF6B778C))),
            Row(children: [_genderOption("Male"), _genderOption("Female")]),

            SizedBox(height: 25),
            Text(
              "Insurance plan_type",
              style: TextStyle(color: Color(0xFF6B778C)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Bronze",
                "Silver",
                "Gold",
              ].map((p) => _planCard(p)).toList(),
            ),

            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4C84F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  int? uid = await SessionService.getUserId();
                  bool success = await api.registerPatient({
                    "name": nameController.text,
                    "phone_no": phoneController.text,
                    "gender": selectedGender,
                    "date_of_birth": dobController.text,
                    "insurance_type": selectedPlan,
                    "user_id": uid,
                  });
                  if (success) Navigator.pop(context);
                },
                child: Text(
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
    bool isSelected = selectedGender == title;
    return Row(
      children: [
        Radio(
          value: title,
          groupValue: selectedGender,
          activeColor: Color(0xFF4C84F3),
          onChanged: (val) => setState(() => selectedGender = val.toString()),
        ),
        Text(title),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _planCard(String title) {
    bool isSelected = selectedPlan == title;
    return GestureDetector(
      onTap: () => setState(() => selectedPlan = title),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4C84F3) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Color(0xFF4C84F3) : Color(0xFFE5E9F0),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Color(0xFF6B778C),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
