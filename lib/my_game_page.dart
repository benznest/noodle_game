import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordle_game/shake_widget.dart';
import 'package:wordle_game/words.dart';

import 'game_board_widget.dart';
import 'game_end_dialog.dart';
import 'keyboard_widget.dart';
import 'my_drawer.dart';
import 'my_game.dart';

class MyGamePage extends StatefulWidget {
  const MyGamePage({Key? key}) : super(key: key);

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> with TickerProviderStateMixin {
  late ShakeController _shakeController;
  final List<String> _allWords = MyWords.listAllWords;

  late String _answer;
  late List<List<String>> _listPlayerWords;
  late int _countGuessTimes;
  late Set<String> _listAlphabetCorrect;
  late Set<String> _listAlphabetNone;
  late bool _isGameEnd;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _shakeController = ShakeController(vsync: this);
    init();
    super.initState();
  }

  init({bool randomWord = true}) {
    _countGuessTimes = 0;
    _listPlayerWords = List.generate(MyGame.maxGuessTimes, (index) => []);
    _listAlphabetCorrect = {};
    _listAlphabetNone = {};
    _isGameEnd = false;
    if (randomWord) {
      _answer = MyWords.random;
    }
    // print(answer);
  }

  restart({bool randomWord = true}) {
    setState(() {
      init(randomWord: randomWord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xff121213),
        drawer: MyDrawer(onLoggedIn: (user){
          print("displayName = ${user.user?.displayName}");
          print("photo = ${user.user?.photoURL}");
          setState(() {
            //
          });
        },onLogOut: (){
          setState(() {
            //
          });
        },),
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
                        countGuessTimes: _countGuessTimes,
                        wordLength: MyGame.wordLength,
                        listPlayerWords: _listPlayerWords,
                        answer: _answer,
                        shakeController: _shakeController,
                      ),
                    ],
                  )),
                  KeyboardWidget(
                    key: UniqueKey(),
                    width: cons.maxWidth,
                    listAlphabetCorrect: _listAlphabetCorrect,
                    listAlphabetNone: _listAlphabetNone,
                    onAlphabet: (a) {
                      if (!_isGameEnd) {
                        if (_listPlayerWords[_countGuessTimes].length <
                            MyGame.wordLength) {
                          setState(() {
                            _listPlayerWords[_countGuessTimes].add(a);
                          });
                        }
                      }
                    },
                    onBackspace: () {
                      if (!_isGameEnd) {
                        if (_listPlayerWords[_countGuessTimes].isNotEmpty) {
                          setState(() {
                            _listPlayerWords[_countGuessTimes].removeLast();
                          });
                        }
                      }
                    },
                    onEnter: () {
                      if (!_isGameEnd) {
                        if (_listPlayerWords[_countGuessTimes].length ==
                            MyGame.wordLength) {
                          verifyWord(_listPlayerWords[_countGuessTimes]);
                        }
                      }
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () async {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child:  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.menu_sharp,
                          color: Colors.white,
                          size: 32,
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () async {
                    String url = MyGame.urlGithub;
                    if (await canLaunch(url)) launch(url);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Source code\non Github",
                        style: GoogleFonts.varelaRound(
                            color: Colors.white.withOpacity(0.5), fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
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

    if (playerWord == _answer) {
      setState(() {
        _countGuessTimes++;
        _isGameEnd = true;
      });
      endGame(isWin: true);
    } else {
      bool found = false;
      for (String word in _allWords) {
        if (word == playerWord) {
          found = true;
          break;
        }
      }

      if (found) {
        setState(() {
          _countGuessTimes++;
          for (String a in listPlayerWord) {
            if (_answer.contains(a)) {
              _listAlphabetCorrect.add(a);
            } else {
              _listAlphabetNone.add(a);
            }
          }

          if (_countGuessTimes == MyGame.maxGuessTimes) {
            endGame(isWin: false);
          }
        });
      } else {
        _shakeController.shake();
      }
    }
  }

  endGame({bool isWin = false}) {
    if (isWin) {
      GameEndDialog.showWin(context, answer: _answer, onPlayMore: () {
        restart(randomWord: true);
      });
    } else {
      GameEndDialog.showLose(context, onPlayAgain: () {
        restart(randomWord: false);
      }, onPlayMore: () {
        restart(randomWord: true);
      });
    }
  }
}
