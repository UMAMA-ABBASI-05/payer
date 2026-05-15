import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Physical device ke liye laptop ka IP use karein (e.g., 192.168.x.x)
  static const String baseUrl = "http://192.168.50.14:8003";

  // 1. Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  static Future<Map<String, dynamic>?> signup({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_name': userName,
          'email': email,
          'password': password,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) return data;
      throw Exception(data['detail'] ?? 'Signup failed');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // 2. Get All Patients
  static Future<List<dynamic>> getAllPatients() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/get_all_patients'));
      print("Status: ${res.statusCode}");
      print("Body: ${res.body}");
      if (res.statusCode == 200) return jsonDecode(res.body);
      throw Exception('Failed to load patients');
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load patients');
    }
  }

  // 3. Register Patient
  static Future<bool> registerPatient(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reg_patient'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  // 4. Get Pending Claims
  static Future<List<dynamic>> getAllPendingClaims() async {
    final res = await http.get(Uri.parse('$baseUrl/get_all_claims'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load claims');
  }

  // 5. Lock Claim

  static Future<bool> lockClaim(int claimId, int userId) async {
    final res = await http.put(
      Uri.parse('$baseUrl/lock_claim$claimId/by$userId'),
    );
    return res.statusCode == 202;
  }

  static Future<void> unlockClaim(int claimId, int userId) async {
    await http.put(Uri.parse('$baseUrl/unlock_claim$claimId/by$userId'));
  }

  // 6. Get Single Claim
  static Future<Map<String, dynamic>> getSingleClaim(int claimId) async {
    final res = await http.get(Uri.parse('$baseUrl/get_single_claim$claimId'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load claim');
  }

  // 7. Change Status (Approve/Reject)
  static Future<bool> changeClaimStatus(
    int claimId,
    String status,
    int userId,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/change_claim_status$claimId/$status/user/$userId'),
    );
    return res.statusCode == 202;
  }

  static Future<Map<String, dynamic>> getPatient(int pid) async {
    final res = await http.get(Uri.parse('$baseUrl/get_patient/$pid'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load patient');
  }

  static Future<List<dynamic>> getExpenseBreakdown(
    int pid,
    int policyId,
  ) async {
    final res = await http.get(
      Uri.parse(
        '$baseUrl/expnse_breakdown/patient_id/$pid/policy_id/$policyId',
      ),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load breakdown');
  }
}
