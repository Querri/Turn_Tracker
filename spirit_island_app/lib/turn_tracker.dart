class TurnTracker {
  String gameName;

  int playerCount;
  List<bool> playerList;

  int lastPhase;
  int currentPhase;

  TurnTracker(this.gameName, this.playerCount) {
    playerList = new List.filled(playerCount, false);
    lastPhase = _getPLastPhase();
    currentPhase = 0;
  }

  /// Toggle ready status of a player.
  void toggleReadiness(playerNum) {
    playerList[playerNum] = !playerList[playerNum];
  }

  /// Check if players are ready.
  bool checkReadiness(playerNum) {
    if (playerNum == null) {
      for (bool playerReady in playerList) {
        if (!playerReady) {
          return false;
        }
      }
      return true;
    } else {
      return playerList[playerNum];
    }
  }

  /// Reset ready buttons and increment current phase.
  void resetReadiness() {
    for (int i=0; i<playerCount; i++) {
      playerList[i] = false;
    }

    if (currentPhase < lastPhase) {
      currentPhase +=1;
    } else {
      currentPhase = 0;
    }
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




