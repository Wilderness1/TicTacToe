import 'package:flutter/material.dart';
import '../widgets/board_tile.dart';
import '../widgets/result_modal.dart';
import '../services/storage_service.dart';

class GamePage extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final String player1Symbol;
  final String player2Symbol;
  final int rows;
  final int cols;
  final int kToWin;

  const GamePage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.player1Symbol,
    required this.player2Symbol,
    required this.rows,
    required this.cols,
    required this.kToWin,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String>> board;
  late String currentPlayer;
  late String currentSymbol;
  bool gameOver = false;
  String winner = '';

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    board = List.generate(widget.rows, (_) => List.filled(widget.cols, ''));
    currentPlayer = widget.player1Name;
    currentSymbol = widget.player1Symbol;
  }

  void _makeMove(int row, int col) {
    if (gameOver || board[row][col].isNotEmpty) return;

    setState(() {
      board[row][col] = currentSymbol;
      if (_checkWin(row, col)) {
        gameOver = true;
        winner = currentPlayer;
        StorageService.saveGame(
          widget.player1Name,
          widget.player2Name,
          '$winner won',
          '${widget.rows}x${widget.cols}x${widget.kToWin}',
        );
      } else if (_isDraw()) {
        gameOver = true;
        winner = 'Draw';
        StorageService.saveGame(
          widget.player1Name,
          widget.player2Name,
          'Draw',
          '${widget.rows}x${widget.cols}x${widget.kToWin}',
        );
      } else {
        currentPlayer =
            currentPlayer == widget.player1Name
                ? widget.player2Name
                : widget.player1Name;
        currentSymbol =
            currentSymbol == widget.player1Symbol
                ? widget.player2Symbol
                : widget.player1Symbol;
      }
    });
  }

  bool _isDraw() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  bool _checkWin(int row, int col) {
    return _count(row, col, 1, 0) + _count(row, col, -1, 0) + 1 >=
            widget.kToWin ||
        _count(row, col, 0, 1) + _count(row, col, 0, -1) + 1 >= widget.kToWin ||
        _count(row, col, 1, 1) + _count(row, col, -1, -1) + 1 >=
            widget.kToWin ||
        _count(row, col, 1, -1) + _count(row, col, -1, 1) + 1 >= widget.kToWin;
  }

  int _count(int row, int col, int dRow, int dCol) {
    int count = 0;
    int i = row + dRow, j = col + dCol;
    while (i >= 0 &&
        i < widget.rows &&
        j >= 0 &&
        j < widget.cols &&
        board[i][j] == currentSymbol) {
      count++;
      i += dRow;
      j += dCol;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.rows}x${widget.cols} Game')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            gameOver ? 'Game Over' : "$currentPlayer's Turn ($currentSymbol)",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: widget.rows * widget.cols,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cols,
              ),
              itemBuilder: (_, index) {
                int row = index ~/ widget.cols;
                int col = index % widget.cols;
                return BoardTile(
                  value: board[row][col],
                  onTap: () => _makeMove(row, col),
                );
              },
            ),
          ),
          if (gameOver)
            ResultModal(
              winner: winner,
              onRestart: () => setState(_initBoard),
              onExit: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}
