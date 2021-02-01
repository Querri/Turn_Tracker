import 'package:flutter/services.dart';
import 'dart:convert';

/// A model representing one game.
class Game {
  final String name;
  final String type;
  final List<String> phases;

  Game({this.name, this.type, this.phases});

  factory Game.fromJson(Map<String, dynamic> parsedJson) {
    var phasesFromJson = parsedJson['phases'];
    List<String> phasesList = phasesFromJson.cast<String>();

    return new Game(
      name: parsedJson['name'] as String,
      type: parsedJson['type'] as String,
      phases: phasesList,
    );
  }
}

/// Read json file.
Future<List<dynamic>> readJson() async {
  final String response = await rootBundle.loadString('assets/games.json');
  final data = jsonDecode(response);
  return data['games'];
}

Game findGame(games, name) {
  for (Game game in games) {
    if (game.name == name) {
      return game;
    }
  }
  return null;
}