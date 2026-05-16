import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClaimDetailScreen extends StatefulWidget {
  final int claimId;
  final int userId;
  const ClaimDetailScreen({
    super.key,
    required this.claimId,
    required this.userId,
  });

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen> {
  Map<String, dynamic>? _claim;
  bool _loading = true;
  bool _saving = false;

  static const Color primaryColor = Color.fromARGB(255, 18, 38, 80);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ApiService.getSingleClaim(widget.claimId);
      setState(() {
        _claim = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _unlockAndPop() async {
    // await ApiService.unlockClaim(widget.claimId, widget.userId);
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Screen unlocked'),
    //       backgroundColor: Colors.grey,
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    // }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _changeStatus(String status) async {
    setState(() => _saving = true);
    try {
      final ok = await ApiService.changeClaimStatus(
        widget.claimId,
        status,
        widget.userId,
      );
      if (!mounted) return;
      if (ok) {
        // await ApiService.unlockClaim(widget.claimId, widget.userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Claim $status successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status update failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await ApiService.unlockClaim(widget.claimId, widget.userId);
        // if (mounted)
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Screen unlocked'),
        //       backgroundColor: Colors.grey,
        //       duration: Duration(seconds: 2),
        //     ),
        //   );
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _unlockAndPop,
          ),
          title: Text(
            _claim?['patient_name'] ?? 'Claim Detail',
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detail Card
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
                          _row('Gender:', _claim?['gender'] ?? 'N/A'),
                          _row(
                            'Phone no:',
                            _claim?['patient_phone_no'] ?? 'N/A',
                          ),
                          _row('Bill:', '${_claim?['bill_amount'] ?? 'N/A'}'),
                          _row(
                            'Total coverage:',
                            '${_claim?['total_coverage'] ?? 'N/A'}',
                          ),
                          _row(
                            'Remaining amount:',
                            '${(_claim?['total_coverage'] ?? 0) - (_claim?['amount_used'] ?? 0)}',
                          ),
                          _row(
                            'Service:',
                            _claim?['service_included'] == true
                                ? 'Included'
                                : 'Excluded',
                          ),
                          _row(
                            'Test:',
                            _claim?['tests_included'] == true
                                ? 'Included'
                                : 'Excluded',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Approve / Reject Buttons
                    _saving
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _changeStatus('Approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _changeStatus('Rejected'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
