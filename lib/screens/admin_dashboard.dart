import 'package:payer/screens/insurance_screen.dart';

import '../screens/history_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';
//import '../screens/insurance_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const Color primaryBlue = Color(0xFF1A3B5D);

  // Add Insurance
  bool _showAddInsurance = false;
  final _insuranceNameCtrl = TextEditingController();

  // Hold Data
  bool _holdData = false;

  @override
  void dispose() {
    _insuranceNameCtrl.dispose();
    super.dispose();
  }

  void _saveinsurance() async {
    if (_insuranceNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('insurance name required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await ApiService.addInsurances(
      _insuranceNameCtrl.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] == true
              ? 'insurance company added! ID: ${result['insurance_id']}'
              : result['message'] ?? 'Failed',
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      setState(() {
        _showAddInsurance = false;
        _insuranceNameCtrl.clear();
      });
    }
  }

  void _saveHoldData() async {
    final ok = await ApiService.changeConfigStatus(_holdData);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Hold data: ${_holdData ? 'Enabled' : 'Disabled'}'
              : 'Failed to update',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const Text(
                'Admin Panel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 32),

              // Show Hospitals Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InsuranceScreen()),
                  ),
                  child: const Text(
                    'Show insurances',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Add insurance Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryBlue, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () =>
                      setState(() => _showAddInsurance = !_showAddInsurance),
                  child: const Text(
                    'Add insurance',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Add insurance Form — toggle
              if (_showAddInsurance) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter name of insurance',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _insuranceNameCtrl,
                        decoration: InputDecoration(
                          hintText: 'insurance name...',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveinsurance,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() {
                                _showAddInsurance = false;
                                _insuranceNameCtrl.clear();
                              }),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Hold Data Checkbox + Save
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _holdData,
                      activeColor: primaryBlue,
                      onChanged: (v) => setState(() => _holdData = v ?? false),
                    ),
                    const Text(
                      'Hold Data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _saveHoldData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // History Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  child: const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
