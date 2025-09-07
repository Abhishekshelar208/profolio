import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalkWinIntroPage extends StatefulWidget {
  const WalkWinIntroPage({Key? key}) : super(key: key);

  @override
  State<WalkWinIntroPage> createState() => _WalkWinIntroPageState();
}

class _WalkWinIntroPageState extends State<WalkWinIntroPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildSplashScreen(),
          _buildIntroScreen(),
          _buildLoginScreen(),
        ],
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8C42),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Status bar
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                "9:41",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Signal and battery icons
            Positioned(
              top: 15,
              right: 20,
              child: Row(
                children: [
                  Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.wifi, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.battery_full, color: Colors.white, size: 18),
                ],
              ),
            ),

            // Clouds
            Positioned(
              top: 60,
              left: 40,
              child: _buildCloud(120, 60),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: _buildCloud(160, 80),
            ),
            
            // Stars
            Positioned(
              top: 120,
              left: 60,
              child: _buildStar(),
            ),
            Positioned(
              top: 180,
              right: 80,
              child: _buildStar(),
            ),
            Positioned(
              top: 240,
              left: 120,
              child: _buildStar(),
            ),
            Positioned(
              top: 160,
              right: 140,
              child: _buildStar(),
            ),

            // Main panda character
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Container(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: PandaPainter(),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "WalkWin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8C42),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Status bar
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                "9:41",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Signal and battery icons
            Positioned(
              top: 15,
              right: 20,
              child: Row(
                children: [
                  Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.wifi, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.battery_full, color: Colors.white, size: 18),
                ],
              ),
            ),

            // Clouds and stars
            Positioned(
              top: 40,
              left: 20,
              child: _buildCloud(140, 70),
            ),
            Positioned(
              top: 60,
              right: 40,
              child: _buildCloud(100, 50),
            ),
            
            // Stars scattered
            ..._buildScatteredStars(),

            // Main illustration
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  // Tennis player and panda
                  Container(
                    width: 300,
                    height: 200,
                    child: Stack(
                      children: [
                        // Tennis player
                        Positioned(
                          right: 20,
                          bottom: 0,
                          child: Container(
                            width: 120,
                            height: 160,
                            child: CustomPaint(
                              painter: TennisPlayerPainter(),
                            ),
                          ),
                        ),
                        // Small panda
                        Positioned(
                          left: 40,
                          bottom: 20,
                          child: Container(
                            width: 80,
                            height: 80,
                            child: CustomPaint(
                              painter: SmallPandaPainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  
                  // Text content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          "Earn rewards for\nevery step you take.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "More than tracking transform\nwalking into winning.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 40),
                        
                        // Log in button
                        Container(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF5722),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Container(
      color: Color(0xFFF5F5F5),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    "9:41",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.signal_cellular_4_bar, color: Colors.black, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.wifi, color: Colors.black, size: 18),
                  SizedBox(width: 5),
                  Icon(Icons.battery_full, color: Colors.black, size: 18),
                ],
              ),
            ),
            
            // Back button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    
                    // Title
                    Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    // Terms text
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(text: "By logging in, you agree to our "),
                          TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: "."),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Email field
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Your email",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 15),
                    
                    Text(
                      "We will send you an e-mail with a login link.",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Connect button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle connect
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5722),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Connect",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Or divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Google sign in
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Google sign in
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF4285F4),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "G",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Sign in with google",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Facebook sign in
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Facebook sign in
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF1877F2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "f",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Sign in with Facebook",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Privacy policy
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: "For more information, please see our "),
                            TextSpan(
                              text: "Privacy policy",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  Widget _buildStar() {
    return Icon(
      Icons.star,
      color: Colors.white.withOpacity(0.8),
      size: 16,
    );
  }

  List<Widget> _buildScatteredStars() {
    return [
      Positioned(top: 100, left: 40, child: _buildStar()),
      Positioned(top: 140, right: 60, child: _buildStar()),
      Positioned(top: 200, left: 80, child: _buildStar()),
      Positioned(top: 180, right: 120, child: _buildStar()),
      Positioned(top: 260, left: 160, child: _buildStar()),
      Positioned(top: 240, right: 40, child: _buildStar()),
    ];
  }
}

class PandaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Panda body (white)
    paint.color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.7),
        width: size.width * 0.6,
        height: size.height * 0.5,
      ),
      paint,
    );
    
    // Panda head (white)
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.35,
      paint,
    );
    
    // Panda ears (black)
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.2),
      size.width * 0.15,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.2),
      size.width * 0.15,
      paint,
    );
    
    // Panda eyes (black)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.3),
        width: size.width * 0.15,
        height: size.height * 0.2,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.3),
        width: size.width * 0.15,
        height: size.height * 0.2,
      ),
      paint,
    );
    
    // Eye whites
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.32),
      size.width * 0.04,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.32),
      size.width * 0.04,
      paint,
    );
    
    // Nose (black)
    paint.color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.4),
        width: size.width * 0.06,
        height: size.width * 0.04,
      ),
      paint,
    );
    
    // Arms (black)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.6),
        width: size.width * 0.15,
        height: size.height * 0.3,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.6),
        width: size.width * 0.15,
        height: size.height * 0.3,
      ),
      paint,
    );
    
    // Paws (black circles)
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.75),
      size.width * 0.08,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.75),
      size.width * 0.08,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TennisPlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Skin color
    paint.color = Color(0xFFD2B48C);
    
    // Head
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.2),
      size.width * 0.15,
      paint,
    );
    
    // Body (white shirt)
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.5),
          width: size.width * 0.4,
          height: size.height * 0.4,
        ),
        Radius.circular(10),
      ),
      paint,
    );
    
    // Arms
    paint.color = Color(0xFFD2B48C);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.3, size.height * 0.45),
        width: size.width * 0.1,
        height: size.height * 0.25,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.4),
        width: size.width * 0.1,
        height: size.height * 0.25,
      ),
      paint,
    );
    
    // Legs (white shorts)
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.45, size.height * 0.75),
          width: size.width * 0.12,
          height: size.height * 0.2,
        ),
        Radius.circular(8),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.55, size.height * 0.75),
          width: size.width * 0.12,
          height: size.height * 0.2,
        ),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Hair (dark)
    paint.color = Color(0xFF2D1810);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.15),
        width: size.width * 0.35,
        height: size.width * 0.25,
      ),
      -3.14,
      3.14,
      false,
      paint,
    );
    
    // Tennis racket
    paint.color = Color(0xFFFFA500);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.3),
        width: size.width * 0.2,
        height: size.width * 0.25,
      ),
      paint,
    );
    
    // Racket handle
    paint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.45),
        width: size.width * 0.04,
        height: size.height * 0.15,
      ),
      paint,
    );
    
    // Tennis ball
    paint.color = Color(0xFFFFFF00);
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.25),
      size.width * 0.05,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SmallPandaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Panda body (white)
    paint.color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.7),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      paint,
    );
    
    // Panda head (white)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.4),
      size.width * 0.3,
      paint,
    );
    
    // Panda ears (black)
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.25),
      size.width * 0.12,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.25),
      size.width * 0.12,
      paint,
    );
    
    // Panda eyes (black)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.42, size.height * 0.35),
        width: size.width * 0.1,
        height: size.height * 0.12,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.58, size.height * 0.35),
        width: size.width * 0.1,
        height: size.height * 0.12,
      ),
      paint,
    );
    
    // Eye whites
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.36),
      size.width * 0.03,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.36),
      size.width * 0.03,
      paint,
    );
    
    // Nose (black)
    paint.color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.42),
        width: size.width * 0.04,
        height: size.width * 0.03,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
