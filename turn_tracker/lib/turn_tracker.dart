import 'package:spirit_island_app/models/game.dart';


class TurnTracker {
  String gameName;
  Game game;
  bool initDone = false;

  int playerCount;
  List<List<dynamic>> players;
  List<int> animatePlayerReady;

  int currentPhase;

  /// Initialize the class with values from main view.
  void init(game, playerCount) {
    this.game = game;
    this.gameName = game.name;
    this.playerCount = playerCount;

    currentPhase = 0;

    players = List.generate(
        playerCount, (index) =>
        [false, new List.generate(3, (index) => false)]
    );
    animatePlayerReady = List.generate(playerCount, (index) => 0);

    initDone = true;
  }

  /// Toggle ready status of a player.
  void toggleReadiness(playerNum) {
    if (isPhaseSymmetric()) {
      for (var player in players) {
        player[0] = true;
      }
    } else {
      players[playerNum][0] = !players[playerNum][0];
    }

    if (players[playerNum][0]) {
      animatePlayerReady[playerNum] = 2;
    } else {
      animatePlayerReady[playerNum] = 0;
    }
  }

  /// Check if players are ready.
  bool isPlayerReady(playerNum) {
    // Check all players.
    if (playerNum == null) {
      for (var player in players) {
        if (!player[0]) {
          return false;
        }
      }
      return true;
    // Check only one specific player.
    } else {
      return players[playerNum][0];
    }
  }

  /// Returns true if players ready button should play a spinning animation.
  bool shouldAnimatePlayerReady(playerNum) {
    if (animatePlayerReady[playerNum] > 0) {
      animatePlayerReady[playerNum] -= 1;
      return true;
    } else {
      return false;
    }
  }

  /// Change game phase one forward or backward.
  void changePhase(direction) {
    // Sel all ready buttons to animate.
    for (int i=0; i<playerCount; i++) {
      animatePlayerReady[i] = 2;
    }

    // Set all actions and ready states to false.
    for (var player in players) {
      player[0] = false;
      for (int i=0; i<player[1].length; i++) {
        player[1][i] = false;
      }
    }

    // Change phase one forward or backward.
    if (direction != -1) {
      if (currentPhase < game.phases.length-1) {
        currentPhase +=1;
      } else {
        currentPhase = 0;
      }
    } else {
      if (currentPhase > 0) {
        currentPhase -= 1;
      } else {
        currentPhase = game.phases.length-1;
      }
    }
  }

  /// Toggle one action status of a player.
  void toggleAction(playerNum, actionNum) {
    if (isPhaseSymmetric()) {
      for (var player in players) {
        player[1][actionNum] = !player[1][actionNum];
      }
    } else {
      players[playerNum][1][actionNum] = !players[playerNum][1][actionNum];
    }
  }

  /// Check if a specific action of a player is marked as done.
  bool isActionDone(playerNum, actionNum) {
    return players[playerNum][1][actionNum];
  }

  /// True if current phase includes actions and actionButton has a label.
  bool isActionAvailable(int actionNum) {
    if (game.actions[currentPhase][actionNum] == "") {
      return false;
    } else {
      return true;
    }
  }

  /// True if phase is done "jointly", so that players do the actions together.
  bool isPhaseSymmetric() {
    switch (gameName) {
      case 'spirit island': {
        if (currentPhase == 2 || currentPhase == 3) return true;
      }
      break;
      case 'direwild': {
        if (currentPhase == 0) return true;
      }
    }
    return false;
  }

  /// Get text for current phase.
  String getPhaseText() {
    return game.phases[currentPhase];
  }

  /// Get the names for actions in the current phase.
  List<dynamic> getActionText() {
    return game.actions[currentPhase];
  }
}




