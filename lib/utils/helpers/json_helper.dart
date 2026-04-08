import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart'; 

class JsonHelper {
  JsonHelper._();

  //=====================
  // GLOBAL YAJsonIsolate
  //=====================
  static final YAJsonIsolate _isolate = YAJsonIsolate();
  static bool _initialized = false;

  /// Initialize the global isolate (call once at app start)
  static Future<void> init() async {
    if (!_initialized) {
      await _isolate.initialize();
      _initialized = true;
    }
  }

  /// Dispose the global isolate
  static void dispose() {
    if (_initialized) {
      _isolate.dispose();
      _initialized = false;
    }
  }

  //=====================
  // SYNC METHODS
  //=====================

  static Map<String, dynamic> parse(String jsonString) {
    return Map<String, dynamic>.from(jsonDecode(jsonString) as Map);
  }

  static String encode(Map<String, dynamic> map) {
    return jsonEncode(map);
  }

  static Future<Map<String, dynamic>> loadFromAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return parse(jsonString);
  }

  static Future<T?> loadKeyFromAsset<T>(String path, String key) async {
    final map = await loadFromAsset(path);
    return map[key] as T?;
  }

  //=====================
  // ASYNC METHODS USING GLOBAL ISOLATE
  //=====================

  static Future<Map<String, dynamic>> parseAsync(String jsonString) async {
    await init();
    final result = await _isolate.decode(jsonString);
    return Map<String, dynamic>.from(result as Map);
  }

  static Future<String> encodeAsync(Map<String, dynamic> map) async {
    await init();
    return _isolate.encode(map);
  }

  static Future<Map<String, dynamic>> loadFromAssetAsync(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return parseAsync(jsonString);
  }

  static Future<T?> loadKeyFromAssetAsync<T>(String path, String key) async {
    final map = await loadFromAssetAsync(path);
    return map[key] as T?;
  }
}





