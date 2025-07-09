import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWithMedesignTwo extends StatelessWidget {
  final Map<String, dynamic> userData;

  ConnectWithMedesignTwo({required this.userData});

  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch $url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        double iconSize = isMobile ? 35 : 40;
        double textSize = isMobile ? 28 : 35;
        double thankYouSize = isMobile ? 22 : 28;
        double interestSize = isMobile ? 18 : 24;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Connect with ",
                    style: GoogleFonts.blinker(
                      fontSize: textSize,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    )),
                Text("Me",
                    style: GoogleFonts.blinker(
                      fontSize: textSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon('lib/assets/images/newinsta.png', userData["accountLinks"]["instagram"] ?? ""),
                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 80 : 50),

                _socialIcon('lib/assets/images/logo.png', 'https://wa.me/91${userData["accountLinks"]["whatsapp"] ?? ""}'),
                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 80 : 50),

                _socialIcon('lib/assets/images/newlinkedin.png', userData["accountLinks"]["linkedin"] ?? ""),
                SizedBox(width: MediaQuery.of(context).size.width > 600 ? 80 : 50),

                _socialIcon('lib/assets/images/newgithub.png', userData["accountLinks"]["github"] ?? ""),
              ],
            ),

            SizedBox(height: 20),
            FittedBox(
              child: Text("Thank you for exploring my portfolio!",
                  style: GoogleFonts.blinker(
                    fontSize: thankYouSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FittedBox(
              child: Text("I truly appreciate your time and interest in my work.",
                  style: GoogleFonts.blinker(
                    fontSize: interestSize,
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        );
      },
    );
  }

  Widget _socialIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        height: 40,
        width: 40,
        child: Image.asset(assetPath),
      ),
    );
  }
}
