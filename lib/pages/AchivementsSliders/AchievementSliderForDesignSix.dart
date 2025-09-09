import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementSliderForDesignSix extends StatefulWidget {
  final List<dynamic> achievements;

  const AchievementSliderForDesignSix({super.key, required this.achievements});

  @override
  State<AchievementSliderForDesignSix> createState() => _AchievementSliderForDesignSixState();
}

class _AchievementSliderForDesignSixState extends State<AchievementSliderForDesignSix>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  Timer? _autoScrollTimer;
  bool _isHovering = false;
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  
  // Dark Purple Theme Palette (matching DesignSix)
  static const Color darkPrimary = Color(0xFF2D1B69);
  static const Color purpleMid = Color(0xFF6366F1);
  static const Color purpleLight = Color(0xFF8B5CF6);
  static const Color purpleAccent = Color(0xFFA855F7);
  static const Color darkBg = Color(0xFF0F0C29);
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textGray = Color(0xFFCBD5E1);
  static const Color accentGlow = Color(0xFF00D4FF);
  
  // Achievement badge colors
  static const List<Color> badgeColors = [
    Colors.amber,
    Colors.orange,
    purpleAccent,
    accentGlow,
    Colors.green,
    Colors.red,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAutoScroll();
  }
  
  void _initializeAnimations() {
    _scrollController = ScrollController();
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
        _pulseController.repeat(reverse: true);
      }
    });
  }
  
  void _initializeAutoScroll() {
    if (widget.achievements.length > 3) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!_isHovering && _scrollController.hasClients) {
          double maxScroll = _scrollController.position.maxScrollExtent;
          double currentScroll = _scrollController.offset;
          double scrollIncrement = 150.0; // Approximate width of one achievement card
          
          if (currentScroll >= maxScroll) {
            // Reset to beginning
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          } else {
            // Scroll to next achievement
            _scrollController.animateTo(
              math.min(currentScroll + scrollIncrement, maxScroll),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }
  
  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  // Glassmorphism card component
  Widget _buildGlassmorphicCard({
    required Widget child,
    EdgeInsets? padding,
    double? blur,
    Color? backgroundColor,
    double borderRadius = 16,
    double? elevation,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: elevation != null
            ? [
                BoxShadow(
                  color: purpleAccent.withOpacity(0.3),
                  blurRadius: elevation * 8,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur ?? 8, sigmaY: blur ?? 8),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor ?? glassOverlay,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.achievements.isEmpty) {
      return _buildEmptyState();
    }
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Container(
            height: 200,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.achievements.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _buildAchievementCard(widget.achievements[index], index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAchievementCard(Map<String, dynamic> achievement, int index) {
    Color badgeColor = badgeColors[index % badgeColors.length];
    bool isHovered = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.elasticOut,
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: animationValue,
              child: MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..translate(0.0, isHovered ? -5.0 : 0.0),
                  child: _buildGlassmorphicCard(
                    elevation: isHovered ? 6.0 : 2.0,
                    backgroundColor: cardBg.withOpacity(0.4),
                    child: Container(
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Achievement badge/icon
                          _buildAchievementBadge(achievement, badgeColor, index),
                          
                          const SizedBox(height: 12),
                          
                          // Achievement title
                          Text(
                            achievement["title"]?.toString() ?? "Achievement",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textLight,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Achievement description
                          Text(
                            achievement["description"]?.toString() ?? "Recognition for excellence",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: textGray,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Achievement date/year
                          _buildAchievementDate(achievement, badgeColor),
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
  
  Widget _buildAchievementBadge(Map<String, dynamic> achievement, Color badgeColor, int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  badgeColor,
                  badgeColor.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main badge icon
                Center(
                  child: Icon(
                    _getAchievementIcon(index),
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                
                // Sparkle effect
                if (index % 2 == 0) _buildSparkleEffect(badgeColor),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSparkleEffect(Color badgeColor) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 5,
              right: 8,
              child: Transform.rotate(
                angle: _pulseController.value * 2 * math.pi,
                child: Icon(
                  Icons.star,
                  size: 8,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 10,
              child: Transform.rotate(
                angle: -_pulseController.value * 2 * math.pi,
                child: Icon(
                  Icons.star,
                  size: 6,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildAchievementDate(Map<String, dynamic> achievement, Color badgeColor) {
    String date = achievement["dateAwarded"]?.toString() ?? 
                  achievement["year"]?.toString() ?? 
                  DateTime.now().year.toString();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        date,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }
  
  IconData _getAchievementIcon(int index) {
    List<IconData> icons = [
      Icons.emoji_events,      // Trophy
      Icons.star,              // Star
      Icons.workspace_premium, // Premium
      Icons.school,            // Education
      Icons.code,              // Code
      Icons.design_services,   // Design
      Icons.groups,            // Team
      Icons.thumb_up,          // Thumbs up
    ];
    
    return icons[index % icons.length];
  }
  
  Widget _buildEmptyState() {
    return _buildGlassmorphicCard(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          purpleAccent.withOpacity(0.3),
                          purpleAccent.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 40,
                      color: purpleAccent,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'No Achievements Available',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Achievements will appear here',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: textGray.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
