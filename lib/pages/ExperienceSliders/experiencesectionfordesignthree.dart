import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceSectionForDesignThree extends StatefulWidget {
  final List<dynamic> experiences;

  const ExperienceSectionForDesignThree({super.key, required this.experiences});

  @override
  _ExperienceSectionForDesignThreeState createState() => _ExperienceSectionForDesignThreeState();
}

class _ExperienceSectionForDesignThreeState extends State<ExperienceSectionForDesignThree>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  void _showPrevious() {
    setState(() {
      currentStartIndex = (currentStartIndex - 3).clamp(0, widget.experiences.length - 1);
    });
  }

  void _showNext() {
    setState(() {
      if (currentStartIndex + 3 < widget.experiences.length) {
        currentStartIndex += 3;
      }
    });
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
      padding: padding ?? EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B6B).withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: child,
        ),
      ),
    );
  }

  // Animated experience card with floating effect
  Widget _buildAnimatedExperienceCard(dynamic experience, bool isDesktop, int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 700 + (index * 200)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildExperienceCard(experience, isDesktop),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        if (!isDesktop) return _buildMobileView();

        // Ensure we always show exactly 3 experience slots for consistent layout
        int endIndex = (currentStartIndex + 3).clamp(0, widget.experiences.length);
        List<dynamic> visibleExperiences = widget.experiences.sublist(currentStartIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Previous button with glass effect
                _buildGlassMorphismContainer(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    onPressed: currentStartIndex > 0 ? _showPrevious : null,
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Exactly 3 experience slots container
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleExperiences.length) {
                        // Display actual experience
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildAnimatedExperienceCard(
                              visibleExperiences[slotIndex], 
                              true, 
                              slotIndex
                            ),
                          ),
                        );
                      } else {
                        // Empty placeholder to maintain 3-column layout
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(), // Empty space
                          ),
                        );
                      }
                    }),
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Next button with glass effect
                _buildGlassMorphismContainer(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    onPressed: currentStartIndex + 3 < widget.experiences.length ? _showNext : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 480,
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
                child: _buildAnimatedExperienceCard(widget.experiences[index], false, index),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        
        // Glass morphism page indicators
        _buildGlassMorphismContainer(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.experiences.length, (index) {
              bool isActive = index == currentStartIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFECA57)],
                        )
                      : null,
                  color: isActive ? null : Colors.white.withValues(alpha: 0.4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(dynamic experience, bool isDesktop) {
    return _buildGlassMorphismContainer(
      height: isDesktop ? 420 : 460,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Experience header with company icon
          Row(
            children: [
              // Company/Experience icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFECA57)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.work_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              SizedBox(width: 16),
              
              // Experience title
              Expanded(
                child: Text(
                  experience["title"] ?? "No Title",
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.white, Color(0xFFFF6B6B)],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Experience description
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                child: Text(
                  experience["description"] ?? "No Description",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Experience duration/period indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      Color(0xFFFECA57).withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Color(0xFFFECA57),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Experience",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
