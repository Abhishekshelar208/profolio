// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:profolio/pages/splash_services.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   final SplashServicesForStudent _splashServices = SplashServicesForStudent();
//
//   @override
//   void initState() {
//     super.initState();
//     _splashServices.checkLoginStatus(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get screen width and height
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
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
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: Container(
//                   height: 110,
//                   width: 110,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25), // Half of height/width for a circle
//                     border: Border.all(
//                       color: Colors.grey, // Border color
//                       width: 2.0,        // Border width
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       'lib/assets/images/profoliologo.jpg',
//                       height: 110,
//                       width: 110,
//                       fit: BoxFit.cover, // Ensures the image fits within the container
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: screenHeight * 0.02), // Responsive spacing
//               Text(
//                 "Profolio",
//                 style: GoogleFonts.blinker(
//                   color: Colors.white, // Set color to white to ensure the gradient is visible
//                   fontSize: screenWidth * 0.070,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.05), // Responsive spacing
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServicesForStudent _splashServices = SplashServicesForStudent();

  @override
  void initState() {
    super.initState();
    // Only check login status if we're actually on the splash screen route
    // Don't navigate if we're just passing through to a portfolio route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final modalRoute = ModalRoute.of(context);
        final isCurrent = modalRoute?.isCurrent ?? false;
        final currentRouteName = modalRoute?.settings.name;

        debugPrint('[SplashScreen] currentRouteName: $currentRouteName, isCurrent: $isCurrent');

        // Only navigate if we're on the root route AND we are the visible route
        if (currentRouteName == '/' && isCurrent) {
          _splashServices.checkLoginStatus(context);
        } else {
          debugPrint('[SplashScreen] Skipping redirection check (either not on root or not visible)');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xfff5f5f7), //background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FittedBox(
                child: Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white24,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'lib/assets/images/profolioMainLogo.png',
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "ProFolio",
              style: GoogleFonts.blinker(
                color: Colors.black, // Brand color
                fontSize: screenWidth * 0.12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Build. Customize. Share.",
              style: GoogleFonts.blinker(
                color: Colors.black87,
                fontSize: screenWidth * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
