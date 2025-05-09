import 'package:flutter/material.dart';

class ResultModal extends StatelessWidget {
  final String winner;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const ResultModal({
    super.key,
    required this.winner,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // prevents infinite height
      children: [
        Text(
          winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: onRestart, child: const Text('Restart')),
            const SizedBox(width: 16),
            ElevatedButton(onPressed: onExit, child: const Text('Exit')),
          ],
        ),
      ],
    );
  }
}
