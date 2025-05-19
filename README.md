# TicTacToe
Project For Programming Tech
A customizable 2-player Tic-Tac-Toe game where you can define the board size (`N x M`) and winning condition (`K` in a row). Built using Flutter.

##  Features
- Player Setup Page:
  - Input names and choose game symbols (X or O)
  - Enter board configuration: N (rows), M (columns), K (marks to win)
- Game Page:
  - Dynamically rendered game board
  - Turn tracking and win/draw detection
- Game Result Modal:
  - Shows winner or draw
  - Buttons to restart or exit
- Game History Page:
  - Stores results of previous games with date/time and board configuration
- Local Storage:
  - Uses `SharedPreferences` to persist game history(Make sure that you have already added Sharedpreferences and intl as dependencies)

##  Project Structure
```
lib/
├── main.dart
├── pages/
│   ├── player_setup_page.dart
│   ├── game_page.dart
│   └── history_page.dart
├── widgets/
│   ├── board_tile.dart
│   └── result_modal.dart
├── services/
│   └── storage_service.dart
```

##  Contributors
- Member 1: Jabrayilov Mayil – Game Logic,Player Setup Page,Storage,UI, Documentation
- Member 2: Khayal Rzayev – Simple Model of game,Some changes in game Logic(Auto aligment for each box & font),fixing some Errors
- Member 3: Eyvazli Ravan –  History page ,Some UI changes ,Design ideas ,Fixing errors.
