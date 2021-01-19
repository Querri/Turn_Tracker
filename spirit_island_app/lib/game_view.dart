
import 'package:flutter/material.dart';


class GameView extends StatefulWidget {
  final gameName = 'Spirit Island';
  final playerCount = 2;

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool readyPlayer1 = false;
  bool readyPlayer2 = false;
  int phaseNum = 1;

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

        if (phaseNum < 4) {
          phaseNum += 1;
        } else {
          phaseNum = 1;
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
              child: Text(_getPhaseText('Spirit Island', phaseNum)),
            ),
            Text(_getPhaseText('Spirit Island', phaseNum)),
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

String _getPhaseText(gameName, phaseNum) {
  switch (gameName) {
    case ('Spirit Island'): {
      switch (phaseNum) {
        case 1: return 'Spirit Phase';
        case 2: return 'Fast Power Phase';
        case 3: return 'Invader Phase';
        case 4: return 'Slow Power Phase';
        case 5: return 'Time Passes';
      }
      break;
    }
    case ('Direwild'): {
      switch (phaseNum) {
        case 1: return 'Summon Phase';
        case 2: return 'Charm Phase';
        case 3: return 'Adventure Phase';
      }
    }
  }
  return 'No Phase Found';
}