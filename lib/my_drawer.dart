import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle_game/my_firebase_auth_manager.dart';

class MyDrawer extends StatelessWidget {
  final Function(UserCredential)? onLoggedIn;
  final Function()? onLogOut;

  const MyDrawer({Key? key, this.onLoggedIn, this.onLogOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(32),
      color: Colors.black87,
      child: Column(
        children: [
          Text(
            "Ranking",
            style: GoogleFonts.varelaRound(color: Colors.white, fontSize: 28),
          ),
          // Expanded(
          //     child: ListView(
          //   children: [
          //     //
          //   ],
          // )),
          const SizedBox(
            height: 16,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(
                    "Coming soon..",
                    style: GoogleFonts.varelaRound(
                        color: Colors.white, fontSize: 24),
                  )))),
          const SizedBox(
            height: 16,
          ),
          if (MyFirebaseAuthManager.isSignedIn)
            GestureDetector(
              onTap: () async {
                await MyFirebaseAuthManager.signOut();
                onLogOut?.call();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                    decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "Logout",
                      style: GoogleFonts.varelaRound(
                          color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
              ),
            )
          else
            GestureDetector(
              onTap: () async {
                UserCredential userCredential =
                    await MyFirebaseAuthManager.loginWithFacebook();
                onLoggedIn?.call(userCredential);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                    decoration: BoxDecoration(
                        color: const Color(0xff1778f2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "Login with Facebook",
                      style: GoogleFonts.varelaRound(
                          color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
