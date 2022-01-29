import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle_game/shake_widget.dart';

enum AlphabetBadgeStatus { guessing, correctSpot, wrongSpot, none }

extension AlphabetBadgeStatusExtension on AlphabetBadgeStatus {
  Color get background {
    switch (this) {
      case AlphabetBadgeStatus.guessing:
        return Colors.transparent;
      case AlphabetBadgeStatus.correctSpot:
        return const Color(0xff538d4e);
      case AlphabetBadgeStatus.wrongSpot:
        return const Color(0xffb59f3b);
      case AlphabetBadgeStatus.none:
        return const Color(0xff3a3a3c);
    }
  }
}

class GameBoardWidget extends StatelessWidget {
  final double width;
  final int countGuessTimes;
  final int wordLength;
  final String answer;
  final List<List<String>> listPlayerWords;
  final ShakeController shakeController;

  const GameBoardWidget(
      {Key? key,
      required this.width,
      required this.countGuessTimes,
      required this.wordLength,
      required this.listPlayerWords,
      required this.answer,
      required this.shakeController})
      : super(key: key);

  double get widthAlphabetBadge {
    if (width < 500) {
      return (width / wordLength) - 20;
    }
    return 70;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < listPlayerWords.length; i++)
          buildRowWord(listPlayerWords[i], isGuessing: countGuessTimes == i)
      ],
    );
  }

  Widget buildAlphabetBadge(String alphabet, AlphabetBadgeStatus status) {
    Color background = status.background;

    return Container(
      width: widthAlphabetBadge,
      height: widthAlphabetBadge,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: background,
          border: status == AlphabetBadgeStatus.guessing
              ? Border.all(width: 2, color: const Color(0xff3a3a3c))
              : null),
      child: Center(
        child: Text(
          alphabet.toUpperCase(),
          style: GoogleFonts.varelaRound(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildAlphabetBadgeEmpty() {
    return Container(
      width: widthAlphabetBadge,
      height: widthAlphabetBadge,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 2, color: const Color(0xff3a3a3c))),
    );
  }

  Widget buildRowWord(List<String> word, {bool isGuessing = false}) {
    if (word.isEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < wordLength; i++) buildAlphabetBadgeEmpty()
        ],
      );
    } else {
      Widget row = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < word.length; i++)
            buildAlphabetBadge(
                word[i],
                isGuessing
                    ? AlphabetBadgeStatus.guessing
                    : getStatus(answer, word[i], i)),
          for (int i = 0; i < wordLength - word.length; i++)
            buildAlphabetBadgeEmpty()
        ],
      );

      if (isGuessing) {
        return ShakeWidget(controller: shakeController, child: row);
      } else {
        return row;
      }
    }
  }

  AlphabetBadgeStatus getStatus(
      String answer, String alphabetPlayer, int spot) {
    if (answer[spot] == alphabetPlayer) {
      return AlphabetBadgeStatus.correctSpot;
    } else {
      if (answer.contains(alphabetPlayer)) {
        return AlphabetBadgeStatus.wrongSpot;
      } else {
        return AlphabetBadgeStatus.none;
      }
    }
  }
}
