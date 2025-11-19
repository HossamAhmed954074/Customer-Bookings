import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _tokenTimestampKey = 'auth_token_timestamp';
  static const int _tokenExpirationDays = 7; // Token expires after 7 days

  // Save token to local storage with timestamp
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(
      _tokenTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Get token from local storage and check if expired
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final timestamp = prefs.getInt(_tokenTimestampKey);

    if (token == null || timestamp == null) {
      return null;
    }

    // Check if token is expired
    final tokenDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(tokenDate).inDays;

    if (difference >= _tokenExpirationDays) {
      // Token expired, clear it and return null
      await clearToken();
      return null;
    }

    return token;
  }

  // Check if user is logged in (also checks expiration)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear token and timestamp (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTimestampKey);
  }
}
