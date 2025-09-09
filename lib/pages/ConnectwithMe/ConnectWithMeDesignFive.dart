import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWithMeDesignFive extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ConnectWithMeDesignFive({super.key, required this.userData});

  @override
  _ConnectWithMeDesignFiveState createState() => _ConnectWithMeDesignFiveState();
}

class _ConnectWithMeDesignFiveState extends State<ConnectWithMeDesignFive>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _networkController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _networkAnimation;

  int _hoveredIndex = -1;

  // Professional Color Palette with Social Network Theme
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color softGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color darkGray = Color(0xFF334155);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color accentBlue = Color(0xFFEFF6FF);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _networkController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _networkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_networkController);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _networkController.dispose();
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

  // Modern Professional Card Container
  Widget _buildProfessionalCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isHovered = false,
    bool hasGradientBorder = false,
    List<Color>? gradientColors,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(isHovered ? 0.2 : 0.08),
            spreadRadius: 0,
            blurRadius: isHovered ? 30 : 15,
            offset: Offset(0, isHovered ? 12 : 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: hasGradientBorder && gradientColors != null
            ? null
            : Border.all(
          color: lightGray,
          width: 1.5,
        ),
      ),
      child: hasGradientBorder && gradientColors != null
          ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: gradientColors),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(22),
          ),
          padding: padding ?? const EdgeInsets.all(32),
          child: child,
        ),
      )
          : Container(
        padding: padding ?? const EdgeInsets.all(32),
        child: child,
      ),
    );
  }

  // Animated Network Connection Lines
  Widget _buildNetworkLines() {
    return AnimatedBuilder(
      animation: _networkAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(400, 300),
          painter: NetworkLinesPainter(_networkAnimation.value),
        );
      },
    );
  }

  // Social Platform Card with Modern Design
  Widget _buildSocialCard({
    required Map<String, dynamic> platform,
    required int index,
    required bool isDesktop,
  }) {
    bool isHovered = _hoveredIndex == index;
    List<Color> gradientColors = [
      platform['primaryColor'],
      platform['secondaryColor'],
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
      curve: Curves.easeOutBack,
      builder: (context, animationValue, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * animationValue),
              child: Opacity(
                opacity: _fadeAnimation.value * animationValue,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                    _scaleController.forward();
                  },
                  onExit: (_) {
                    setState(() {
                      _hoveredIndex = -1;
                    });
                    _scaleController.reverse();
                  },
                  child: GestureDetector(
                    onTap: () => _launchURL(platform['url']),
                    child: AnimatedScale(
                      scale: isHovered ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildProfessionalCard(
                        height: isDesktop ? 160 : 140,
                        hasGradientBorder: isHovered,
                        gradientColors: isHovered ? gradientColors : null,
                        padding: EdgeInsets.all(isDesktop ? 20 : 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Platform Icon with Animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isDesktop ? 56 : 48,
                              height: isDesktop ? 56 : 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isHovered
                                      ? gradientColors
                                      : [
                                    lightGray,
                                    lightGray.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isHovered ? [
                                  BoxShadow(
                                    color: platform['primaryColor'].withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ] : null,
                              ),
                              child: Icon(
                                platform['icon'],
                                color: isHovered ? pureWhite : softGray,
                                size: isDesktop ? 24 : 20,
                              ),
                            ),

                            SizedBox(height: isDesktop ? 12 : 10),

                            // Platform Name
                            Text(
                              platform['platform'],
                              style: GoogleFonts.inter(
                                fontSize: isDesktop ? 16 : 14,
                                fontWeight: FontWeight.w700,
                                color: isHovered ? platform['primaryColor'] : darkGray,
                                letterSpacing: -0.2,
                              ),
                            ),

                            SizedBox(height: isDesktop ? 6 : 4),

                            // Connection Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isHovered ? successGreen : lightGray,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Connect",
                                  style: GoogleFonts.inter(
                                    fontSize: isDesktop ? 11 : 10,
                                    fontWeight: FontWeight.w500,
                                    color: isHovered ? successGreen : softGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Professional Header Section
  Widget _buildHeaderSection(bool isDesktop) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              // Main Title with Network Icon
              Row(
                mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Container(
                    width: isDesktop ? 48 : 40,
                    height: isDesktop ? 48 : 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryBlue, lightBlue],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.hub_outlined,
                      color: pureWhite,
                      size: isDesktop ? 24 : 20,
                    ),
                  ),

                  SizedBox(width: isDesktop ? 16 : 12),

                  Flexible(
                    child: Text(
                      "Social Network Hub",
                      style: GoogleFonts.inter(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.w800,
                        color: darkGray,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isDesktop ? 12 : 10),

              // Subtitle
              Text(
                "Connect, collaborate, and create amazing things together",
                textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isDesktop ? 16 : 14,
                  color: softGray,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),

              SizedBox(height: isDesktop ? 20 : 16),

              // Status Badge
              _buildStatusBadge(isDesktop),
            ],
          ),
        );
      },
    );
  }

  // Professional Status Badge
  Widget _buildStatusBadge(bool isDesktop) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 18 : 16,
                vertical: isDesktop ? 10 : 8
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  successGreen.withOpacity(0.1),
                  successGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: successGreen.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isDesktop ? 10 : 8,
                  height: isDesktop ? 10 : 8,
                  decoration: const BoxDecoration(
                    color: successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: isDesktop ? 8 : 6),
                Text(
                  "Available for new opportunities",
                  style: GoogleFonts.inter(
                    fontSize: isDesktop ? 12 : 11,
                    fontWeight: FontWeight.w600,
                    color: successGreen,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Thank You Section with Modern Design (NO ANIMATION)
  Widget _buildThankYouSection(bool isDesktop) {
    return _buildProfessionalCard(
      padding: EdgeInsets.all(isDesktop ? 28 : 20),
      hasGradientBorder: true,
      gradientColors: const [primaryBlue, lightBlue, warningOrange],
      child: Row(
        children: [
          // Thank You Icon
          Container(
            width: isDesktop ? 64 : 48,
            height: isDesktop ? 64 : 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [warningOrange, primaryBlue],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: pureWhite,
              size: isDesktop ? 32 : 24,
            ),
          ),

          SizedBox(width: isDesktop ? 20 : 16),

          // Thank You Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thank You for Visiting!",
                  style: GoogleFonts.inter(
                    fontSize: isDesktop ? 20 : 16,
                    fontWeight: FontWeight.w700,
                    color: darkGray,
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: isDesktop ? 8 : 6),

                Text(
                  "I appreciate your interest in my work. Let's connect and build something incredible together!",
                  style: GoogleFonts.inter(
                    fontSize: isDesktop ? 14 : 12,
                    color: softGray,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Social platforms data
  List<Map<String, dynamic>> _getSocialPlatforms() {
    return [
      {
        'platform': 'LinkedIn',
        'url': widget.userData["accountLinks"]["linkedin"] ?? "",
        'icon': Icons.business_center_rounded,
        'primaryColor': const Color(0xFF0077B5),
        'secondaryColor': const Color(0xFF00A0DC),
        'description': 'Professional Network',
      },
      {
        'platform': 'GitHub',
        'url': widget.userData["accountLinks"]["github"] ?? "",
        'icon': Icons.code_rounded,
        'primaryColor': const Color(0xFF333333),
        'secondaryColor': const Color(0xFF586069),
        'description': 'Open Source Projects',
      },
      {
        'platform': 'Instagram',
        'url': widget.userData["accountLinks"]["instagram"] ?? "",
        'icon': Icons.camera_alt_rounded,
        'primaryColor': const Color(0xFFE4405F),
        'secondaryColor': const Color(0xFFF56040),
        'description': 'Creative Updates',
      },
      {
        'platform': 'WhatsApp',
        'url': 'https://wa.me/91${widget.userData["accountLinks"]["whatsapp"] ?? ""}',
        'icon': Icons.chat_bubble_rounded,
        'primaryColor': const Color(0xFF25D366),
        'secondaryColor': const Color(0xFF128C7E),
        'description': 'Quick Messages',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        return _buildProfessionalCard(
          padding: EdgeInsets.all(isDesktop ? 40 : 24),
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(isDesktop),

              SizedBox(height: isDesktop ? 36 : 24),

              // Main Content
              if (isDesktop)
                _buildDesktopLayout()
              else
                _buildMobileLayout(),

              SizedBox(height: isDesktop ? 36 : 24),

              // Thank You Section
              _buildThankYouSection(isDesktop),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    List<Map<String, dynamic>> platforms = _getSocialPlatforms();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side - Network Visualization
        Expanded(
          flex: 2,
          child: Container(
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated Network Lines Background
                _buildNetworkLines(),

                // Central Hub
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryBlue, lightBlue],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.4),
                              spreadRadius: 0,
                              blurRadius: 25,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: pureWhite,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 36),

        // Right Side - Social Platform Cards
        Expanded(
          flex: 3,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: platforms.length,
            itemBuilder: (context, index) {
              return _buildSocialCard(
                platform: platforms[index],
                index: index,
                isDesktop: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    List<Map<String, dynamic>> platforms = _getSocialPlatforms();

    return Column(
      children: [
        // Network Visualization
        Container(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildNetworkLines(),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryBlue, lightBlue],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: pureWhite,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Social Platform Cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: platforms.length,
          itemBuilder: (context, index) {
            return _buildSocialCard(
              platform: platforms[index],
              index: index,
              isDesktop: false,
            );
          },
        ),
      ],
    );
  }
}

// Custom Painter for Network Connection Lines
class NetworkLinesPainter extends CustomPainter {
  final double animationValue;

  NetworkLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw animated connection lines
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 * 3.14159 / 180) + (animationValue * 2 * 3.14159);
      final endX = centerX + (size.width * 0.3) * (0.5 + 0.5 * (animationValue % 1)) *
          (1 + 0.2 * (i % 2 == 0 ? 1 : -1)) * (centerX / 100);
      final endY = centerY + (size.height * 0.3) * (0.5 + 0.5 * (animationValue % 1)) *
          (1 + 0.2 * (i % 2 == 0 ? 1 : -1)) * (centerY / 100);

      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(
          centerX + endX * (0.5 + 0.5 * ((animationValue + i * 0.1) % 1)),
          centerY + endY * (0.5 + 0.5 * ((animationValue + i * 0.1) % 1)),
        ),
        paint,
      );
    }

    // Draw connection nodes
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final angle = i * 90 * 3.14159 / 180;
      final nodeX = centerX + 80 * (1 + 0.3 * (animationValue % 1)) *
          (centerX / 100) * 0.8;
      final nodeY = centerY + 80 * (1 + 0.3 * (animationValue % 1)) *
          (centerY / 100) * 0.8;

      canvas.drawCircle(
        Offset(nodeX, nodeY),
        4 + 2 * ((animationValue + i * 0.25) % 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(NetworkLinesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}