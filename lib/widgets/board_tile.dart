import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final bool isWinningCell;
  final Color symbolColor;

  const BoardTile({
    super.key,
    required this.value,
    required this.onTap,
    required this.isWinningCell,
    required this.symbolColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:
              isWinningCell
                  ? symbolColor.withOpacity(0.2)
                  : const Color.fromARGB(255, 49, 50, 51),
          border: Border.all(
            color:
                isWinningCell
                    ? symbolColor
                    : const Color.fromARGB(255, 81, 83, 85),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: symbolColor,
            ),
          ),
        ),
      ),
    );
  }
}

