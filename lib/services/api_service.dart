import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Physical device ke liye laptop ka IP use karein (e.g., 192.168.x.x)
  static const String baseUrl = "http://192.168.31.247:8003";

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

  // 2. Get All Patients
  Future<List<dynamic>> getAllPatients() async {
    final response = await http.get(Uri.parse("$baseUrl/get_all_patients"));
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // 3. Register Patient
  Future<bool> registerPatient(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reg_patient"),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );
    return response.statusCode == 201;
  }

  // 4. Get Pending Claims
  Future<List<dynamic>> getPendingClaims() async {
    final response = await http.get(Uri.parse("$baseUrl/get_all_claims"));
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // 5. Lock Claim
  Future<void> lockClaim(int claimId, int userId) async {
    await http.put(Uri.parse("$baseUrl/lock_claim$claimId/by/$userId"));
  }

  // 6. Get Single Claim
  Future<Map<String, dynamic>?> getSingleClaim(int claimId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_single_claim$claimId"),
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  // 7. Change Status (Approve/Reject)
  Future<bool> changeStatus(int claimId, String status) async {
    final response = await http.put(
      Uri.parse("$baseUrl/change_claim_status$claimId/$status"),
    );
    return response.statusCode == 202;
  }

  // 8. Unlock Claim
  Future<void> unlockClaim(int claimId, int userId) async {
    await http.put(Uri.parse("$baseUrl/unlock_claim$claimId/by/$userId"));
  }
}
