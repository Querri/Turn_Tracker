class TurnTracker {
  String gameName;
  bool initDone = false;
  int spinBoth = 0;

  int playerCount;
  List<List<dynamic>> players;

  int lastPhase;
  int currentPhase;

  /// Initialize the class with values from main view.
  void init(gameName,playerCount) {
    this.gameName = gameName;
    this.playerCount = playerCount;

    lastPhase = _getLastPhase();
    currentPhase = 0;

    players = List.generate(
        playerCount, (index) =>
        [false, new List.generate(3, (index) => false)]
    );

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
  }

  /// Check if players are ready.
  bool checkReadiness(playerNum) {
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

  /// Change game phase one forward or backward.
  void changePhase(direction) {
    spinBoth = 2;
    // Set all actions and ready states to false.
    for (var player in players) {
      player[0] = false;
      for (int i=0; i<player[1].length; i++) {
        player[1][i] = false;
      }
    }

    // Change phase forward or backward one phase.
    if (direction != -1) {
      if (currentPhase < lastPhase) {
        currentPhase +=1;
      } else {
        currentPhase = 0;
      }
    } else {
      if (currentPhase > 0) {
        currentPhase -= 1;
      } else {
        currentPhase = lastPhase;
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
  bool checkAction(playerNum, actionNum) {
    return players[playerNum][1][actionNum];
  }

  /// True if current phase includes actions and actionButton has a label.
  bool isActionAvailable(int actionNum) {
    switch (gameName) {
      case 'Generic': {
        return true;
      }
      case 'Spirit Island': {
        if (currentPhase == 0 || currentPhase == 2 || currentPhase == 3) return true;
        else if ((currentPhase == 1 || currentPhase == 4 || currentPhase == 5) &&
            (actionNum == 0 || actionNum == 2)) return true;
        break;
      }
      case 'Direwild': {
        if (currentPhase == 0) return true;
        else if (actionNum == 0 || actionNum == 2) return true;
      }
    }
    return false;
  }

  /// True if phase is done "jointly", so that players do the actions together.
  bool isPhaseSymmetric() {
    switch (gameName) {
      case 'Spirit Island': {
        if (currentPhase == 2 || currentPhase == 3) return true;
      }
      break;
      case 'Direwild': {
        if (currentPhase == 0) return true;
      }
    }
    return false;
  }

  /// Get the number of the last phase.
  int _getLastPhase() {
    switch (gameName) {
      case ('Spirit Island'): return 5;
      case ('Direwild'): return 4;
    }
    return 0;
  }

  /// Get the name of the phase.
  String getPhaseText() {
    switch (gameName) {
      case ('Spirit Island'): {
        switch (currentPhase) {
          case 0: return 'spirit phase';
          case 1: return 'fast power phase';
          case 2: return 'invader phase 1';
          case 3: return 'invader phase 2';
          case 4: return 'slow power phase';
          case 5: return 'time passes';
        }
        break;
      }
      case ('Direwild'): {
        switch (currentPhase) {
          case 0: return 'game phase';
          case 1: return 'summon phase';
          case 2: return 'charm phase';
          case 3: return 'adventure phase';
          case 4: return 'end phase';
        }
      }
    }
    return '';
  }

  /// Get the names for actions in the current phase.
  List<String> getActionText() {
    switch (gameName) {
      case ('Spirit Island'): {
        switch (currentPhase) {
          case 0: return ['GROWTH', 'GET ENERGY', 'PLAY CARDS'];
          case 1: return ['INNATE POWERS', '', 'CARD POWERS'];
          case 2: return ['BLIGHT EFFECT', 'EVENT CARD', 'FEAR CARD'];
          case 3: return ['RAVAGE', 'BUILD', 'EXPLORE'];
          case 4: return ['INNATE POWERS', '', 'CARD POWERS'];
          case 5: return ['DISCARD CARDS AND ENERGY', '', 'HEAL PARTIAL DAMAGE'];
        }
      }
      break;
      case 'Direwild': {
        switch (currentPhase) {
          case 0: return ['NEW CARD', 'KARN PRESENCE', 'MOVE ENEMIES'];
          case 1: return ['CHOOSE ORDER', '', 'PLAY CARDS'];
          case 2: return ['SPEND CHARM', '', 'BUILD CREATURE'];
          case 3: return ['MOVE', '', 'BATTLE'];
          case 4: return ['DISCARD CARDS', '', 'MOVE COUNTERS'];
        }
      }
    }
    return ['', '', ''];
  }

  bool spin() {
    if (spinBoth > 0) {
      spinBoth -= 1;
      return true;
    }
    return false;
  }
}




