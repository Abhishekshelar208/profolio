import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/portfoliolist.dart';
import 'package:profolio/pages/session_manager.dart';
import 'package:profolio/pages/userinfopage.dart';
import 'package:profolio/pages/utils.dart';

class CreateStudentID extends StatefulWidget {
  CreateStudentID({Key? key}) : super(key: key);

  @override
  State<CreateStudentID> createState() => _CreateStudentIDState();
}

class _CreateStudentIDState extends State<CreateStudentID> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      if (kIsWeb) {
        // For web, use signInWithPopup
        await FirebaseAuth.instance
            .signInWithPopup(googleAuthProvider)
            .then((userCredential) {
          if (userCredential.user != null) {
            // Navigate to the next page after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PortfolioListPage(),
              ),
            );
          }
        });
      } else {
        // For mobile, use signInWithProvider
        await FirebaseAuth.instance
            .signInWithProvider(googleAuthProvider)
            .then((userCredential) {
          if (userCredential.user != null) {
            // Navigate to the next page after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PortfolioListPage(),
              ),
            );
          }
        });
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.transparent,
              Colors.transparent,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.05,
              horizontal: screenWidth * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: Image.asset(
                        'lib/assets/images/krishna.png',
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                Text(
                  "EventSphere",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: screenWidth * 0.070,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                ),
                SizedBox(height: screenHeight * 0.055),
                Center(
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'lib/assets/images/googleicon.png',
                      height: 24,
                    ),
                    label: Text("Sign up with Google"),
                    onPressed: () {
                      _handleGoogleSignIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
