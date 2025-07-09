import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
    _splashServices.checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), // Half of height/width for a circle
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 2.0,        // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/assets/images/profoliologo.jpg',
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover, // Ensures the image fits within the container
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              Text(
                "Profolio",
                style: GoogleFonts.blinker(
                  color: Colors.white, // Set color to white to ensure the gradient is visible
                  fontSize: screenWidth * 0.070,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
            ],
          ),
        ),
      ),
    );
  }
}
