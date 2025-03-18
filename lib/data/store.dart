import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<bool> saveString(String value, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(value);
      final success = await prefs.setString(key, jsonString);
      print("Tentativa de salvar no SharedPreferences: $jsonString");
      return success;
    } catch (e) {
      print("Erro ao salvar no SharedPreferences: $e");
      return false;
    }
  }



  static Future<String> getString(String key,
      [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      final jsonString = await getString(key);
      print("Dados recuperados do SharedPreferences: $jsonString");
      return jsonString.isNotEmpty ? jsonDecode(jsonString) : {};
    } catch (e) {
      print("Erro ao recuperar os dados do SharedPreferences: $e");
      return {};
    }
  }



  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

}
