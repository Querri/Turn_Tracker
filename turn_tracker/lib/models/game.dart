import 'package:flutter/services.dart';
import 'dart:convert';

/// A model representing one game.
class Game {
  final String name;
  final String type;

  Game({this.name, this.type});

  factory Game.fromJson(Map<String, dynamic> json) {
    return new Game(
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }
}

/// Read json file.
Future<List<dynamic>> readJson() async {
  final String response = await rootBundle.loadString('assets/games.json');
  final data = jsonDecode(response);
  return data['games'];
}