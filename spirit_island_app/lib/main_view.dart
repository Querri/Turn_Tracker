import 'package:flutter/material.dart';


class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int playerCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spirit Island'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose the number of players',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    playerCount = 1;
                  },
                  child: Text('1'),
                ),
                FlatButton(
                  onPressed: () {
                    playerCount = 2;
                  },
                  child: Text('2'),
                ),
              ],
            ),
            FlatButton(
              onPressed: () {

              },
              child: Text('START'),
            ),
          ],
        ),
      ),
    );
  }
}