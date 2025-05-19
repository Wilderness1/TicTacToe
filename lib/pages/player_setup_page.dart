import 'package:flutter/material.dart';
import 'game_page.dart';
import 'history_page.dart';

class PlayerSetupPage extends StatefulWidget {
  const PlayerSetupPage({super.key});

  @override
  State<PlayerSetupPage> createState() => _PlayerSetupPageState();
}

class _PlayerSetupPageState extends State<PlayerSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _colsController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _player2SymbolController =
      TextEditingController();

  String _player1Symbol = 'X';
  String _player2Symbol = 'O';

  @override
  void initState() {
    super.initState();
    _player2SymbolController.text = _player2Symbol;
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final int rows = int.parse(_rowsController.text);
      final int cols = int.parse(_colsController.text);
      final int k = int.parse(_kController.text);

      if (k > rows && k > cols) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('K must not be greater than N or M')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => GamePage(
                player1Name: _player1Controller.text,
                player2Name: _player2Controller.text,
                player1Symbol: _player1Symbol,
                player2Symbol: _player2Symbol,
                rows: rows,
                cols: cols,
                kToWin: k,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0C3FC),
      appBar: AppBar(
        title: const Text(
          'Setup Game',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8ec5fc),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 120, 159, 197),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 89, 47, 117).withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                _sectionTitle('Player 1'),
                _spacer(),
                _textInput(_player1Controller, 'Name', 'Enter Player 1 name'),
                _spacer(),
                _dropdownInput(),
                _sectionTitle('Player 2'),
                _spacer(),
                _textInput(_player2Controller, 'Name', 'Enter Player 2 name'),
                _spacer(),
                _readonlyTextInput(_player2SymbolController, 'Symbol (auto)'),
                const Divider(height: 40, color: Colors.grey),
                _sectionTitle('Board Configuration'),
                _spacer(),
                _numericInput(_rowsController, 'Rows (N)', 'Enter N'),
                _spacer(),
                _numericInput(_colsController, 'Columns (M)', 'Enter M'),
                _spacer(),
                _numericInput(_kController, 'K to win', 'Enter K'),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 179, 175),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _startGame,
                  child: const Text('Start Game'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 149, 201, 195),
                    ),
                  ),
                  child: const Text('View History'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _spacer() => const SizedBox(height: 10);

  Widget _textInput(
    TextEditingController controller,
    String label,
    String errorMsg,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: (value) => value!.isEmpty ? errorMsg : null,
    );
  }

  Widget _readonlyTextInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
    );
  }

  Widget _numericInput(
    TextEditingController controller,
    String label,
    String errorMsg,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? errorMsg : null,
    );
  }

  Widget _dropdownInput() {
    return DropdownButtonFormField<String>(
      value: _player1Symbol,
      dropdownColor: const Color(0xFF3C3C3C),
      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      items:
          ['X', 'O'].map((symbol) {
            return DropdownMenuItem(value: symbol, child: Text(symbol));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _player1Symbol = value!;
          _player2Symbol = _player1Symbol == 'X' ? 'O' : 'X';
          _player2SymbolController.text = _player2Symbol;
        });
      },
      decoration: _inputDecoration('Symbol for Player 1'),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF3C3C3C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
