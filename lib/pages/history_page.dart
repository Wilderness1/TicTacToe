import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: FutureBuilder<List<String>>(
        future: StorageService.getHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data!;
          return ListView.builder(
            itemCount: games.length,
            itemBuilder:
                (context, index) => ListTile(title: Text(games[index])),
          );
        },
      ),
    );
  }
}
