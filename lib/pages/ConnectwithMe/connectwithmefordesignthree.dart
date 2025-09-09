import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWithMedesignThree extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ConnectWithMedesignThree({super.key, required this.userData});

  @override
  _ConnectWithMedesignThreeState createState() => _ConnectWithMedesignThreeState();
}

class _ConnectWithMedesignThreeState extends State<ConnectWithMedesignThree>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late List<AnimationController> _socialControllers;
  late List<Animation<double>> _socialAnimations;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the main container
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Individual animations for social icons
    _socialControllers = List.generate(4, (index) => AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800 + (index * 100)),
    ));

    _socialAnimations = _socialControllers.map((controller) => 
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      ),
    ).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _socialControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _socialControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (var controller in _socialControllers) {
      controller.dispose();
    }
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

  // Glassmorphism Container matching designThree.dart
  Widget _buildGlassMorphismContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: child,
        ),
      ),
    );
  }

  // Animated social icon with glassmorphic design
  Widget _buildAnimatedSocialIcon(String assetPath, String url, Color accentColor, int index) {
    return AnimatedBuilder(
      animation: _socialAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _socialAnimations[index].value,
          child: GestureDetector(
            onTap: () => _launchURL(url),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.3),
                            accentColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Image.asset(
                              assetPath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                _getIconForSocial(assetPath),
                                size: 30,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForSocial(String assetPath) {
    if (assetPath.contains('insta')) return Icons.camera_alt;
    if (assetPath.contains('whatsapp') || assetPath.contains('logo')) return Icons.chat;
    if (assetPath.contains('linkedin')) return Icons.business;
    if (assetPath.contains('github')) return Icons.code;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        
        return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 900, // Limit max width for desktop
          ),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value * 0.98 + 0.02, // Very subtle pulse
                child: _buildGlassMorphismContainer(
                  padding: EdgeInsets.all(isMobile ? 20 : 32), // Adjusted padding
                  child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Connect with Me title with gradient text
        GradientText(
          "Connect with Me",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          colors: [
            Colors.white,
            Color(0xFF6C63FF),
            Color(0xFF1DD1A1),
          ],
        ),

        SizedBox(height: 8),

        // Subtitle
        Text(
          "Let's build something amazing together",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 30),

        // Mobile: 2x2 grid
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnimatedSocialIcon(
                  'lib/assets/images/newinsta.png',
                  widget.userData["accountLinks"]["instagram"] ?? "",
                  Color(0xFFE4405F), // Instagram pink
                  0,
                ),
                _buildAnimatedSocialIcon(
                  'lib/assets/images/logo.png',
                  'https://wa.me/91${widget.userData["accountLinks"]["whatsapp"] ?? ""}',
                  Color(0xFF25D366), // WhatsApp green
                  1,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnimatedSocialIcon(
                  'lib/assets/images/newlinkedin.png',
                  widget.userData["accountLinks"]["linkedin"] ?? "",
                  Color(0xFF0077B5), // LinkedIn blue
                  2,
                ),
                _buildAnimatedSocialIcon(
                  'lib/assets/images/newgithub.png',
                  widget.userData["accountLinks"]["github"] ?? "",
                  Color(0xFF333333), // GitHub dark
                  3,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 30),

        // Divider with gradient
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Thank you message
        GradientText(
          "Thank you for exploring!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          colors: [
            Colors.white,
            Color(0xFF1DD1A1),
          ],
        ),

        SizedBox(height: 12),

        // Appreciation message
        Text(
          "I truly appreciate your time and interest in my work.\nLet's connect and create something extraordinary!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        SizedBox(height: 20),

        // Call to action badge
        _buildCollaborationBadge(12),
      ],
    );
  }

  // Optimized Desktop Layout
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        // Header Section with compact design
        Row(
          children: [
            // Left side - Title and subtitle
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    "Connect with Me",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    colors: [
                      Colors.white,
                      Color(0xFF6C63FF),
                      Color(0xFF1DD1A1),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Let's build something amazing together",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 40),
            
            // Right side - Social icons in compact row
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCompactSocialIcon(
                    'lib/assets/images/newinsta.png',
                    widget.userData["accountLinks"]["instagram"] ?? "",
                    Color(0xFFE4405F), // Instagram pink
                    0,
                  ),
                  _buildCompactSocialIcon(
                    'lib/assets/images/logo.png',
                    'https://wa.me/91${widget.userData["accountLinks"]["whatsapp"] ?? ""}',
                    Color(0xFF25D366), // WhatsApp green
                    1,
                  ),
                  _buildCompactSocialIcon(
                    'lib/assets/images/newlinkedin.png',
                    widget.userData["accountLinks"]["linkedin"] ?? "",
                    Color(0xFF0077B5), // LinkedIn blue
                    2,
                  ),
                  _buildCompactSocialIcon(
                    'lib/assets/images/newgithub.png',
                    widget.userData["accountLinks"]["github"] ?? "",
                    Color(0xFF333333), // GitHub dark
                    3,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 32),

        // Divider with gradient
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        SizedBox(height: 24),

        // Bottom section - Compact message and badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left - Thank you message
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    "Thank you for exploring!",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    colors: [
                      Colors.white,
                      Color(0xFF1DD1A1),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "I truly appreciate your time and interest.\nLet's connect and create something extraordinary!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 40),
            
            // Right - Collaboration badge
            _buildCollaborationBadge(14),
          ],
        ),
      ],
    );
  }

  // Compact social icon for desktop
  Widget _buildCompactSocialIcon(String assetPath, String url, Color accentColor, int index) {
    return AnimatedBuilder(
      animation: _socialAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _socialAnimations[index].value,
          child: GestureDetector(
            onTap: () => _launchURL(url),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.25),
                      accentColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.15),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        assetPath,
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          _getIconForSocial(assetPath),
                          size: 24,
                          color: Colors.white.withValues(alpha: 0.8),
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

  // Reusable collaboration badge
  Widget _buildCollaborationBadge(double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6C63FF).withValues(alpha: 0.3),
            Color(0xFF1DD1A1).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.handshake_outlined,
            color: Color(0xFF1DD1A1),
            size: fontSize + 2,
          ),
          SizedBox(width: 8),
          Text(
            "Open for collaboration",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
