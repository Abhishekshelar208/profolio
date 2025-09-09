import 'dart:ui';
import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementSliderForDesignFour extends StatefulWidget {
  final List<dynamic> achievements;

  const AchievementSliderForDesignFour({super.key, required this.achievements});

  @override
  _AchievementSliderForDesignFourState createState() => _AchievementSliderForDesignFourState();
}

class _AchievementSliderForDesignFourState extends State<AchievementSliderForDesignFour>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    _floatAnimation = Tween<double>(
      begin: -12.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotateController);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(_shimmerController);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _showPrevious() {
    if (currentStartIndex > 0) {
      setState(() {
        currentStartIndex = (currentStartIndex - 3).clamp(0, widget.achievements.length - 1);
      });
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.achievements.length) {
      setState(() {
        currentStartIndex += 3;
      });
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
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding ?? EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: hasBorder ? Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: Offset(0, 12),
                ),
                if (hasGlow) ...[
                  BoxShadow(
                    color: Color(0xFF6366F1).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: Offset(0, 5),
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

  // Diamond-shaped achievement icon
  Widget _buildDiamondAchievementIcon({
    required IconData icon,
    required List<Color> colors,
    double size = 80,
    int index = 0,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotateController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 0.1 * (index % 2 == 0 ? 1 : -1),
            child: Container(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect
                  Container(
                    width: size + 10,
                    height: size + 10,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          colors[0].withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Diamond background
                  ClipPath(
                    clipper: DiamondClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors[0].withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Icon
                  Icon(
                    icon,
                    color: Colors.white,
                    size: size * 0.4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Enhanced Achievement Card
  Widget _buildAchievementCard(dynamic achievement, bool isDesktop, int index) {
    List<List<Color>> gradients = [
      [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      [Color(0xFFEC4899), Color(0xFFF59E0B)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * (index % 2 == 0 ? 0.7 : -0.7)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 300)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildGlassMorphicCard(
                  height: isDesktop ? 520 : 550,
                  hasGlow: true,
                  child: Column(
                    children: [
                      // Achievement Image or Icon
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            // Main image container
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: cardGradient.map((c) => c.withOpacity(0.1)).toList(),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: achievement["image"] != null && achievement["image"].toString().isNotEmpty
                                    ? GestureDetector(
                                  onTap: () => _showImageDialog(achievement["image"]),
                                  child: Image.network(
                                    achievement["image"],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildFallbackImage(cardGradient),
                                  ),
                                )
                                    : _buildFallbackImage(cardGradient),
                              ),
                            ),

                            // Shimmer effect overlay
                            AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (context, child) {
                                return Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                          stops: [
                                            (_shimmerAnimation.value - 0.5).clamp(0.0, 1.0),
                                            _shimmerAnimation.value.clamp(0.0, 1.0),
                                            (_shimmerAnimation.value + 0.5).clamp(0.0, 1.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Achievement Badge
                            Positioned(
                              top: 16,
                              right: 16,
                              child: _buildDiamondAchievementIcon(
                                icon: Icons.emoji_events,
                                colors: cardGradient,
                                size: 60,
                                index: index,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Achievement Title with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: cardGradient,
                        ).createShader(bounds),
                        child: Text(
                          achievement["title"] ?? "Achievement Title",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: isDesktop ? 22 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Decorative separator with animation
                      AnimatedBuilder(
                        animation: _rotateController,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.rotate(
                                angle: _rotateAnimation.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: cardGradient),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                width: 50,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: cardGradient),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              SizedBox(width: 12),
                              Transform.rotate(
                                angle: -_rotateAnimation.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: cardGradient),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // Achievement Description
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Text(
                            achievement["description"] ?? "Achievement description will be displayed here with detailed information about this accomplishment.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Achievement Category Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: cardGradient.map((c) => c.withOpacity(0.3)).toList(),
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: cardGradient[1],
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Achievement",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  // Fallback image widget
  Widget _buildFallbackImage(List<Color> colors) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.map((c) => c.withOpacity(0.2)).toList()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.emoji_events_outlined,
        size: 80,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  // Image dialog
  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: _buildGlassMorphicCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Close",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Button
  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            icon == Icons.arrow_back_ios ? _floatAnimation.value * 0.3 : -_floatAnimation.value * 0.3,
            0,
          ),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                    : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.1)],
              ),
              shape: BoxShape.circle,
              boxShadow: isEnabled ? [
                BoxShadow(
                  color: Color(0xFF6366F1).withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ] : null,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile View
  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 570,
          child: PageView.builder(
            itemCount: widget.achievements.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildAchievementCard(widget.achievements[index], false, index),
              );
            },
          ),
        ),
        SizedBox(height: 20),

        // Page indicators
        _buildGlassMorphicCard(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.achievements.length, (index) {
              bool isActive = index == currentStartIndex;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                      : null,
                  color: isActive ? null : Colors.white.withOpacity(0.4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.achievements.isEmpty) {
      return _buildGlassMorphicCard(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDiamondAchievementIcon(
                icon: Icons.emoji_events_outlined,
                colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.3)],
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                "No Achievements Available",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        if (!isDesktop) return _buildMobileView();

        // Desktop view: Show 3 achievements in a row
        int endIndex = (currentStartIndex + 3).clamp(0, widget.achievements.length);
        List<dynamic> visibleAchievements = widget.achievements.sublist(currentStartIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Previous button
                _buildNavButton(
                  icon: Icons.arrow_back_ios,
                  isEnabled: currentStartIndex > 0,
                  onPressed: currentStartIndex > 0 ? _showPrevious : null,
                ),

                SizedBox(width: 24),

                // 3 achievement slots
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleAchievements.length) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildAchievementCard(
                              visibleAchievements[slotIndex],
                              true,
                              slotIndex,
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(),
                          ),
                        );
                      }
                    }),
                  ),
                ),

                SizedBox(width: 24),

                // Next button
                _buildNavButton(
                  icon: Icons.arrow_forward_ios,
                  isEnabled: currentStartIndex + 3 < widget.achievements.length,
                  onPressed: currentStartIndex + 3 < widget.achievements.length ? _showNext : null,
                ),
              ],
            ),

            SizedBox(height: 30),

            // Achievement counter indicator
            _buildGlassMorphicCard(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "${currentStartIndex + 1}-${endIndex} of ${widget.achievements.length} Achievements",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Diamond Clipper for achievement icons
class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(width / 2, 0); // Top
    path.lineTo(width, height / 2); // Right
    path.lineTo(width / 2, height); // Bottom
    path.lineTo(0, height / 2); // Left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}