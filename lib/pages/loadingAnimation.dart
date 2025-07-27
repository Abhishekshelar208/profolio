import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  final VoidCallback? onFinish;

  LoadingScreen({this.onFinish});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (onFinish != null) onFinish!();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/lottieAnimations/animationThree.json',
              height: 300,
              fit: BoxFit.contain,
              repeat: true,
            ),
            SizedBox(height: 30),
            Text(
              "Creating Your Portfolio",
              textAlign: TextAlign.center,
              style: GoogleFonts.blinker(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "This may take a few minutes based on your data.",
                textAlign: TextAlign.center,
                style: GoogleFonts.blinker(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
