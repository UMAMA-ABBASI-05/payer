import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _userIdKey = "user_id";

  // User ID save karne ke liye
  static Future<void> saveUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // User ID read karne ke liye
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Logout ke liye
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
