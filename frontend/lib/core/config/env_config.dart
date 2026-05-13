import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl {
    // Priority: 
    // 1. --dart-define=API_IP (from Makefile)
    // 2. .env (API_URL)
    // 3. Fallback logic (Platform specific + detected LAN IP)
    
    const definedIp = String.fromEnvironment('API_IP');
    final fallbackIp = Platform.isAndroid ? '10.0.2.2' : '192.168.1.152';
    final activeIp = definedIp.isNotEmpty ? definedIp : fallbackIp;
    final defaultUrl = 'http://$activeIp:3000/api/v2/';

    try {
      String url = dotenv.get('API_URL', fallback: defaultUrl);
      if (!url.endsWith('/')) url += '/';
      return url;
    } catch (_) {
      return defaultUrl;
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
