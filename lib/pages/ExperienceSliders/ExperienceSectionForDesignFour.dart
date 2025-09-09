import 'dart:ui';
import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceSectionForDesignFour extends StatefulWidget {
  final List<dynamic> experiences;

  const ExperienceSectionForDesignFour({super.key, required this.experiences});

  @override
  _ExperienceSectionForDesignFourState createState() => _ExperienceSectionForDesignFourState();
}

class _ExperienceSectionForDesignFourState extends State<ExperienceSectionForDesignFour>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showPrevious() {
    if (currentStartIndex > 0) {
      setState(() {
        currentStartIndex = (currentStartIndex - 3).clamp(0, widget.experiences.length - 1);
      });
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.experiences.length) {
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
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
              borderRadius: BorderRadius.circular(24),
              border: hasBorder ? Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Simplified Experience Card - Only Title and Description
  Widget _buildExperienceCard(dynamic experience, bool isDesktop, int index) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * (index % 2 == 0 ? 0.6 : -0.6)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 250)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildGlassMorphicCard(
                  height: isDesktop ? 350 : 380,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          experience["title"] ?? "Position Title",
                          style: GoogleFonts.inter(
                            fontSize: isDesktop ? 24 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 24),

                      // Decorative line separator
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                              Color(0xFFEC4899),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Experience Description
                      Expanded(
                        child: SingleChildScrollView(
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseAnimation.value - 0.9) * 0.1,
                                child: Text(
                                  experience["description"] ?? "Experience description will be displayed here. This section provides detailed information about the role, responsibilities, and achievements.",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.85),
                                    height: 1.7,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
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

  // Navigation Button with Enhanced Design
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
              0
          ),
          child: Container(
            width: 65,
            height: 65,
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
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ] : null,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
                size: 22,
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
          height: 400,
          child: PageView.builder(
            itemCount: widget.experiences.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildExperienceCard(widget.experiences[index], false, index),
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
            children: List.generate(widget.experiences.length, (index) {
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
    if (widget.experiences.isEmpty) {
      return _buildGlassMorphicCard(
        height: 350,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_off,
                color: Colors.white.withOpacity(0.5),
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                "No Experience Available",
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

        // Desktop view: Show 3 experiences in a row
        int endIndex = (currentStartIndex + 3).clamp(0, widget.experiences.length);
        List<dynamic> visibleExperiences = widget.experiences.sublist(currentStartIndex, endIndex);

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

                SizedBox(width: 20),

                // 3 experience slots
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleExperiences.length) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildExperienceCard(
                                visibleExperiences[slotIndex],
                                true,
                                slotIndex
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

                SizedBox(width: 20),

                // Next button
                _buildNavButton(
                  icon: Icons.arrow_forward_ios,
                  isEnabled: currentStartIndex + 3 < widget.experiences.length,
                  onPressed: currentStartIndex + 3 < widget.experiences.length ? _showNext : null,
                ),
              ],
            ),

            SizedBox(height: 30),

            // Experience counter indicator
            _buildGlassMorphicCard(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "${currentStartIndex + 1}-${endIndex} of ${widget.experiences.length} Experiences",
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