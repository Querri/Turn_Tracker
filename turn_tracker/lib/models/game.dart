import 'package:flutter/services.dart';
import 'dart:convert';

/// A model representing a game.
///
/// Type can be co-op or versus,
/// phases has a list of phase names,
/// phase settings has a list of settings for each phase,
/// actions has a list of action names for each phase.
class Game {
  final String name;
  final String type;
  final List<String> phases;
  final List<dynamic> phaseSettings;
  final List<dynamic> actions;

  Game({this.name, this.type, this.phases, this.phaseSettings, this.actions});

  factory Game.fromJson(Map<String, dynamic> parsedJson) {
    var phasesFromJson = parsedJson['phases'];
    List<String> phasesList = phasesFromJson.cast<String>();

    return new Game(
      name: parsedJson['name'] as String,
      type: parsedJson['type'] as String,
      phases: phasesList,
      phaseSettings: parsedJson['phase_settings'],
      actions: parsedJson['actions'],
    );
  }

  /// True if an action exists on that place.
  bool isActionAvailable(phaseNum, actionNum) {
    if (actions[phaseNum][actionNum] == "") return false;
    else return true;
  }

  /// True if a phase is symmetric.
  bool isPhaseSymmetric(phaseNum) {
    // TODO probably needs fixing for multiple settings per phase.
    for (String settings in phaseSettings[phaseNum]) {
      if (settings == "sym") return true;
    }
    return false;
  }
}

/// Read json file.
Future<List<dynamic>> readJson() async {
  final String response = await rootBundle.loadString('assets/games.json');
  final data = jsonDecode(response);
  return data['games'];
}

/// Find a game object based on its name.
Game findGame(games, name) {
  for (Game game in games) {
    if (game.name == name) {
      return game;
    }
  }
  return null;
}