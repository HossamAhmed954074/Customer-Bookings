import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class SecretConstants {
  static String? apiBaseUrl = dotenv.env['API_BASE_URL'];
  static String? tokenKey = dotenv.env['TOKEN_KEY'];

}