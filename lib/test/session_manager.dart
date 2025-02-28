import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';

  // Save user session (user ID and type)
  Future<void> saveUserSession(int userId, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userTypeKey, userType);
  }

  // Retrieve the user session (user ID and type)
  Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final userType = prefs.getString(_userTypeKey);
    if (userId != null && userType != null) {
      return {'user_id': userId, 'user_type': userType};
    }
    return null;
  }

  // Clear the user session (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
