import 'package:flutter/material.dart';

import 'package:spirit_island_app/game_view.dart';


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
  String _selectedGame = 'Generic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Spirit Island'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 4),
            Text(
              'Choose game',
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                FlatButton(
                  color: _getButtonColor('gameSelection', 'Generic'),
                  child: Text('Generic'),
                  onPressed: () {
                    setState(() {
                      _selectedGame = 'Generic';
                    });
                  },
                ),
                Spacer(),
                FlatButton(
                  color: _getButtonColor('gameSelection', 'Spirit Island'),
                  child: Text('Spirit Island'),
                  onPressed: () {
                    setState(() {
                      _selectedGame = 'Spirit Island';
                    });
                  },
                ),
                Spacer(),
                FlatButton(
                  color: _getButtonColor('gameSelection', 'Direwild'),
                  child: Text('Direwild'),
                  onPressed: () {
                    setState(() {
                      _selectedGame = 'Direwild';
                    });
                  },
                ),
                Spacer(flex: 2),
              ],
            ),
            Spacer(),
            Text(
              'Choose the number of players',
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(flex: 2),
                FlatButton(
                  color: _getButtonColor('playerCount', 1),
                  child: Text('1'),
                  onPressed: () {
                    setState(() {
                      _playerCount = 1;
                    });
                  },
                ),
                Spacer(),
                FlatButton(
                  color: _getButtonColor('playerCount', 2),
                  child: Text('2'),
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
              child: Text('START'),
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }

  /// Get color for a button depending on its state.
  Color _getButtonColor(option, buttonLabel) {
    if (option == 'gameSelection' && buttonLabel == _selectedGame) {
      return Theme.of(context).colorScheme.primaryVariant;
    }
    else if (option == 'playerCount' && buttonLabel == _playerCount) {
      return Theme.of(context).colorScheme.primaryVariant;
    }
    return Theme.of(context).colorScheme.secondary;
  }
}

/// Create a navigation route.
Route _createRoute(selectedGame, playerCount) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => GameView(selectedGame, playerCount),
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
