import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spirit_island_app/turn_tracker.dart';


/// View that is displayed while playing.
///
/// Contains turn tracker, which is customized according
/// to selected game and the number of players.
class GameView extends StatefulWidget {

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  TurnTracker _turnTracker = new TurnTracker('Spirit Island', 2);

  /// Toggle ready button and check if all players are ready.
  void _toggleReady(playerNum) {
    setState(() {
      _turnTracker.toggleReadiness(playerNum);

      if (_turnTracker.checkReadiness(null)) {
        _turnTracker.resetReadiness();
      }
    });
  }

  /// Toggle action button.
  ///
  /// playerAction[0] is player number and [1] is action button number.
  void _toggleAction(List<int> playerAction) {
    if (_turnTracker.areActionsAvailable()) {
      setState(() {
        _turnTracker.toggleAction(playerAction[0], playerAction[1]);
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
            PlayerSection(
              turnTracker: _turnTracker,
              playerNum: 1,
              toggleReady: _toggleReady,
              toggleAction: _toggleAction,
            ),
            PlayerSection(
                turnTracker: _turnTracker,
                playerNum: 0,
                toggleReady: _toggleReady,
                toggleAction: _toggleAction,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // Enable full screen.
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    // Disable full screen.
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }
}


/// Section for a player.
///
/// Player 0 is right way up and player 1 is upside down.
class PlayerSection extends StatelessWidget {
  PlayerSection({this.turnTracker, this.playerNum,
    @required this.toggleReady, @required this.toggleAction});
  final turnTracker;
  final playerNum;
  final ValueChanged<int> toggleReady;
  final ValueChanged<List<int>> toggleAction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: _getRotation(playerNum),
        child: Container(
          decoration: BoxDecoration(
            color: _getContainerColor(context, playerNum),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
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
                color: _getReadyButtonColor(context, playerNum),
                padding: EdgeInsets.all(100),
                shape: CircleBorder(),
                child: Text(''),
                onPressed: () {
                  toggleReady(playerNum);
                  //_toggleReadiness(0);
                },
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    color: _getActionButtonColor(context, playerNum, 0),
                    padding: EdgeInsets.all(30),
                    shape: CircleBorder(),
                    child: Text(''),
                    onPressed: () {
                      //_toggleAction(0, 0);
                      toggleAction([playerNum, 0]);
                    },
                  ),
                  FlatButton(
                    color: _getActionButtonColor(context, playerNum, 1),
                    padding: EdgeInsets.all(30),
                    shape: CircleBorder(),
                    child: Text(''),
                    onPressed: () {
                      //_toggleAction(0, 1);
                      toggleAction([playerNum, 1]);
                    },
                  ),
                  FlatButton(
                    color: _getActionButtonColor(context, playerNum, 2),
                    padding: EdgeInsets.all(30),
                    shape: CircleBorder(),
                    child: Text(''),
                    onPressed: () {
                      //_toggleAction(0, 2);
                      toggleAction([playerNum, 2]);
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
    );
  }

  /// Get rotation value for each player.
  int _getRotation(playerNum) {
    switch (playerNum) {
      case 1: return 2;
    }
    return 0;
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
