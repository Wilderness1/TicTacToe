import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: StorageService.getHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data!;
          if (games.isEmpty) {
            return const Center(child: Text('No games played yet.'));
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                title: Text('${game['player1']} vs ${game['player2']}'),
                subtitle: Text(
                  '${game['result']} • ${game['config']} • ${formatDate(game['timestamp'])}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
