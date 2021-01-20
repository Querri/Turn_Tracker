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
                  color: _getContainerColor(context, turnTracker.checkReadiness(1)),
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
                        color: _getReadyButtonColor(context, turnTracker.checkReadiness(1)),
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
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                            },
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                            },
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(30),
                            shape: CircleBorder(),
                            child: Text(''),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(turnTracker.getActionText()[0]),
                          Text(turnTracker.getActionText()[1]),
                          Text(turnTracker.getActionText()[2]),
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
                  color: _getContainerColor(context, turnTracker.checkReadiness(0)),
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
                      color: _getReadyButtonColor(context, turnTracker.checkReadiness(0)),
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
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                          },
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                          },
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(30),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(turnTracker.getActionText()[0]),
                        Text(turnTracker.getActionText()[1]),
                        Text(turnTracker.getActionText()[2]),
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
  Color _getContainerColor(context, isReady) {
    if (isReady) {
      return Theme.of(context).colorScheme.primaryVariant;
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }

  /// Get color for a button based on its state.
  Color _getReadyButtonColor(context, isReady) {
    if (isReady) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }
}
