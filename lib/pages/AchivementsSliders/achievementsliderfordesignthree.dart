import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementSliderForDesignThree extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementSliderForDesignThree({super.key, required this.achievements});

  @override
  _AchievementSliderForDesignThreeState createState() => _AchievementSliderForDesignThreeState();
}

class _AchievementSliderForDesignThreeState extends State<AchievementSliderForDesignThree>
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
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
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
      currentStartIndex = (currentStartIndex - 3).clamp(0, widget.achievements.length - 1);
    });
  }

  void _showNext() {
    setState(() {
      if (currentStartIndex + 3 < widget.achievements.length) {
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
            color: Color(0xFF1DD1A1).withValues(alpha: 0.1),
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

  // Animated achievement card with floating effect
  Widget _buildAnimatedAchievementCard(Map<String, dynamic> achievement, bool isDesktop, int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 150)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildAchievementCard(achievement, isDesktop),
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

        // Ensure we always show exactly 3 achievement slots for consistent layout
        int endIndex = (currentStartIndex + 3).clamp(0, widget.achievements.length);
        List<Map<String, dynamic>> visibleAchievements = widget.achievements.sublist(currentStartIndex, endIndex);

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
                
                // Exactly 3 achievement slots container
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleAchievements.length) {
                        // Display actual achievement
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildAnimatedAchievementCard(
                              visibleAchievements[slotIndex], 
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
                    onPressed: currentStartIndex + 3 < widget.achievements.length ? _showNext : null,
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
          height: 500,
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
                child: _buildAnimatedAchievementCard(widget.achievements[index], false, index),
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
            children: List.generate(widget.achievements.length, (index) {
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
                          colors: [Color(0xFF1DD1A1), Color(0xFFFECA57)],
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

  Widget _buildAchievementCard(Map<String, dynamic> achievement, bool isDesktop) {
    return _buildGlassMorphismContainer(
      height: isDesktop ? 450 : 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Achievement image with trophy icon overlay
          if (achievement["image"] != null && achievement["image"].toString().isNotEmpty)
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: _buildGlassMorphismContainer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    achievement["image"],
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1DD1A1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "Close",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1DD1A1).withValues(alpha: 0.1),
                            Color(0xFFFECA57).withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          achievement["image"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => SizedBox(
                            height: 160,
                            child: Icon(
                              Icons.emoji_events_outlined,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Trophy icon overlay
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFECA57), Color(0xFFFF6B6B)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFECA57).withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),

          // Achievement title with gradient text
          Text(
            achievement["title"] ?? "No Title",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.white, Color(0xFF1DD1A1)],
                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),

          SizedBox(height: 12),

          // Achievement description
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                child: Text(
                  achievement["description"] ?? "No Description",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Achievement badge/category chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1DD1A1).withValues(alpha: 0.3),
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
                  Icons.star,
                  color: Color(0xFFFECA57),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  "Achievement",
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
    );
  }
}
