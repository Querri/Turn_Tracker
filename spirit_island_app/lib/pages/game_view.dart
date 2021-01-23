import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spirit_island_app/turn_tracker.dart';


/// View that is displayed while playing.
///
/// Contains turn tracker, which is customized according
/// to selected game and the number of players.
class GameView extends StatefulWidget {
  final String gameName;
  final int playerCount;

  GameView({Key key, @required this.gameName, @required this.playerCount}) :super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  /// Create turn tracker.
  TurnTracker _turnTracker = new TurnTracker();

  /// Toggle ready button and check if all players are ready.
  void _toggleReady(playerNum) {
    setState(() {
      if (playerNum == -1) {
        _turnTracker.goBack();
      } else {
        _turnTracker.toggleReadiness(playerNum);

        if (_turnTracker.checkReadiness(null)) {
          _turnTracker.resetReadiness();
        }
      }
    });
  }

  /// Toggle action button.
  ///
  /// playerAction[0] is player number and [1] is action button number.
  void _toggleAction(List<int> playerAction) {
    if (_turnTracker.isActionAvailable(playerAction[1])) {
      setState(() {
        _turnTracker.toggleAction(playerAction[0], playerAction[1]);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_turnTracker.initDone) {
      _turnTracker.init(widget.gameName, widget.playerCount);
    }
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
          padding: EdgeInsets.only(bottom: _getPadding(playerNum)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      toggleReady(-1);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      turnTracker.getPhaseText(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
              FlatButton(
                color: _getReadyButtonColor(context, playerNum),
                padding: EdgeInsets.all(100),
                shape: CircleBorder(),
                child: Text('READY'),
                onPressed: () {
                  toggleReady(playerNum);
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          color: _getActionButtonColor(context, playerNum, 0),
                          padding: EdgeInsets.all(25),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            toggleAction([playerNum, 0]);
                          },
                        ),
                        Text(
                          turnTracker.getActionText()[0],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          color: _getActionButtonColor(context, playerNum, 1),
                          padding: EdgeInsets.all(25),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            toggleAction([playerNum, 1]);
                          },
                        ),
                        Text(
                          turnTracker.getActionText()[1],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          color: _getActionButtonColor(context, playerNum, 2),
                          padding: EdgeInsets.all(25),
                          shape: CircleBorder(),
                          child: Text(''),
                          onPressed: () {
                            toggleAction([playerNum, 2]);
                          },
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
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  /// Get rotation value for each player.
  int _getRotation(playerNum) {
    switch (playerNum) {
      case 0: return 0;
      case 1: return 2;
    }
    return 0;
  }

  /// Get padding value for each player.
  double _getPadding(playerNum) {
    if (playerNum == 1) return 30;
    else return 0;
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
    if (turnTracker.isActionAvailable(actionNum)) {
      if (turnTracker.checkAction(playerNum, actionNum)) {
        return Theme.of(context).colorScheme.primary;
      } else {
        return Theme.of(context).colorScheme.secondary;
      }
    } else {
      if (turnTracker.checkReadiness(playerNum)) {
        return Theme.of(context).colorScheme.background;
      } else {
        return Theme.of(context).colorScheme.background;
      }
    }
  }
}
