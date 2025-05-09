import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String key = 'game_history';

  static Future<void> saveGame(
    String p1,
    String p2,
    String result,
    String config,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    final newGame = jsonEncode({
      'player1': p1,
      'player2': p2,
      'result': result,
      'config': config,
      'timestamp': now,
    });

    final history = prefs.getStringList(key) ?? [];
    history.add(newGame);
    await prefs.setStringList(key, history);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((item) => jsonDecode(item)).cast<Map<String, dynamic>>().toList();
  }
}
