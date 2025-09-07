import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfilePage extends StatelessWidget {
  const DeveloperProfilePage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Developer",
                  style: GoogleFonts.blinker(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: screenWidth * 0.015,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage:
                    AssetImage("lib/assets/images/MyPic.jpeg"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Abhishek Shelar",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "Full Stack App Developer",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "I’m Abhishek Shelar, a Computer Engineering student passionate about solving real-world problems through innovative tech solutions, startup ideas, and leadership experience. I turn ideas into impactful digital products.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Connect with Me",
                  style: GoogleFonts.blinker(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      'lib/assets/images/linkedin.png',
                      screenHeight,
                      screenWidth,
                          () => _launchUrl(
                          'https://www.linkedin.com/in/abhishek-shelar-0461b7209/'),
                    ),
                    _buildSocialIcon(
                      'lib/assets/images/github.png',
                      screenHeight,
                      screenWidth,
                          () => _launchUrl('https://github.com/Abhishekshelar208'),
                    ),
                    _buildSocialIcon(
                      'lib/assets/images/instagram.png',
                      screenHeight,
                      screenWidth,
                          () => _launchUrl(
                          'https://www.instagram.com/abhishek.shelar28/'),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double screenHeight,
      double screenWidth, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.13,
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
        child: Image.asset(assetPath),
      ),
    );
  }
}
