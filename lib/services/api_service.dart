import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Physical device ke liye laptop ka IP use karein (e.g., 192.168.x.x)
  static const String baseUrl = "http://192.168.11.14:8003";
  static Future<List<dynamic>> getAllInsurances() async {
    final res = await http.get(Uri.parse('$baseUrl/all-insurances'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load insurances');
  }

  // Admin Login
  static Future<Map<String, dynamic>> loginAdmin(
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login-admin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print("Admin Login Status: ${res.statusCode}");
      print("Admin Login Body: ${res.body}");
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {'success': true, ...data};
      }
      final error = jsonDecode(res.body);
      return {'success': false, 'message': error['detail'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Add Insurance
  static Future<Map<String, dynamic>> addInsurances(String name) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/add-insurance?name=$name'), // ← query param
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201 || res.statusCode == 200)
        return {'success': true, ...data};
      return {'success': false, 'message': data['detail'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<bool> changeConfigStatus(bool holdFlag) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/change-config-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hold_flag': holdFlag}),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Send Config to Engine
  static Future<bool> sendConfigToEngine() async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/sent-config-to-engine'));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Config History
  static Future<List<dynamic>> getConfigHistory() async {
    final res = await http.get(Uri.parse('$baseUrl/config-history'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load history');
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
    String insuranceId,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'insurance_id': insuranceId, // ← add karo
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    final error = jsonDecode(res.body);
    throw Exception(error['detail'] ?? 'Login failed');
  }

  static Future<void> signup(
    String userName,
    String email,
    String password,
    String insuranceId,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': userName,
        'email': email,
        'password': password,
        'insurance_id': insuranceId, // ← add karo
      }),
    );
    if (res.statusCode != 201) {
      final error = jsonDecode(res.body);
      throw Exception(error['detail'] ?? 'signup failed');
    }
  }

  // 1. Login
  // Future<Map<String, dynamic>?> login(String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/login"),
  //     body: jsonEncode({"email": email, "password": password}),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   if (response.statusCode == 200) return jsonDecode(response.body);
  //   return null;
  // }

  // static Future<Map<String, dynamic>?> signup({
  //   required String userName,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final res = await http.post(
  //       Uri.parse('$baseUrl/signup'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'user_name': userName,
  //         'email': email,
  //         'password': password,
  //       }),
  //     );
  //     final data = jsonDecode(res.body);
  //     if (res.statusCode == 200 || res.statusCode == 201) return data;
  //     throw Exception(data['detail'] ?? 'Signup failed');
  //   } catch (e) {
  //     throw Exception(e.toString().replaceAll('Exception: ', ''));
  //   }
  // }

  // 2. Get All Patients
  static Future<List<dynamic>> getAllPatients(String insuranceID) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/get_all_patients/$insuranceID'),
      );
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
  static Future<bool> registerPatient(
    Map<String, dynamic> data,
    String insuranceID,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reg_patient/$insuranceID'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  // 4. Get Pending Claims
  static Future<List<dynamic>> getAllPendingClaims(String insuranceID) async {
    final res = await http.get(
      Uri.parse('$baseUrl/get_all_claims/$insuranceID'),
    );
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
