import 'package:flutter/material.dart';
import 'game_page.dart';

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

  String _player1Symbol = 'X';
  String _player2Symbol = 'O';

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
      appBar: AppBar(title: const Text('Setup Game')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Player 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _player1Controller,
                decoration: const InputDecoration(labelText: 'Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter Player 1 name' : null,
              ),
              DropdownButtonFormField<String>(
                value: _player1Symbol,
                items:
                    ['X', 'O']
                        .map(
                          (symbol) => DropdownMenuItem(
                            value: symbol,
                            child: Text(symbol),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _player1Symbol = value!;
                    _player2Symbol = _player1Symbol == 'X' ? 'O' : 'X';
                  });
                },
                decoration: const InputDecoration(labelText: 'Symbol'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Player 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _player2Controller,
                decoration: const InputDecoration(labelText: 'Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter Player 2 name' : null,
              ),
              TextFormField(
                initialValue: _player2Symbol,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Symbol (auto)'),
              ),
              const Divider(height: 40),
              const Text(
                'Board Configuration',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _rowsController,
                decoration: const InputDecoration(labelText: 'Rows (N)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter N' : null,
              ),
              TextFormField(
                controller: _colsController,
                decoration: const InputDecoration(labelText: 'Columns (M)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter M' : null,
              ),
              TextFormField(
                controller: _kController,
                decoration: const InputDecoration(labelText: 'K to win'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter K' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
