import 'package:flutter/material.dart';

import 'my_game.dart';
import 'my_game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyGame.gameTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyGamePage(),
    );
  }
}
