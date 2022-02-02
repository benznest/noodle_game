import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'my_firebase_auth_manager.dart';
import 'my_game.dart';
import 'my_game_page.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(authDomain: "noodle-game.firebaseapp.com",
      apiKey: "AIzaSyB4INZA6D6-umJtApTyDNTo6C-lfRRfePw",
      appId: "1:525827785283:web:46666682f0ff42c1750af6",
      messagingSenderId: "525827785283",
      projectId: "noodle-game",
      storageBucket: "noodle-game.appspot.com",
    ),
  );
  await MyFirebaseAuthManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyGame.gameTitle,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyGamePage(),
    );
  }
}
