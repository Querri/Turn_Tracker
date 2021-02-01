import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen/screen.dart';

import 'package:spirit_island_app/pages/game_view.dart';
import 'package:spirit_island_app/models/game.dart';


/// Main view of the app.
///
/// Contains options for selected game and number of players,
/// which are used to generate the game view.
class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _playerCount = 2;
  String _selectedGame = 'spirit island';

  /// Fetch all available games and their info from local json file.
  Future<List<Game>> _fetchGames() async {
    final String jsonString = await rootBundle.loadString('assets/games.json');
    final jsonResponse = await json.decode(jsonString);
    List<Game> list = List<Game>();

    for (int i=0; i<5; i++) {
      list.add(Game.fromJson(jsonResponse['games'][i]));
      print(list[i].phases[0]);
    }
    return list;
  }

  /// Change the selected game.
  void _changeSelection(String newSelection) {
    setState(() {
      _selectedGame = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Turn Tracker'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchGames(),
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 4),
                Text(
                  'Choose game',
                  style: Theme.of(context).textTheme.headline6
                      .merge(GoogleFonts.alegreyaSansSc()),
                ),
                snapshot.hasData
                    ? Column(
                  children: [
                    DropdownSelection(
                      games: snapshot.data,
                      selectedGame: _selectedGame,
                      changeSelection: _changeSelection,
                    )
                  ],
                )
                    : Text('no data'),
                Spacer(),
                Text(
                  'Choose the number of players',
                  style: Theme.of(context).textTheme.headline6
                      .merge(GoogleFonts.alegreyaSansSc()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(flex: 2),
                    FlatButton(
                      color: _getButtonColor('playerCount', 1),
                      child: Text(
                        '1',
                        style: Theme.of(context).textTheme.bodyText1
                            .merge(GoogleFonts.roboto())
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () {
                        setState(() {
                          _playerCount = 1;
                        });
                      },
                    ),
                    Spacer(),
                    FlatButton(
                      color: _getButtonColor('playerCount', 2),
                      child: Text(
                        '2',
                        style: Theme.of(context).textTheme.bodyText1
                            .merge(GoogleFonts.roboto())
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () {
                        setState(() {
                          _playerCount = 2;
                        });
                      },
                    ),
                    Spacer(flex: 2),
                  ],
                ),
                Spacer(),
                FlatButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.of(context).push(_createRoute(_selectedGame, _playerCount));
                  },
                  child: Text(
                    'START',
                    style: Theme.of(context).textTheme.bodyText1
                        .merge(GoogleFonts.alegreyaSansSc())
                        .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                Spacer(flex: 5),
              ],
            );
          }
        ),

      ),
    );
  }

  /// Get color for a button depending on its state.
  Color _getButtonColor(option, buttonLabel) {
    if (option == 'gameSelection' && buttonLabel == _selectedGame) {
      return Theme.of(context).colorScheme.secondary;
    }
    else if (option == 'playerCount' && buttonLabel == _playerCount) {
      return Theme.of(context).colorScheme.secondary;
    }
    return Theme.of(context).colorScheme.primary;
  }
}

/// Create a navigation route.
Route _createRoute(selectedGame, playerCount) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => GameView(gameName: selectedGame, playerCount: playerCount),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class DropdownSelection extends StatelessWidget {
  DropdownSelection({this.games, this.selectedGame, @required this.changeSelection});

  final games;
  final String selectedGame;
  final ValueChanged<String> changeSelection;

  List<String> _getItems() {
    List<String> list = List<String>();
    for (var game in games) {
      list.add(game.name);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 270,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: DropdownButton<String>(
        value: selectedGame,
        dropdownColor: Theme.of(context).colorScheme.primary,
        focusColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        iconSize: 24,
        elevation: 16,
        style: Theme.of(context).textTheme.bodyText1
            .merge(GoogleFonts.roboto())
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        underline: Container(
          height: 0,
        ),
        onChanged: (String newValue) {
          changeSelection(newValue);
        },
        items: _getItems().map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        })
            .toList(),
      ),
    );
  }
}