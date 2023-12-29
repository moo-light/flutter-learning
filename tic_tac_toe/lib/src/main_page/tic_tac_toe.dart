import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/main_page/O.dart';
import 'package:tic_tac_toe/src/main_page/X.dart';

class TicTacToe extends StatefulWidget {
  TicTacToe({super.key});
  var initSquares = <Widget?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];
  int playerX = 0, playerO = 0;
  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  var X = const XWidget();
  var O = const OWidget();

  var squares = <Widget?>[null, null, null, null, null, null, null, null, null];
  var turn = true;
  var start = 'X';

  String? _winner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: Center(child: Text("Tic Tac Toe")),
        actions: [
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _restart,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Player X"),
                  Text(widget.playerX.toString(), style: textStyle()),
                ],
              ),
              SizedBox(
                child: Container(),
                width: MediaQuery.of(context).size.width / 3,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Player O"),
                  Text(
                    widget.playerO.toString(),
                    style: textStyle(),
                  ),
                ],
              )
            ],
          )),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).iconTheme.color!,
                    width: 5.0,
                  ),
                ),
                child: MaterialButton(
                  onPressed: () => setState(() {
                    if (_winner != null) return;
                    if (squares[index] == null) {
                      squares[index] = _buildTurn(turn, start);
                      var winningSymbol = _checkWinner();
                      if (winningSymbol != null) {
                        setState(() {
                          _winner = winningSymbol == X ? 'X' : 'O';
                          winningSymbol == X
                              ? widget.playerX++
                              : widget.playerO++;
                        });
                      }

                      turn = !turn;
                    }
                  }),
                  child: squares[index] ?? Container(),
                ),
              ),
              itemCount: squares.length,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _gameInfomation(),
                style: textStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(fontSize: 30);
  }

  Widget? _buildTurn(turn, start) {
    switch (start) {
      case 'X':
        return turn ? X : O;
      case 'O':
        return turn ? O : X;
    }
    return null;
  }

  Widget? _checkWinner() {
    // Define the winning combinations (rows, columns, diagonals)
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    // Check each winning combination
    for (var combination in winningCombinations) {
      var symbol = squares[combination[0]];
      if (symbol != null &&
          squares[combination[1]] == symbol &&
          squares[combination[2]] == symbol) {
        return symbol;
      }
    }

    // No winner found
    return null;
  }

  void _restart() {
    if (_winner != null) {
      start = _winner == 'X' ? 'O' : 'X';
      _winner = null;
    }
    turn = true;
    squares = List.from(widget.initSquares);
    setState(() {});
  }

  String _gameInfomation() {
    if (_winner != null) {
      return "Winner $_winner";
    }
    if (!squares.contains(null)) {
      return "It's a tie!";

    }
    return "${_buildTurn(turn, start) == X ? 'X' : 'O'}'s Turn";
  }
}
