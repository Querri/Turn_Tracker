
import 'package:flutter/material.dart';


class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool readyPlayer1 = false;
  bool readyPlayer2 = false;
  int gamePhase = 1;

  /// Toggle Ready button and check if all players are ready.
  void _toggleReadiness(playerNum) {
    setState(() {
      switch (playerNum) {
        case 1: readyPlayer1 = !readyPlayer1;
        break;
        case 2: readyPlayer2 = !readyPlayer2;
      }

      if (readyPlayer1 && readyPlayer2) {
        readyPlayer1 = false;
        readyPlayer2 = false;

        if (gamePhase < 4) {
          gamePhase += 1;
        } else {
          gamePhase = 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: RaisedButton(
                onPressed: () {
                  _toggleReadiness(2);
                },
                child: Text('READY'),
              ),
            ),
            RotatedBox(
              quarterTurns: 2,
              child: Text('GamePhase: ' + gamePhase.toString()),
            ),
            Text('GamePhase: ' + gamePhase.toString()),
            RaisedButton(
              onPressed: () {
                _toggleReadiness(1);
              },
              child: Text('READY'),
            ),
          ],
        ),
      ),
    );
  }
}