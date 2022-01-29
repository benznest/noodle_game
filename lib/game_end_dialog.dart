import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle_game/my_service.dart';

import 'data/owlbot_info_defination_dao.dart';
import 'data/owlbot_info_response.dart';

class GameEndDialog {
  static showWin(
    BuildContext context, {
    required String answer,
    Function()? onPlayMore,
  }) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => Material(
              color: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   "assets/app/ic_app.png",
                          //   width: 80,
                          // ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Win !",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "The Answer is ${answer.toUpperCase()}",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FutureBuilder(
                            future: MyService.getDefinition(answer),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                OwlbotInfoResponse? response =
                                    snapshot.data as OwlbotInfoResponse?;
                                return buildDefinitionSection(response);
                              } else if (snapshot.hasError) {
                                return Container();
                              }
                              return Container(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator());
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onPlayMore?.call();
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "Play more",
                                    style: GoogleFonts.varelaRound(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  static showLose(
    BuildContext context, {
    Function()? onPlayAgain,
  }) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => Material(
              color: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   "assets/app/ic_app.png",
                          //   width: 80,
                          // ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Lose",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "It might be difficult Try playing with new word.",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onPlayAgain?.call();
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.orange),
                                child: Center(
                                  child: Text(
                                    "Play again",
                                    style: GoogleFonts.varelaRound(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  static buildDefinitionSection(OwlbotInfoResponse? response) {
    if (response?.definitions != null) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Definition",
              style: GoogleFonts.varelaRound(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            for (OwlbotInfoDefinitionDao def in response!.definitions!)
              Column(
                children: [
                  Text(
                    "* (${def.type}) ${def.definition}",
                    style: GoogleFonts.varelaRound(
                        color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  // if (def.imageUrl != null)
                  //   Image.network(
                  //     def.imageUrl!,
                  //     width: 300,
                  //   )
                ],
              ),
          ],
        ),
      );
    }
    return Container();
  }
}
