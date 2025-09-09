import 'dart:ui';
import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWithMeDesignFour extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ConnectWithMeDesignFour({super.key, required this.userData});

  @override
  _ConnectWithMeDesignFourState createState() => _ConnectWithMeDesignFourState();
}

class _ConnectWithMeDesignFourState extends State<ConnectWithMeDesignFour>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _orbitalController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _orbitalAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _orbitalController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
    )..repeat();

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotateController);

    _pulseAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_waveController);

    _orbitalAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_orbitalController);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _orbitalController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  // Enhanced Glassmorphic Container matching DesignFour
  Widget _buildGlassMorphicCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool hasBorder = true,
    bool hasGlow = false,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding ?? EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: hasBorder ? Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
                if (hasGlow) ...[
                  BoxShadow(
                    color: Color(0xFF6366F1).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: Offset(0, 0),
                  ),
                ],
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Orbital Social Icon with complex animations
  Widget _buildOrbitalSocialIcon({
    required String platform,
    required String url,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required int index,
    required double radius,
    required double centerX,
    required double centerY,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_orbitalController, _pulseController, _floatController]),
      builder: (context, child) {
        double angle = _orbitalAnimation.value + (index * pi / 2);
        double x = centerX + radius * cos(angle);
        double y = centerY + radius * sin(angle) + (_floatAnimation.value * 0.3);

        return Positioned(
          left: x,
          top: y,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: GestureDetector(
              onTap: () => _launchURL(url),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        primaryColor.withOpacity(0.8),
                        secondaryColor.withOpacity(0.6),
                        primaryColor.withOpacity(0.3),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        spreadRadius: 0,
                        blurRadius: 25,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: secondaryColor.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Animated wave background pattern
  Widget _buildWaveBackground() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, 200),
          painter: WavePainter(_waveAnimation.value),
        );
      },
    );
  }

  // Central connection hub
  Widget _buildConnectionHub(bool isMobile) {
    double size = isMobile ? 120 : 160;

    return AnimatedBuilder(
      animation: Listenable.merge([_rotateController, _pulseController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value * 0.2,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF6366F1).withOpacity(0.8),
                    Color(0xFF8B5CF6).withOpacity(0.6),
                    Color(0xFFEC4899).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.4, 0.7, 1.0],
                ),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFEC4899),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6366F1).withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 30,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.connect_without_contact,
                        size: isMobile ? 40 : 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Social platforms data
  List<Map<String, dynamic>> _getSocialPlatforms() {
    return [
      {
        'platform': 'Instagram',
        'url': widget.userData["accountLinks"]["instagram"] ?? "",
        'icon': Icons.camera_alt_rounded,
        'primaryColor': Color(0xFFE4405F),
        'secondaryColor': Color(0xFFF56040),
      },
      {
        'platform': 'WhatsApp',
        'url': 'https://wa.me/91${widget.userData["accountLinks"]["whatsapp"] ?? ""}',
        'icon': Icons.chat_bubble_rounded,
        'primaryColor': Color(0xFF25D366),
        'secondaryColor': Color(0xFF128C7E),
      },
      {
        'platform': 'LinkedIn',
        'url': widget.userData["accountLinks"]["linkedin"] ?? "",
        'icon': Icons.business_center_rounded,
        'primaryColor': Color(0xFF0077B5),
        'secondaryColor': Color(0xFF00A0DC),
      },
      {
        'platform': 'GitHub',
        'url': widget.userData["accountLinks"]["github"] ?? "",
        'icon': Icons.code_rounded,
        'primaryColor': Color(0xFF333333),
        'secondaryColor': Color(0xFF586069),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value * 0.5),
              child: _buildGlassMorphicCard(
                hasGlow: true,
                padding: EdgeInsets.all(isMobile ? 30 : 50),
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    List<Map<String, dynamic>> platforms = _getSocialPlatforms();

    return Column(
      children: [
        // Header with gradient title
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ).createShader(bounds),
          child: Text(
            "Let's Connect",
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(height: 16),

        Text(
          "Building the future, one connection at a time",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        SizedBox(height: 50),

        // Orbital connection system
        Container(
          height: 300,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Wave background
              Positioned.fill(
                child: _buildWaveBackground(),
              ),

              // Central hub
              _buildConnectionHub(true),

              // Orbital social icons
              ...platforms.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> platform = entry.value;

                return _buildOrbitalSocialIcon(
                  platform: platform['platform'],
                  url: platform['url'],
                  icon: platform['icon'],
                  primaryColor: platform['primaryColor'],
                  secondaryColor: platform['secondaryColor'],
                  index: index,
                  radius: 100,
                  centerX: 110,
                  centerY: 110,
                );
              }).toList(),
            ],
          ),
        ),

        SizedBox(height: 40),

        // Collaboration invitation
        _buildCollaborationInvite(true),

        SizedBox(height: 30),

        // Appreciation message with pulsing effect
        // AnimatedBuilder(
        //   animation: _pulseController,
        //   builder: (context, child) {
        //     return Transform.scale(
        //       scale: 0.98 + (_pulseAnimation.value - 0.85) * 0.4,
        //       child: Container(
        //         padding: EdgeInsets.all(24),
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [
        //               Color(0xFF6366F1).withOpacity(0.1),
        //               Color(0xFF8B5CF6).withOpacity(0.1),
        //             ],
        //           ),
        //           borderRadius: BorderRadius.circular(20),
        //           border: Border.all(
        //             color: Colors.white.withOpacity(0.2),
        //             width: 1,
        //           ),
        //         ),
        //         child: Column(
        //           children: [
        //             Icon(
        //               Icons.favorite_rounded,
        //               color: Color(0xFFEC4899),
        //               size: 32,
        //             ),
        //             SizedBox(height: 12),
        //             ShaderMask(
        //               shaderCallback: (bounds) => LinearGradient(
        //                 colors: [Colors.white, Color(0xFFEC4899)],
        //               ).createShader(bounds),
        //               child: Text(
        //                 "Thank You",
        //                 style: GoogleFonts.inter(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //             SizedBox(height: 8),
        //             Text(
        //               "for exploring my digital space",
        //               textAlign: TextAlign.center,
        //               style: GoogleFonts.inter(
        //                 fontSize: 14,
        //                 color: Colors.white.withOpacity(0.8),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    List<Map<String, dynamic>> platforms = _getSocialPlatforms();

    return Column(
      children: [
        // Header section
        Row(
          children: [
            // Left side - Title and description
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      "Let's Connect",
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Building the future, one connection at a time",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 24),

                  _buildCollaborationInvite(false),
                ],
              ),
            ),

            SizedBox(width: 60),

            // Right side - Orbital connection system
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wave background
                    Positioned.fill(
                      child: _buildWaveBackground(),
                    ),

                    // Central hub
                    _buildConnectionHub(false),

                    // Orbital social icons
                    ...platforms.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> platform = entry.value;

                      return _buildOrbitalSocialIcon(
                        platform: platform['platform'],
                        url: platform['url'],
                        icon: platform['icon'],
                        primaryColor: platform['primaryColor'],
                        secondaryColor: platform['secondaryColor'],
                        index: index,
                        radius: 140,
                        centerX: 160,
                        centerY: 160,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 40),

        // Appreciation section
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.98 + (_pulseAnimation.value - 0.85) * 0.4,
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6366F1).withOpacity(0.1),
                      Color(0xFF8B5CF6).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFEC4899),
                      size: 48,
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Color(0xFFEC4899)],
                            ).createShader(bounds),
                            child: Text(
                              "Thank You for Exploring",
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Your interest in my work means everything. Let's create something extraordinary together!",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Collaboration invitation badge
  Widget _buildCollaborationInvite(bool isMobile) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 24,
            vertical: isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6366F1).withOpacity(0.3),
                Color(0xFF8B5CF6).withOpacity(0.3),
                Color(0xFFEC4899).withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6366F1).withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: _rotateAnimation.value * 0.5,
                child: Icon(
                  Icons.handshake_rounded,
                  color: Color(0xFF8B5CF6),
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Open for Collaboration",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Wave painter for background animation
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFF6366F1).withOpacity(0.1),
          Color(0xFF8B5CF6).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x += 5) {
      double y = size.height / 2 +
          sin((x / waveLength * 2 * pi) + (animationValue * 2 * pi)) * waveHeight +
          cos((x / waveLength * 4 * pi) + (animationValue * 3 * pi)) * (waveHeight * 0.5);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}