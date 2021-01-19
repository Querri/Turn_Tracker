
import 'package:flutter/material.dart';


class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final gameName = 'Spirit Island';
  final phaseCount = _getPhaseCount('Spirit Island');
  final playerCount = 2;

  bool readyPlayer1 = false;
  bool readyPlayer2 = false;
  List<bool> checksPlayer1 = [false, false, false];
  List<bool> checksPlayer2 = [false, false, false];
  int currentPhase = 1;

  /// Toggle Ready button and check if all players are ready.
  void _toggleReadiness(playerNum) {
    setState(() {
      switch (playerNum) {
        case 1: {
          readyPlayer1 = !readyPlayer1;
          for (int i=0; i<3; i++) {
            checksPlayer1[i] = true;
          }
          break;
        }
        case 2: {
          readyPlayer2 = !readyPlayer2;
          for (int i=0; i<3; i++) {
            checksPlayer2[i] = true;
          }
        }
      }

      // Reset buttons and change phase if both are ready.
      if (readyPlayer1 && readyPlayer2) {
        readyPlayer1 = false;
        readyPlayer2 = false;
        for (int i=0; i < 3; i++) {
          checksPlayer1[i] = false;
          checksPlayer2[i] = false;
        }

        if (currentPhase < 4) {
          currentPhase += 1;
        } else {
          currentPhase = 1;
        }
      }
    });
  }

  void _toggleCheck(playerNum, checkNum) {
    setState(() {
      switch (playerNum) {
        case 1: checksPlayer1[checkNum] = !checksPlayer1[checkNum];
        break;
        case 2: checksPlayer2[checkNum] = !checksPlayer2[checkNum];
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
                        _getPhaseText(gameName, currentPhase),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      FlatButton(
                        color: _getReadyButtonColor(context, readyPlayer2, true),
                        padding: EdgeInsets.all(100),
                        shape: CircleBorder(),
                        onPressed: () {
                          _toggleReadiness(2);
                        },
                        child: Text('READY'),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            color: _getReadyButtonColor(context, checksPlayer2[0], false),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            onPressed: () {
                              _toggleCheck(2, 0);
                            },
                            child: Text(''),
                          ),
                          FlatButton(
                            color: _getReadyButtonColor(context, checksPlayer2[1], false),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            onPressed: () {
                              _toggleCheck(2, 1);
                            },
                            child: Text(''),
                          ),
                          FlatButton(
                            color: _getReadyButtonColor(context, checksPlayer2[2], false),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            onPressed: () {
                              _toggleCheck(2, 2);
                            },
                            child: Text(''),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('GROWTH'),
                          Text('ENERGY'),
                          Text('CARDS'),
                        ],
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
                      _getPhaseText(gameName, currentPhase),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    FlatButton(
                      color: _getReadyButtonColor(context, readyPlayer1, true),
                      padding: EdgeInsets.all(100),
                      shape: CircleBorder(),
                      onPressed: () {
                        _toggleReadiness(1);
                      },
                      child: Text('READY'),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          color: _getReadyButtonColor(context, checksPlayer1[0], false),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          onPressed: () {
                            _toggleCheck(1, 0);
                          },
                          child: Text(''),
                        ),
                        FlatButton(
                          color: _getReadyButtonColor(context, checksPlayer1[1], false),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          onPressed: () {
                            _toggleCheck(1, 1);
                          },
                          child: Text(''),
                        ),
                        FlatButton(
                          color: _getReadyButtonColor(context, checksPlayer1[2], false),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          onPressed: () {
                            _toggleCheck(1, 2);
                          },
                          child: Text(''),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('GROWTH'),
                        Text('ENERGY'),
                        Text('CARDS'),
                      ],
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

/// Get background color for either player based on their ready state.
Color _getContainerColor(context, isReady) {
  if (isReady) {
    return Theme.of(context).colorScheme.primaryVariant;
  } else {
    return Theme.of(context).colorScheme.background;
  }
}

/// Get color for a button based on its state.
Color _getReadyButtonColor(context, isReady, isReadyButton) {
  if (isReady) {
    if (isReadyButton) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
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