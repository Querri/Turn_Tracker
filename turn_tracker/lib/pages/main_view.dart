import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spirit_island_app/pages/game_view.dart';
import 'package:spirit_island_app/pages/main_view_animator.dart';
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

    for (int i=0; i<8; i++) {
      list.add(Game.fromJson(jsonResponse['games'][i]));
      print(list[i].name);
    }
    return list;
  }


  /// Change the selected game.
  void _changeSelection(String newSelection) {
    setState(() {
      _selectedGame = newSelection;
    });
  }


  /// Change the selected number of players.
  void _changePlayerCount(int newCount) {
    setState(() {
      _playerCount = newCount;
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //Screen.keepOn(false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: _fetchGames(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Select game
                        Container(
                          height: size.height*0.30,
                          child: snapshot.hasData ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                //color: _getButtonColor('playerCount', 1),
                                style: TextButton.styleFrom(
                                    primary: Theme.of(context).colorScheme.onBackground
                                ),
                                child: Text(
                                  '${snapshot.data[index].name}',
                                  style: _getButtonStyle('gameSelection', snapshot.data[index].name),
                                ),
                                onPressed: () {
                                  _changeSelection(snapshot.data[index].name);
                                },
                              );
                            },
                          ) : Text('no data'),
                        ),

                        /// Select number of players
                        Container(
                          height: 100,
                          child: ListView(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    primary: Theme.of(context).colorScheme.onBackground
                                ),
                                child: Text(
                                  '1 PLAYER',
                                  style: _getButtonStyle('playerCount', 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _changePlayerCount(1);
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    primary: Theme.of(context).colorScheme.onBackground
                                ),
                                child: Text(
                                  '2 PLAYERS',
                                  style: _getButtonStyle('playerCount', 2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _changePlayerCount(2);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Stack(
                    children: [
                      /// Big circular button
                      Center(
                        heightFactor: 1,
                        child: AnimatedStart(
                          isReady: false,
                          shouldAnimateReady: false,
                          buttonSize: size.width*0.8,
                        ),
                      ),
                      /// Orange line above button row
                      Positioned(
                        bottom: size.height*0.10,
                        left: 0,
                        height: 6,
                        width: size.width,
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      /// Button row
                      Positioned(
                        bottom: 0,
                        left: 0,
                        height: size.height*0.10,
                        width: size.width,
                        child: Container(
                          color: Theme.of(context).colorScheme.tertiary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Theme.of(context).colorScheme.onBackground
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      /// settings
                                    });
                                  },
                                  child: Text(
                                    'SETTINGS',
                                    style: _getButtonStyle('settings', false),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Theme.of(context).colorScheme.onBackground
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      /// toggle sound
                                    });
                                  },
                                  child: Text(
                                    'SOUND',
                                    style: _getButtonStyle('sound', false),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ),

                      TextButton(
                        //color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          Navigator.of(context).push(_createRoute(findGame(snapshot.data, _selectedGame), _playerCount));
                        },
                        child: Text(
                          'START',
                          style: Theme.of(context).textTheme.bodySmall
                              .merge(GoogleFonts.alegreyaSansSc())
                              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          ),

        ),
      ),

    );
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.initState();
  }

  /// Get style for a button depending on its state.
  TextStyle _getButtonStyle(option, buttonLabel) {
    if ((option == 'gameSelection' && buttonLabel == _selectedGame)
        || (option == 'playerCount' && buttonLabel == _playerCount)
        ||(option == 'settings' && buttonLabel == true)
        ||(option == 'sound' && buttonLabel == true))  {
      return Theme.of(context).textTheme.labelMedium
          .merge(GoogleFonts.alegreyaSansSc())
          .copyWith(color: Theme.of(context).colorScheme.primary);
    }
    return Theme.of(context).textTheme.labelSmall
        .merge(GoogleFonts.alegreyaSansSc())
        .copyWith(color: Theme.of(context).colorScheme.onBackground);
  }
}


/// Create a navigation route to game view.
Route _createRoute(game, playerCount) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => GameView(game: game, playerCount: playerCount),
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


/// Dropdown menu for game selection.
class DropdownSelection extends StatelessWidget {
  DropdownSelection({this.games, this.selectedGame, @required this.changeSelection});

  final games;
  final String selectedGame;
  final ValueChanged<String> changeSelection;

  /// Get game names for dropdown items.
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
        style: Theme.of(context).textTheme.bodySmall
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