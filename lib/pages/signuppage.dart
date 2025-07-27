// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:profolio/pages/portfoliolist.dart';
// import 'package:profolio/pages/session_manager.dart';
// import 'package:profolio/pages/userinfopage.dart';
// import 'package:profolio/pages/utils.dart';
//
// class CreateStudentID extends StatefulWidget {
//   CreateStudentID({Key? key}) : super(key: key);
//
//   @override
//   State<CreateStudentID> createState() => _CreateStudentIDState();
// }
//
// class _CreateStudentIDState extends State<CreateStudentID> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//
//   void _handleGoogleSignIn(BuildContext context) async {
//     try {
//       GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
//       if (kIsWeb) {
//         // For web, use signInWithPopup
//         await FirebaseAuth.instance
//             .signInWithPopup(googleAuthProvider)
//             .then((userCredential) {
//           if (userCredential.user != null) {
//             // Navigate to the next page after successful sign-in
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PortfolioListPage(),
//               ),
//             );
//           }
//         });
//       } else {
//         // For mobile, use signInWithProvider
//         await FirebaseAuth.instance
//             .signInWithProvider(googleAuthProvider)
//             .then((userCredential) {
//           if (userCredential.user != null) {
//             // Navigate to the next page after successful sign-in
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PortfolioListPage(),
//               ),
//             );
//           }
//         });
//       }
//     } catch (error) {
//       print("Error: $error");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $error")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         height: screenHeight,
//         width: screenWidth,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               Colors.transparent,
//               Colors.transparent,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               vertical: screenHeight * 0.05,
//               horizontal: screenWidth * 0.04,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: screenHeight * 0.05),
//                 Center(
//                   child: Container(
//                     height: 110,
//                     width: 110,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(55),
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 2.0,
//                       ),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(55),
//                       child: Image.asset(
//                         'lib/assets/images/krishna.png',
//                         height: 110,
//                         width: 110,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.012),
//                 Text(
//                   "EventSphere",
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: screenWidth * 0.070,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.055),
//                 Center(
//                   child: ElevatedButton.icon(
//                     icon: Image.asset(
//                       'lib/assets/images/googleicon.png',
//                       height: 24,
//                     ),
//                     label: Text("Sign up with Google"),
//                     onPressed: () {
//                       _handleGoogleSignIn(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:profolio/pages/portfoliolist.dart';

class CreateStudentID extends StatefulWidget {
  const CreateStudentID({Key? key}) : super(key: key);

  @override
  State<CreateStudentID> createState() => _CreateStudentIDState();
}

class _CreateStudentIDState extends State<CreateStudentID> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  int currentPage = 0;

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(googleProvider);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PortfolioListPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _nextPage() {
    if (currentPage < 2) {
      setState(() => currentPage++);
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Widget> _buildSlides(double screenWidth) {
    return [
      _introSlide(
        screenWidth,
        "Welcome to ProFolio",
        "Build your personalized portfolio in minutes.",
        'lib/assets/lottieAnimations/animationThree.json',
      ),
      _introSlide(
        screenWidth,
        "Customize Effortlessly",
        "Add projects, skills, resume, and achievements easily.",
        'lib/assets/lottieAnimations/animationTwo.json',
      ),
      _introSlide(
        screenWidth,
        "Share & Shine",
        "Showcase your portfolio to the world with one link.",
        'lib/assets/lottieAnimations/animationFour.json',
      ),
    ];
  }

  Widget _introSlide(double width, String title, String subtitle, String lottiePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // You can adjust the radius
            child: Lottie.asset(
              lottiePath,
              width: width * 0.85,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ),
        const SizedBox(height: 30),
        FittedBox(
          child: Text(
            title,
            style: GoogleFonts.blinker(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.blinker(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 40),
        if (currentPage == 2)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black12, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3), // subtle shadow below
                ),
              ],
            ),
            child: ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/images/googleicon.png',
                height: 24,
              ),
              label: Text("Sign up with Google"),
              onPressed: () => _handleGoogleSignIn(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                elevation: 0, // to avoid double shadow
                shadowColor: Colors.transparent, // disables default ElevatedButton shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          )

        else
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfffaa629),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Continue",
              style: GoogleFonts.blinker(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _buildSlides(screenWidth),
        ),
      ),
    );
  }
}
