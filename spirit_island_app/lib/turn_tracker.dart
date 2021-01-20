class TurnTracker {
  String gameName;

  int playerCount;
  List<List<dynamic>> players;

  int lastPhase;
  int currentPhase;

  TurnTracker(this.gameName, this.playerCount) {
    lastPhase = _getPLastPhase();
    currentPhase = 0;

    players = List.generate(
        playerCount, (index) =>
        [false, new List.generate(3, (index) => false)]
    );

    print('');
    print(players);
    print('');
  }

  /// Toggle ready status of a player.
  void toggleReadiness(playerNum) {
    players[playerNum][0] = !players[playerNum][0];

    print('');
    print(players);
    print('');
  }

  /// Check if players are ready.
  bool checkReadiness(playerNum) {
    if (playerNum == null) {
      for (var player in players) {
        if (!player[0]) {
          return false;
        }
      }
      return true;
    } else {
      return players[playerNum][0];
    }
  }

  /// Reset ready buttons and increment current phase.
  void resetReadiness() {
    for (var player in players) {
      player[0] = false;
      for (int i=0; i<player[1].length; i++) {
        player[1][i] = false;
      }
    }

    if (currentPhase < lastPhase) {
      currentPhase +=1;
    } else {
      currentPhase = 0;
    }
  }

  /// Toggle one action status of a player.
  void toggleAction(playerNum, actionNum) {
    players[playerNum][1][actionNum] = !players[playerNum][1][actionNum];
  }

  bool checkAction(playerNum, actionNum) {
    return players[playerNum][1][actionNum];
  }

  bool areActionsAvailable() {
    switch (gameName) {
      case 'Spirit Island': {
        switch (currentPhase) {
          case 0: return true;
          case 2: return true;
        }
      }
    }
    return false;
  }

  /// Get the number of phases in a game.
  int _getPLastPhase() {
    switch (gameName) {
      case ('Spirit Island'): return 4;
      case ('Direwild'): return 3;
    }
    return 0;
  }

  /// Get the name of the phase.
  String getPhaseText() {
    switch (gameName) {
      case ('Spirit Island'): {
        switch (currentPhase) {
          case 0: return 'Spirit Phase';
          case 1: return 'Fast Power Phase';
          case 2: return 'Invader Phase';
          case 3: return 'Slow Power Phase';
          case 4: return 'Time Passes';
        }
        break;
      }
      case ('Direwild'): {
        switch (currentPhase) {
          case 0: return 'Minion Phase';
          case 1: return 'Summon Phase';
          case 2: return 'Charm Phase';
          case 3: return 'Adventure Phase';
        }
      }
    }
    return 'No Phase Found';
  }

  /// Get the names for actions in the current phase.
  List<String> getActionText() {
    switch (gameName) {
      case ('Spirit Island'): {
        switch (currentPhase) {
          case 0: return ['GROWTH', 'ENERGY', 'CARDS'];
          case 2: return ['BLIGHT', 'EVENT', 'FEAR'];
          default: return ['', '', ''];
        }
      }
    }
    return ['', '', ''];
  }
}




