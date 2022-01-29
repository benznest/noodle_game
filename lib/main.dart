import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordle_game/shake_widget.dart';
import 'package:wordle_game/words.dart';

import 'game_board_widget.dart';
import 'game_end_dialog.dart';
import 'keyboard_widget.dart';
import 'my_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noodle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyGamePage(),
    );
  }
}

class MyGamePage extends StatefulWidget {
  const MyGamePage({Key? key}) : super(key: key);

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> with TickerProviderStateMixin {
  late ShakeController _shakeController;
  final List<String> allWords = MyWords.listAllWords;
  late String answer;
  late List<List<String>> listPlayerWords;
  late int countGuessTimes;
  late Set<String> listAlphabetCorrect;
  late Set<String> listAlphabetNone;
  bool isGameEnd = false;

  @override
  void initState() {
    _shakeController = ShakeController(vsync: this);
    init();
    super.initState();
  }

  init() {
    countGuessTimes = 0;
    listPlayerWords = List.generate(MyGame.maxGuessTimes, (index) => []);
    listAlphabetCorrect = {};
    listAlphabetNone = {};
    isGameEnd = false;
    answer = MyWords.random;
    // print(answer);
  }

  restart() {
    setState(() {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Scaffold(
        backgroundColor: const Color(0xff121213),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAppBar(),
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.all(32),
                    children: [
                      GameBoardWidget(
                        key: UniqueKey(),
                        width: cons.maxWidth,
                        countGuessTimes: countGuessTimes,
                        wordLength: MyGame.wordLength,
                        listPlayerWords: listPlayerWords,
                        answer: answer,
                        shakeController: _shakeController,
                      ),
                    ],
                  )),
                  KeyboardWidget(
                    key: UniqueKey(),
                    width: cons.maxWidth,
                    listAlphabetCorrect: listAlphabetCorrect,
                    listAlphabetNone: listAlphabetNone,
                    onAlphabet: (a) {
                      if (!isGameEnd) {
                        if (listPlayerWords[countGuessTimes].length <
                            MyGame.wordLength) {
                          setState(() {
                            listPlayerWords[countGuessTimes].add(a);
                          });
                        }
                      }
                    },
                    onBackspace: () {
                      if (!isGameEnd) {
                        if (listPlayerWords[countGuessTimes].isNotEmpty) {
                          setState(() {
                            listPlayerWords[countGuessTimes].removeLast();
                          });
                        }
                      }
                    },
                    onEnter: () {
                      if (!isGameEnd) {
                        if (listPlayerWords[countGuessTimes].length ==
                            MyGame.wordLength) {
                          verifyWord(listPlayerWords[countGuessTimes]);
                        }
                      }
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String url = "https://github.com/benznest/noodle_game/";
                  if (await canLaunch(url)) launch(url);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Source code\non Github",
                      style: GoogleFonts.varelaRound(
                          color: Colors.white.withOpacity(0.5), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildAppBar() {
    return Column(
      children: [
        Text(
          "Noodle",
          style: GoogleFonts.varelaRound(color: Colors.white, fontSize: 52),
        ),
        Text(
          "Play unlimited Wordle game",
          style: GoogleFonts.varelaRound(
              color: Colors.white.withOpacity(0.5), fontSize: 14),
        ),
      ],
    );
  }

  verifyWord(List<String> listPlayerWord) {
    String playerWord = listPlayerWord.reduce((v, e) => v + e);

    if (playerWord == answer) {
      setState(() {
        countGuessTimes++;
        isGameEnd = true;
      });
      endGame(true);
    } else {
      bool found = false;
      for (String word in allWords) {
        if (word == playerWord) {
          found = true;
          break;
        }
      }

      if (found) {
        setState(() {
          countGuessTimes++;
          for (String a in listPlayerWord) {
            if (answer.contains(a)) {
              listAlphabetCorrect.add(a);
            } else {
              listAlphabetNone.add(a);
            }
          }

          if (countGuessTimes == MyGame.maxGuessTimes) {
            endGame(false);
          }
        });
      } else {
        _shakeController.shake();
      }
    }
  }

  endGame(bool isWin) {
    if (isWin) {
      GameEndDialog.showWin(context, answer: answer, onPlayMore: () {
        restart();
      });
    } else {
      GameEndDialog.showLose(context, onPlayAgain: () {
        restart();
      });
    }
  }
}
