import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spirit_island_app/turn_tracker.dart';


class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  TurnTracker turnTracker = new TurnTracker('Spirit Island', 2);

  /// Toggle Ready button and check if all players are ready.
  void _toggleReadiness(playerNum) {
    setState(() {
      turnTracker.toggleReadiness(playerNum);

      if (turnTracker.checkReadiness(null)) {
        turnTracker.resetReadiness();
      }
    });
  }

  void _toggleAction(playerNum, actionNum) {
    if (turnTracker.areActionsAvailable()) {
      setState(() {
        turnTracker.toggleAction(playerNum, actionNum);
      });
    } else {
      return null;
    }
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
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: _getContainerColor(context, 1),
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
                        turnTracker.getPhaseText(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      FlatButton(
                        color: _getReadyButtonColor(context, 1),
                        padding: EdgeInsets.all(100),
                        shape: CircleBorder(),
                        child: Text(''),
                        onPressed: () {
                          _toggleReadiness(1);
                        },
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            color: _getActionButtonColor(context, 1, 0),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                              _toggleAction(1, 0);
                            },
                          ),
                          FlatButton(
                            color: _getActionButtonColor(context, 1, 1),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                              _toggleAction(1, 1);
                            },
                          ),
                          FlatButton(
                            color: _getActionButtonColor(context, 1, 2),
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                              _toggleAction(1, 2);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            turnTracker.getActionText()[0],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            turnTracker.getActionText()[1],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            turnTracker.getActionText()[2],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
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
                  color: _getContainerColor(context, 0),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(100),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      turnTracker.getPhaseText(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    FlatButton(
                      color: _getReadyButtonColor(context, 0),
                      padding: EdgeInsets.all(100),
                      shape: CircleBorder(),
                      child: Text(''),
                      onPressed: () {
                        _toggleReadiness(0);
                      },
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          color: _getActionButtonColor(context, 0, 0),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            _toggleAction(0, 0);
                          },
                        ),
                        FlatButton(
                          color: _getActionButtonColor(context, 0, 1),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            _toggleAction(0, 1);
                          },
                        ),
                        FlatButton(
                          color: _getActionButtonColor(context, 0, 2),
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            _toggleAction(0, 2);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            turnTracker.getActionText()[0],
                            style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          turnTracker.getActionText()[1],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          turnTracker.getActionText()[2],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
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

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  /// Get background color for either player based on their ready state.
  Color _getContainerColor(context, playerNum) {
    if (turnTracker.checkReadiness(playerNum)) {
      return Theme.of(context).colorScheme.primaryVariant;
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }

  /// Get color for a button based on its state.
  Color _getReadyButtonColor(context, playerNum) {
    if (turnTracker.checkReadiness(playerNum)) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }

  /// Get color for a button based on its state.
  Color _getActionButtonColor(context, playerNum, actionNum) {
    if (turnTracker.areActionsAvailable()) {
      if (turnTracker.checkAction(playerNum, actionNum)) {
        return Theme.of(context).colorScheme.primary;
      } else {
        return Theme.of(context).colorScheme.secondary;
      }
    } else {
      if (turnTracker.checkReadiness(playerNum)) {
        return Theme.of(context).colorScheme.primaryVariant;
      } else {
        return Theme.of(context).colorScheme.background;
      }
    }
  }
}
