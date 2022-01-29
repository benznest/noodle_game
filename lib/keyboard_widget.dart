import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_keyboard.dart';

enum KeyboardAlphabetStatus { guessing, correct, none }

extension KeyboardAlphabetStatusExtension on KeyboardAlphabetStatus {
  Color get background {
    switch (this) {
      case KeyboardAlphabetStatus.guessing:
        return const Color(0xff818384);
      case KeyboardAlphabetStatus.correct:
        return const Color(0xff538d4e);
      case KeyboardAlphabetStatus.none:
        return const Color(0xff3a3a3c);
    }
  }
}

class KeyboardWidget extends StatelessWidget {
  final double width;
  final Function(String)? onAlphabet;
  final Function()? onBackspace;
  final Function()? onEnter;
  final Set<String> listAlphabetCorrect;
  final Set<String> listAlphabetNone;

  KeyboardWidget(
      {Key? key,
      required this.width,
      this.onAlphabet,
      this.onBackspace,
      this.onEnter,
      Set<String>? listAlphabetCorrect,
      Set<String>? listAlphabetNone})
      : listAlphabetCorrect = listAlphabetCorrect ?? {},
        listAlphabetNone = listAlphabetNone ?? {},
        super(key: key);

  Size get sizeKeyboardAlphabet {
    if (width < 600) {
      return Size((width / 10) -10, 55);
    }
    return const Size(50, 60);
  }

  Size get sizeKeyboardEnter {
    if (width < 600) {
      return const Size(60, 55);
    }
    return const Size(80, 60);
  }

  Size get sizeKeyboardBackspace {
    if (width < 600) {
      return const Size(40, 55);
    }
    return const Size(80, 60);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String alphabet in MyKeyboard.listTop)
            buildKeyboardAlphabet(
                alphabet, getKeyboardAlphabetStatus(alphabet)),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String alphabet in MyKeyboard.listMiddle)
            buildKeyboardAlphabet(
                alphabet, getKeyboardAlphabetStatus(alphabet)),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildKeyboardEnter(),
          for (String alphabet in MyKeyboard.listBottom)
            buildKeyboardAlphabet(
                alphabet, getKeyboardAlphabetStatus(alphabet)),
          buildKeyboardBackspace(),
        ],
      )
    ]);
  }

  Widget buildKeyboardAlphabet(String alphabet, KeyboardAlphabetStatus status) {
    return GestureDetector(
      onTap: () {
        onAlphabet?.call(alphabet);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: sizeKeyboardAlphabet.width,
          height: sizeKeyboardAlphabet.height,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: status.background,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              alphabet.toUpperCase(),
              style: GoogleFonts.varelaRound(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildKeyboardEnter() {
    return GestureDetector(
      onTap: () {
        onEnter?.call();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: sizeKeyboardEnter.width,
          height: sizeKeyboardEnter.height,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: const Color(0xff818384),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              "Enter",
              style: GoogleFonts.varelaRound(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildKeyboardBackspace() {
    return GestureDetector(
      onTap: () {
        onBackspace?.call();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: sizeKeyboardBackspace.width,
          height: sizeKeyboardBackspace.height,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: const Color(0xff818384),
              borderRadius: BorderRadius.circular(12)),
          child: const Center(
              child: Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 26,
          )),
        ),
      ),
    );
  }

  getKeyboardAlphabetStatus(String alphabet) {
    if (listAlphabetCorrect.contains(alphabet)) {
      return KeyboardAlphabetStatus.correct;
    } else if (listAlphabetNone.contains(alphabet)) {
      return KeyboardAlphabetStatus.none;
    }
    return KeyboardAlphabetStatus.guessing;
  }
}
