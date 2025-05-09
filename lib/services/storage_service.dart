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
    final now = DateTime.now().toString();
    final game = '$p1 vs $p2 | $result | $config | $now';
    final history = prefs.getStringList(key) ?? [];
    history.add(game);
    await prefs.setStringList(key, history);
  }

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
}
