import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl {
    final fallback = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://192.168.1.29:3000';
    try {
      // Using 'API_URL' as requested, ensuring trailing slash for Dio consistency
      String url = dotenv.get('API_URL', fallback: '$fallback/api/v2/');
      if (!url.endsWith('/')) url += '/';
      return url;
    } catch (_) {
      return '$fallback/api/v2/';
    }
  }

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("Warning: .env file not found, using fallbacks.");
    }
  }
}
