import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const BoardTile({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
