
import 'package:flutter/material.dart';


class GameView extends StatefulWidget {
  final gameName = 'Spirit Island';
  final phaseCount = _getPhaseCount('Spirit Island');
  final playerCount = 2;

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool readyPlayer1 = false;
  bool readyPlayer2 = false;
  int currentPhase = 1;

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

        if (currentPhase < 4) {
          currentPhase += 1;
        } else {
          currentPhase = 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _getContainerColor(context, readyPlayer2),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(100),
                  ),
                ),
                width: double.infinity,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _getPhaseText('Spirit Island', currentPhase),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      FlatButton(
                        color: _getReadyButtonColor(context, readyPlayer2),
                        padding: EdgeInsets.all(100),
                        shape: CircleBorder(),
                        onPressed: () {
                          _toggleReadiness(2);
                        },
                        child: Text('READY'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _getContainerColor(context, readyPlayer1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(100),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _getPhaseText('Spirit Island', currentPhase),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    FlatButton(
                      color: _getReadyButtonColor(context, readyPlayer1),
                      padding: EdgeInsets.all(100),
                      shape: CircleBorder(),
                      onPressed: () {
                        _toggleReadiness(1);
                      },
                      child: Text('READY'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getContainerColor(context, isReady) {
  if (isReady) {
    return Theme.of(context).colorScheme.primaryVariant;
  } else {
    return Theme.of(context).colorScheme.background;
  }
}

Color _getReadyButtonColor(context, isReady) {
  if (isReady) {
    return Theme.of(context).colorScheme.primary;
  } else {
    return Theme.of(context).colorScheme.secondary;
  }
}

/// Get the number of phases in a game.
int _getPhaseCount(gameName) {
  switch (gameName) {
    case ('Spirit Island'): return 5;
    case ('Direwild'): return 3;
  }
  return 0;
}

/// Get the name of the phase.
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