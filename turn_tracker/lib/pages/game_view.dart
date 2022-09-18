import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'package:spirit_island_app/pages/game_view_animator.dart';
import 'package:spirit_island_app/pages/main_view_animator.dart';
import 'package:spirit_island_app/pages/sections/player_section.dart';
import 'package:spirit_island_app/pages/sections/player_section_symmetric.dart';
import 'package:spirit_island_app/pages/sections/action_button_bar.dart';
import 'package:spirit_island_app/turn_tracker.dart';
import 'package:spirit_island_app/models/game.dart';


/// View that is displayed while playing.
///
/// Contains turn tracker, which is customized according
/// to selected game and the number of players.
class GameView extends StatefulWidget {
  final Game game;
  final int playerCount;

  GameView({Key key, @required this.game, @required this.playerCount}) :super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  /// Create turn tracker.
  TurnTracker _turnTracker = new TurnTracker();

  /// Toggle ready button and check if all players are ready.
  void _toggleReady(playerNum) {
    setState(() {
      if (playerNum < 0) {
        // Skip to previous or next phase.
        _turnTracker.changePhase(playerNum);

      } else {
        _turnTracker.toggleReadiness(playerNum);

        if (_turnTracker.isPlayerReady(null)) {
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
    final Size screenSize = MediaQuery.of(context).size;

    if (!_turnTracker.initDone) {
      _turnTracker.init(widget.game, widget.playerCount);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          /// Turn with 1 player.
          if (widget.playerCount == 1)
            Column(
              children: [
                SizedBox(
                  height: screenSize.height / 2,
                ),
                PlayerSection(
                  turnTracker: _turnTracker,
                  playerNum: 0,
                  toggleReady: _toggleReady,
                  toggleAction: _toggleAction,
                ),
              ],
            ),

          /// Asymmetric turn with 2 players.
          if ((widget.playerCount == 2) && (!_turnTracker.isPhaseSymmetric()))
            Column(
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

          /// Symmetric turn with 2 players.
          if ((widget.playerCount == 2) && (_turnTracker.isPhaseSymmetric()))
            Stack(
              children: [

                /// Orange line
                Positioned(
                  bottom: 0,
                  left: 0,
                  height: screenSize.height,
                  width: 6,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                /// Orange line
                Positioned(
                  bottom: 0,
                  right: 0,
                  height: screenSize.height,
                  width: 6,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerSectionSymmetric(
                      turnTracker: _turnTracker,
                      playerNum: 1,
                      toggleAction: _toggleAction,
                    ),

                    AnimatedReady(
                      isReady: false,
                      shouldAnimateReady: false,
                      buttonSize: screenSize.width * 0.8,
                      useCroppedImage: false,
                    ),

                    PlayerSectionSymmetric(
                      turnTracker: _turnTracker,
                      playerNum: 0,
                      toggleAction: _toggleAction,
                    ),
                  ],
                ),
              ],
            ),

        ],
      ),
    );
  }

  @override
  void initState() {
    // Enable full screen.
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive
    );
    super.initState();
  }

  @override
  void dispose() {
    // Disable full screen.
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}

