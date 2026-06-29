import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/repository.dart';
import 'cache_service.dart';

class TokenRefreshService {
  static Timer? _timer;

  /// Start the periodic token refresh timer (every 1 minute)
  static void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await refreshAccessToken();
    });
  }

  /// Stop the timer
  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Performs the actual token refresh API call
  static Future<void> refreshAccessToken() async {
    final String refreshToken = CacheService.getRefreshToken();
    if (refreshToken.isEmpty) {
      debugPrint("TokenRefreshService: Refresh token is empty, skipping refresh.");
      return;
    }

    try {
      final result = await repository.refresh({
        "refresh": refreshToken,
      });

      if (result.isSuccess) {
        Map<String, dynamic> data = {};
        if (result.result is String) {
          data = jsonDecode(result.result);
        } else if (result.result is Map) {
          data = Map<String, dynamic>.from(result.result);
        }

        final String newAccessToken = data['access'] ?? '';
        final String newRefreshToken = data['refresh'] ?? '';

        final prefs = await SharedPreferences.getInstance();
        if (newAccessToken.isNotEmpty) {
          await CacheService.saveToken(newAccessToken);
          await prefs.setString('access', newAccessToken);
          debugPrint("TokenRefreshService: Access token refreshed successfully.");
        }

        if (newRefreshToken.isNotEmpty) {
          await CacheService.saveRefreshToken(newRefreshToken);
          await prefs.setString('refresh', newRefreshToken);
        }
      } else {
        debugPrint("TokenRefreshService: Failed to refresh token. StatusCode: ${result.statusCode}");
      }
    } catch (e) {
      debugPrint("TokenRefreshService: Error refreshing token: $e");
    }
  }
}
