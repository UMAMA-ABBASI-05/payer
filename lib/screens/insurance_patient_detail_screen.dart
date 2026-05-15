import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InsurancePatientDetailScreen extends StatefulWidget {
  final int pid;
  const InsurancePatientDetailScreen({super.key, required this.pid});

  @override
  State<InsurancePatientDetailScreen> createState() =>
      _InsurancePatientDetailScreenState();
}

class _InsurancePatientDetailScreenState
    extends State<InsurancePatientDetailScreen> {
  Map<String, dynamic>? _patient;
  List<dynamic> _breakdown = [];
  bool _loading = true;

  static const Color primaryColor = Color.fromARGB(255, 18, 38, 80);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final patient = await ApiService.getPatient(widget.pid);
      final policy = patient['patient_policy'];
      final policyId = policy != null && policy is Map
          ? policy['policy_id']
          : null;

      List<dynamic> breakdown = [];
      if (policyId != null) {
        breakdown = await ApiService.getExpenseBreakdown(widget.pid, policyId);
      }

      setState(() {
        _patient = patient;
        _breakdown = breakdown;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final policy = _patient?['patient_policy'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _patient?['name'] ?? 'Patient Detail',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- POLICY DETAILS CARD ---
                  if (policy != null) ...[
                    const Text(
                      'Policy Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E9F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(
                            'Total Coverage:',
                            'PKR ${policy['total_coverage'] ?? 'N/A'}',
                          ),
                          _infoRow(
                            'Amount Used:',
                            'PKR ${policy['amount_used'] ?? 'N/A'}',
                          ),
                          _infoRow(
                            'Remaining:',
                            '${(policy['total_coverage'] ?? 0) - (policy['amount_used'] ?? 0)}',
                          ),
                          _infoRow(
                            'Policy Number:',
                            '${policy['policy_id'] ?? 'N/A'}',
                          ),
                          _infoRow(
                            'Policy Plan:',
                            '${policy['policy_plan'] ?? 'N/A'}',
                          ),
                          Row(
                            children: [
                              const Text(
                                'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                policy['status'] ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: policy['status'] == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- CUSTOMER INFO CARD ---
                  const Text(
                    'Customer Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E9F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('nic:', '${_patient?['nic'] ?? 'N/A'}'),
                        _infoRow('Age:', '${_patient?['Age'] ?? 'N/A'}'),
                        _infoRow(
                          'Phone-No:',
                          '${_patient?['phone_no'] ?? 'N/A'}',
                        ),
                        _infoRow('Gender:', '${_patient?['gender'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- EXPENSE BREAKDOWN ---
                  const Text(
                    'Expense Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (_breakdown.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E9F0)),
                      ),
                      child: const Center(
                        child: Text(
                          'No claims found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...(_breakdown.map((claim) {
                      final status = claim['status'] ?? '';
                      final isApproved = status == 'Approved';
                      final date =
                          claim['claim_date']?.toString().split('T')[0] ??
                          'N/A';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E9F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Text(
                              date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service: ${claim['service_included'] == true ? 'Included' : 'Excluded'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Tests: ${claim['tests_included'] == true ? 'Included' : 'Excluded'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Total Amount: ${claim['total_amount'] ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isApproved
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
