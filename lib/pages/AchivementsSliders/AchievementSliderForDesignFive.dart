import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementSliderForDesignFive extends StatefulWidget {
  final List<dynamic> achievements;

  const AchievementSliderForDesignFive({super.key, required this.achievements});

  @override
  _AchievementSliderForDesignFiveState createState() => _AchievementSliderForDesignFiveState();
}

class _AchievementSliderForDesignFiveState extends State<AchievementSliderForDesignFive>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Professional Color Palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color softGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color darkGray = Color(0xFF334155);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color accentBlue = Color(0xFFEFF6FF);
  static const Color goldAccent = Color(0xFFD97706);
  static const Color lightGold = Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
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
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _showPrevious() {
    if (currentStartIndex > 0) {
      setState(() {
        currentStartIndex = (currentStartIndex - 3).clamp(0, widget.achievements.length - 1);
      });
      _animateTransition();
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.achievements.length) {
      setState(() {
        currentStartIndex += 3;
      });
      _animateTransition();
    }
  }

  void _animateTransition() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  // Professional Card Container
  Widget _buildProfessionalCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isHovered = false,
    bool hasGlow = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: hasGlow
                ? primaryBlue.withOpacity(isHovered ? 0.2 : 0.12)
                : primaryBlue.withOpacity(isHovered ? 0.15 : 0.08),
            spreadRadius: 0,
            blurRadius: isHovered ? 30 : 20,
            offset: Offset(0, isHovered ? 15 : 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          if (hasGlow) 
            BoxShadow(
              color: goldAccent.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
        ],
        border: Border.all(
          color: hasGlow ? goldAccent.withOpacity(0.2) : lightGray,
          width: 1,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: padding ?? const EdgeInsets.all(28),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -8.0 : 0.0),
        child: child,
      ),
    );
  }

  // Professional Achievement Badge
  Widget _buildProfessionalBadge({
    required IconData icon,
    required List<Color> colors,
    double size = 70,
    int index = 0,
  }) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateController.value * 0.2 * (index % 2 == 0 ? 1 : -1),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(size / 4),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: colors[1].withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shimmer effect
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size / 4),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            pureWhite.withOpacity(0.3 * _shimmerController.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Icon
                Icon(
                  icon,
                  color: pureWhite,
                  size: size * 0.45,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Enhanced Achievement Card
  Widget _buildAchievementCard(dynamic achievement, bool isDesktop, int index) {
    List<List<Color>> gradients = [
      [primaryBlue, lightBlue],
      [goldAccent, lightGold],
      [lightBlue, primaryBlue],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * animationValue),
              child: Opacity(
                opacity: _fadeAnimation.value * animationValue,
                child: MouseRegion(
                  onEnter: (_) => _scaleController.forward(),
                  onExit: (_) => _scaleController.reverse(),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1.0,
                      end: 1.03,
                    ).animate(CurvedAnimation(
                      parent: _scaleController,
                      curve: Curves.easeInOut,
                    )),
                    child: _buildProfessionalCard(
                      height: isDesktop ? 520 : 550,
                      hasGlow: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Achievement Image Section
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                // Main image container
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        accentBlue,
                                        lightGray.withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
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

                                // Professional Badge Overlay
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: _buildProfessionalBadge(
                                    icon: Icons.emoji_events,
                                    colors: cardGradient,
                                    size: 60,
                                    index: index,
                                  ),
                                ),

                                // Achievement Level Indicator
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: pureWhite,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: cardGradient[0],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Achievement",
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: cardGradient[0],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Achievement Title
                          Text(
                            achievement["title"] ?? "Achievement Title",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: isDesktop ? 20 : 18,
                              fontWeight: FontWeight.w700,
                              color: darkGray,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),

                          // Professional Divider with Animation
                          AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: cardGradient[0],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 40,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: cardGradient),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: cardGradient[1],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Achievement Description
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Text(
                                achievement["description"] ?? 
                                "Outstanding achievement showcasing exceptional performance, dedication, and professional excellence. This accomplishment represents significant contribution and milestone in career development.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: softGray,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Professional Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cardGradient[0].withOpacity(0.1),
                                  cardGradient[1].withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: cardGradient[0].withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.workspace_premium_outlined,
                                  color: cardGradient[0],
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Professional Achievement",
                                  style: GoogleFonts.inter(
                                    color: cardGradient[0],
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Professional Fallback Image
  Widget _buildFallbackImage(List<Color> colors) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[0].withOpacity(0.1),
            colors[1].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 60,
            color: colors[0].withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          Text(
            "Achievement",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colors[0].withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Professional Image Dialog
  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: _buildProfessionalCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Achievement Image",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: darkGray,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: softGray,
                      size: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Image Content
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 60,
                          color: softGray,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Image not available",
                          style: GoogleFonts.inter(
                            color: softGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  // Professional Navigation Button
  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryBlue, lightBlue],
              )
            : null,
        color: isEnabled ? null : lightGray,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ] : null,
        border: Border.all(
          color: isEnabled ? Colors.transparent : lightGray,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isEnabled ? pureWhite : softGray,
          size: 22,
        ),
      ),
    );
  }

  // Mobile View with Professional PageView
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildAchievementCard(widget.achievements[index], false, index),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Professional Page Indicators
        _buildProfessionalCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [goldAccent, lightGold],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              
              const SizedBox(width: 12),

              // Page indicators
              ...List.generate(widget.achievements.length, (index) {
                bool isActive = index == currentStartIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [goldAccent, lightGold],
                          )
                        : null,
                    color: isActive ? null : lightGray,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Empty state with professional design
    if (widget.achievements.isEmpty) {
      return _buildProfessionalCard(
        height: 520,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfessionalBadge(
                icon: Icons.emoji_events_outlined,
                colors: [lightGray, lightGray.withOpacity(0.5)],
                size: 100,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                "No Achievements Available",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  color: darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                "Professional achievements will be displayed here",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: softGray,
                  fontWeight: FontWeight.w400,
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
                  icon: Icons.chevron_left,
                  isEnabled: currentStartIndex > 0,
                  onPressed: currentStartIndex > 0 ? _showPrevious : null,
                ),

                const SizedBox(width: 28),

                // 3 achievement slots
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleAchievements.length) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildAchievementCard(
                              visibleAchievements[slotIndex],
                              true,
                              slotIndex,
                            ),
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: SizedBox.shrink(),
                          ),
                        );
                      }
                    }),
                  ),
                ),

                const SizedBox(width: 28),

                // Next button
                _buildNavButton(
                  icon: Icons.chevron_right,
                  isEnabled: currentStartIndex + 3 < widget.achievements.length,
                  onPressed: currentStartIndex + 3 < widget.achievements.length ? _showNext : null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Professional Achievement Counter
            _buildProfessionalCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [goldAccent, lightGold],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Text(
                    "Showing ${currentStartIndex + 1}-$endIndex of ${widget.achievements.length} achievements",
                    style: GoogleFonts.inter(
                      color: softGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
