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
  List<List<int>> winningLine = [];
  Offset? lineStart;
  Offset? lineEnd;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    board = List.generate(widget.rows, (_) => List.filled(widget.cols, ''));
    currentPlayer = widget.player1Name;
    currentSymbol = widget.player1Symbol;
    gameOver = false;
    winner = '';
    winningLine = [];
    lineStart = null;
    lineEnd = null;
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
    List<List<int>> directions = [
      [1, 0],
      [0, 1],
      [1, 1],
      [1, -1],
    ];
    for (var dir in directions) {
      int count = 1;
      List<List<int>> line = [
        [row, col],
      ];

      for (int i = 1; i < widget.kToWin; i++) {
        int r = row + dir[0] * i;
        int c = col + dir[1] * i;
        if (r < 0 || r >= widget.rows || c < 0 || c >= widget.cols) break;
        if (board[r][c] != currentSymbol) break;
        count++;
        line.add([r, c]);
      }

      for (int i = 1; i < widget.kToWin; i++) {
        int r = row - dir[0] * i;
        int c = col - dir[1] * i;
        if (r < 0 || r >= widget.rows || c < 0 || c >= widget.cols) break;
        if (board[r][c] != currentSymbol) break;
        count++;
        line.insert(0, [r, c]);
      }

      if (count >= widget.kToWin) {
        winningLine = line;
        if (line.length >= 2) {
          lineStart = Offset(
            line.first[1].toDouble(),
            line.first[0].toDouble(),
          );
          lineEnd = Offset(line.last[1].toDouble(), line.last[0].toDouble());
        }
        return true;
      }
    }
    return false;
  }

  Color getSymbolColor(String symbol) {
    if (symbol == 'X') return Colors.orangeAccent;
    if (symbol == 'O') return Colors.deepPurpleAccent;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                '${widget.rows}x${widget.cols} Tic-Tac-Toe',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                gameOver
                    ? (winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!')
                    : "$currentPlayer's Turn ($currentSymbol)",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: widget.cols / widget.rows,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          GridView.builder(
                            itemCount: widget.rows * widget.cols,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widget.cols,
                                ),
                            itemBuilder: (_, index) {
                              int row = index ~/ widget.cols;
                              int col = index % widget.cols;
                              String symbol = board[row][col];
                              return BoardTile(
                                value: symbol,
                                onTap: () => _makeMove(row, col),
                                isWinningCell: winningLine.any(
                                  (coord) => coord[0] == row && coord[1] == col,
                                ),
                                symbolColor: getSymbolColor(symbol),
                              );
                            },
                          ),
                          if (lineStart != null && lineEnd != null)
                            CustomPaint(
                              size: Size.infinite,
                              painter: WinningLinePainter(
                                start: lineStart,
                                end: lineEnd,
                                rows: widget.rows,
                                cols: widget.cols,
                                color: getSymbolColor(currentSymbol),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (gameOver)
                ResultModal(
                  winner: winner,
                  onRestart: () => setState(() => _initBoard()),
                  onExit: () => Navigator.pop(context),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  final Offset? start;
  final Offset? end;
  final int rows;
  final int cols;
  final Color color;

  WinningLinePainter({
    required this.start,
    required this.end,
    required this.rows,
    required this.cols,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;

    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    final startPx = Offset(
      start!.dx * cellWidth + cellWidth / 2,
      start!.dy * cellHeight + cellHeight / 2,
    );

    final endPx = Offset(
      end!.dx * cellWidth + cellWidth / 2,
      end!.dy * cellHeight + cellHeight / 2,
    );

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(startPx, endPx, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
