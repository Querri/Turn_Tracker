import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/screen.dart';

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
        _turnTracker.changePhase(-1);

      } else {
        _turnTracker.toggleReadiness(playerNum);

        if (_turnTracker.checkReadiness(null)) {
          _turnTracker.changePhase(1);
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
    Screen.keepOn(true);

    if (!_turnTracker.initDone) {
      _turnTracker.init(widget.gameName, widget.playerCount);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (widget.playerCount == 2)
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
    final Size size = MediaQuery.of(context).size;
    final actionText = turnTracker.getActionText();

    return Expanded(
      child: RotatedBox(
        quarterTurns: _getRotation(playerNum),
        child: Container(
          margin: EdgeInsets.only(bottom: _getMargin(playerNum)),
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
                    icon: Icon(Icons.arrow_left),
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      toggleReady(-1);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      turnTracker.getPhaseText(),
                      style: Theme.of(context).textTheme.headline4
                          .merge(GoogleFonts.alegreyaSansSc()),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      toggleReady(-1);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: size.width,
                          height: 200,
                          child:
                            Container(
                              width: size.width,
                              height: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ActionButton(
                                    turnTracker: turnTracker,
                                    playerNum: playerNum,
                                    actionNum: 0,
                                    actionText: actionText[0],
                                    toggleAction: toggleAction,
                                  ),
                                  ActionButton(
                                    turnTracker: turnTracker,
                                    playerNum: playerNum,
                                    actionNum: 1,
                                    actionText: actionText[1],
                                    toggleAction: toggleAction,
                                  ),
                                  ActionButton(
                                    turnTracker: turnTracker,
                                    playerNum: playerNum,
                                    actionNum: 2,
                                    actionText: actionText[2],
                                    toggleAction: toggleAction,
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                      Center(
                        heightFactor: 1.8,
                        child: FlatButton(
                          color: _getReadyButtonColor(context, playerNum),
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder(),
                          //child: SvgPicture.asset('button-03.svg'),
                          child: Image(
                            width: 180,
                            image: AssetImage('button.png'),
                          ),
                          /*child: Text(
                            'READY',
                            style: Theme.of(context).textTheme.bodyText1
                                .merge(GoogleFonts.alegreyaSansSc())
                                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          ),*/
                          onPressed: () {
                            toggleReady(playerNum);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get rotation value for each player.
  int _getRotation(playerNum) {
    if (playerNum == 1) return 2;
    else return 0;
  }

  /// Get padding value for each player.
  double _getMargin(playerNum) {
    if (playerNum == 1) return 0;
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
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }
}

/// An action button.
class ActionButton extends StatelessWidget {
  ActionButton({this.turnTracker, this.playerNum, this.actionNum, this.actionText, @required this.toggleAction});
  final turnTracker;
  final playerNum;
  final actionNum;
  final actionText;
  final ValueChanged<List<int>> toggleAction;

  @override
  Widget build(BuildContext context) {
    final color = _getActionButtonColor(context, playerNum, actionNum);

    final Size size = MediaQuery.of(context).size;
    double width = size.width;
    if (actionNum == 1) width = width*0.40;
    else width = width*0.30;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            toggleAction([playerNum, actionNum]);
            },
          child: CustomPaint(
            size: Size(width, 200),
            painter: ButtonCustomPainter(color, playerNum, actionNum),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 35),
          width: width,
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodyText1
                .merge(GoogleFonts.roboto())
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  /// Get color for a button based on its state.
  Color _getActionButtonColor(context, playerNum, actionNum) {
    if (turnTracker.isActionAvailable(actionNum)) {
      if (turnTracker.checkAction(playerNum, actionNum)) {
        return Theme.of(context).colorScheme.secondary;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    } else {
      return Theme.of(context).colorScheme.primaryVariant;
    }
  }
}


/// Painter for one action button.
class ButtonCustomPainter extends CustomPainter {
  final buttonColor;
  final playerNum;
  final actionNum;
  ButtonCustomPainter(this.buttonColor, this.playerNum, this.actionNum);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = buttonColor..style = PaintingStyle.fill;

    if (actionNum == 0) {
      Path path = Path()..moveTo(0, size.height*0.05);
      path.quadraticBezierTo(size.width*0.30, 0, size.width, size.height*0.40);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else if (actionNum == 1) {
      Path path = Path()..moveTo(0, size.height*0.40);
      path.quadraticBezierTo(size.width*0.50, size.height*0.75, size.width, size.height*0.40);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      Path path = Path()..moveTo(0, size.height*0.40);
      path.quadraticBezierTo(size.width*0.70, 0, size.width, size.height*0.05);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}