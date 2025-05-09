import 'package:flutter/material.dart';
import 'pages/player_setup_page.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe NxMxK',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PlayerSetupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
