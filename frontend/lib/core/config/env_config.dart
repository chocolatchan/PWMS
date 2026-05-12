import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl {
    final fallback = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
    return dotenv.get('BASE_URL', fallback: '$fallback/api/v2');
  }

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {
      // Fallback if .env is missing
    }
  }
}
