import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/AchivementsSliders/AchievementSliderForDesignSix.dart';
import '../pages/ConnectwithMe/ConnectWithMeDesignSix.dart';
import '../pages/ExperienceSliders/ExperienceSectionForDesignSix.dart';
import '../pages/ProjectSliders/ProjectSliderForDesignSix.dart';
import '../pages/fullscreenimageview.dart';

/// Modern Dark Portfolio Design - Design Six
/// Features: Dark purple theme, animated elements, glassmorphism effects
class DesignSix extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DesignSix({super.key, required this.userData});

  @override
  State<DesignSix> createState() => _DesignSixState();
}

class _DesignSixState extends State<DesignSix> with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  late ScrollController _scrollController;

  // Dark Purple Theme Palette
  static const Color darkPrimary = Color(0xFF2D1B69);
  static const Color purpleMid = Color(0xFF6366F1);
  static const Color purpleAccent = Color(0xFFA855F7);
  static const Color darkBg = Color(0xFF0F0C29);
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textGray = Color(0xFFCBD5E1);
  static const Color accentGlow = Color(0xFF00D4FF);

  // Interaction states
  int _selectedNavIndex = 0;

  // Keys for scrolling to sections
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _achievementsKey = GlobalKey();
  final GlobalKey _connectKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Fade animation for smooth entrances
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Slide animation for elements
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Floating animation for character
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for background elements
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    // Pulse animation for glowing elements
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scrollController = ScrollController();

    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
        _floatingController.repeat(reverse: true);
        _rotationController.repeat();
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ═══════════════════ GLASSMORPHISM CARD COMPONENT ═══════════════════
  Widget _buildGlassmorphicCard({
    required Widget child,
    EdgeInsets? padding,
    double? blur,
    Color? backgroundColor,
    double borderRadius = 20,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur ?? 10, sigmaY: blur ?? 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
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

  // ═══════════════════ ANIMATED TOP NAVIGATION ═══════════════════
  Widget _buildTopNavigation() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo - Updated to Portfolio
              _buildGlassmorphicCard(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: 12
                ),
                child: Text(
                  'Portfolio',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: textLight,
                  ),
                ),
              ),

              // Desktop Navigation Links
              if (!isMobile)
                _buildGlassmorphicCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildNavLink('Home', 0),
                      const SizedBox(width: 20),
                      _buildNavLink('Skills', 1),
                      const SizedBox(width: 20),
                      _buildNavLink('Experience', 2),
                      const SizedBox(width: 20),
                      _buildNavLink('Projects', 3),
                      const SizedBox(width: 20),
                      _buildNavLink('Achievements', 4),
                      const SizedBox(width: 20),
                      _buildNavLink('Connect', 5),
                    ],
                  ),
                ),

              // Mobile Hamburger Menu
              if (isMobile)
                _buildGlassmorphicCard(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => _showMobileMenu(context),
                    child: Icon(
                      Icons.menu,
                      color: textLight,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════ MOBILE MENU DRAWER ═══════════════════
  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMobileMenuDrawer(),
    );
  }

  Widget _buildMobileMenuDrawer() {
    return Container(
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: glassOverlay,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 30),

                // Navigation Items
                _buildMobileNavItem('Home', Icons.home_outlined, 0),
                _buildMobileNavItem('Skills', Icons.code_outlined, 1),
                _buildMobileNavItem('Experience', Icons.work_outline, 2),
                _buildMobileNavItem('Projects', Icons.folder_outlined, 3),
                _buildMobileNavItem('Achievements', Icons.emoji_events_outlined, 4),
                _buildMobileNavItem('Connect', Icons.connect_without_contact_outlined, 5),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(String title, IconData icon, int index) {
    bool isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close drawer
        _scrollToSection(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? purpleAccent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? purpleAccent.withValues(alpha: 0.3) : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: purpleAccent.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? purpleAccent.withValues(alpha: 0.2) : cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? purpleAccent : textGray.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? purpleAccent : textLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? textLight : textGray,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: purpleAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String text, int index) {
    bool isSelected = _selectedNavIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _scrollToSection(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? purpleAccent.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? purpleAccent : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? textLight : textGray,
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    setState(() => _selectedNavIndex = index);

    GlobalKey? targetKey;
    switch (index) {
      case 0: // Home
        targetKey = _heroKey;
        break;
      case 1: // Skills
        targetKey = _skillsKey;
        break;
      case 2: // Experience
        targetKey = _experienceKey;
        break;
      case 3: // Projects
        targetKey = _projectsKey;
        break;
      case 4: // Achievements
        targetKey = _achievementsKey;
        break;
      case 5: // Connect
        targetKey = _connectKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  // ═══════════════════ ANIMATED HERO SECTION ═══════════════════
  Widget _buildHeroSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      key: _heroKey,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Top Navigation
          _buildTopNavigation(),

          // Main Content
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Character - Increased size
                  _buildAnimatedCharacter(isMobile),

                  const SizedBox(height: 40),

                  // Clean and Simple Title Section
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'An Engineering Student who',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 28 : 36,
                              fontWeight: FontWeight.w300,
                              color: textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Builds solutions\nwith ',
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 32 : 48,
                                    fontWeight: FontWeight.w700,
                                    color: textLight,
                                  ),
                                ),
                                TextSpan(
                                  text: 'passion',
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 32 : 48,
                                    fontWeight: FontWeight.w700,
                                    color: purpleAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: '...',
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 32 : 48,
                                    fontWeight: FontWeight.w700,
                                    color: textLight,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Because innovation starts with curiosity and dedication to learn.',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.w300,
                              color: textGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                darkPrimary,
                darkBg,
                Color(0xFF0A0A1A),
              ],
            ),
          ),
        ),

        // Animated Circles
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  top: 100,
                  right: 100,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            purpleAccent.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150,
                  left: 50,
                  child: Transform.rotate(
                    angle: -_rotationAnimation.value * 0.7,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accentGlow.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Updated Animated Character with increased size
  Widget _buildAnimatedCharacter(bool isMobile) {
    double containerSize = isMobile ? 240 : 300; // Increased from 200
    double imageSize = isMobile ? 150 : 200; // Increased from 120

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  purpleAccent.withOpacity(0.3),
                  purpleMid.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardBg,
                ),
                child: ClipOval(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.userData["personalInfo"]["profilePicture"]?.isNotEmpty == true) {
                        showDialog(
                          context: context,
                          builder: (context) => FullScreenImageView(
                            imageUrl: widget.userData["personalInfo"]["profilePicture"],
                          ),
                        );
                      }
                    },
                    child: Image.network(
                      widget.userData["personalInfo"]["profilePicture"] ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [purpleMid, purpleAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: isMobile ? 75 : 100, // Increased icon size
                            color: textLight,
                          ),
                        );
                      },
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

  // Updated Professional Info
  Widget _buildProfessionalInfo(bool isMobile) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildGlassmorphicCard(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Text(
                "I'm an Engineering Student |",
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.w600,
                  color: textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Currently pursuing my degree in ',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w400,
                        color: textGray,
                      ),
                    ),
                    TextSpan(
                      text: 'Engineering',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: accentGlow,
                      ),
                    ),
                    TextSpan(
                      text: ',',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w400,
                        color: textGray,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.userData["personalInfo"]["aboutyourself"] ??
                    "A passionate engineering student focused on learning cutting-edge technologies.\n"
                        "I enjoy building projects that solve real-world problems and contribute to meaningful\n"
                        "innovations that make a positive impact.",
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w300,
                  color: textGray,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════ SKILLS SECTION WITH ANIMATED ICONS ═══════════════════
  Widget _buildSkillsSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      key: _skillsKey,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader("various technologies", "and joining collaborative"),
          const SizedBox(height: 20),
          Text(
            'teams that value learning and innovation through practical application',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w300,
              color: textGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          _buildTechIconsGrid(isMobile),
        ],
      ),
    );
  }

  // Updated to use database skills
  Widget _buildTechIconsGrid(bool isMobile) {
    List<dynamic> userSkills = widget.userData["skills"] ?? [];

    // Convert to list of strings and create color map
    List<String> skillsList = userSkills.map((skill) => skill.toString()).toList();

    // Define color palette for skills
    List<Color> colorPalette = [
      purpleAccent,
      accentGlow,
      Colors.orange,
      Colors.green,
      Colors.yellow,
      Colors.red,
      purpleMid,
      Colors.blue,
      Colors.pink,
      Colors.teal,
    ];

    // Create skills with colors
    List<Map<String, dynamic>> techIcons = skillsList.asMap().entries.map((entry) {
      int index = entry.key;
      String skill = entry.value;
      return {
        'name': skill,
        'color': colorPalette[index % colorPalette.length],
      };
    }).toList();

    int crossAxisCount = isMobile ? 3 : 5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: isMobile ? 1.2 : 1,
      ),
      itemCount: techIcons.length,
      itemBuilder: (context, index) {
        return _buildAnimatedTechIcon(techIcons[index], index);
      },
    );
  }

  Widget _buildAnimatedTechIcon(Map<String, dynamic> tech, int index) {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 100)),
      curve: Curves.elasticOut,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() {}), // Trigger rebuild for hover effect
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, math.sin(index * 0.5 + _floatingController.value * 2 * math.pi) * 5),
                  child: _buildGlassmorphicCard(
                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                    borderRadius: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            tech['color'].withOpacity(0.15),
                            tech['color'].withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: tech['color'].withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: tech['color'].withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Background pattern/decoration
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: tech['color'].withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            left: -5,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: tech['color'].withOpacity(0.08),
                              ),
                            ),
                          ),

                          // Main content
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon representation
                                Container(
                                  width: isMobile ? 24 : 32,
                                  height: isMobile ? 24 : 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tech['color'].withOpacity(0.2),
                                    border: Border.all(
                                      color: tech['color'].withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    _getSkillIcon(tech['name']),
                                    size: isMobile ? 12 : 16,
                                    color: tech['color'],
                                  ),
                                ),
                                SizedBox(height: isMobile ? 6 : 8),

                                // Skill name
                                Text(
                                  tech['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 10 : 14,
                                    fontWeight: FontWeight.w700,
                                    color: tech['color'],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Subtitle/category
                                SizedBox(height: isMobile ? 2 : 4),
                                Text(
                                  _getSkillCategory(tech['name']),
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 8 : 10,
                                    fontWeight: FontWeight.w400,
                                    color: textGray.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          // Animated pulse effect
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: tech['color'].withOpacity(_pulseAnimation.value * 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

// Helper function to get appropriate icon for each skill
  IconData _getSkillIcon(String skillName) {
    String skill = skillName.toLowerCase();

    // Programming Languages
    if (skill.contains('dart') || skill.contains('flutter')) return Icons.flutter_dash;
    if (skill.contains('java')) return Icons.coffee;
    if (skill.contains('python')) return Icons.psychology;
    if (skill.contains('javascript') || skill.contains('js')) return Icons.code;
    if (skill.contains('html')) return Icons.web;
    if (skill.contains('css')) return Icons.palette;
    if (skill.contains('react')) return Icons.account_tree;
    if (skill.contains('node')) return Icons.dns;
    if (skill.contains('php')) return Icons.code;
    if (skill.contains('swift')) return Icons.phone_iphone;
    if (skill.contains('kotlin')) return Icons.android;

    // Databases
    if (skill.contains('mongodb') || skill.contains('database') || skill.contains('sql')) return Icons.storage;
    if (skill.contains('firebase')) return Icons.local_fire_department;

    // Tools & Platforms
    if (skill.contains('git')) return Icons.source;
    if (skill.contains('docker')) return Icons.widgets;
    if (skill.contains('aws') || skill.contains('cloud')) return Icons.cloud;
    if (skill.contains('figma') || skill.contains('design')) return Icons.design_services;
    if (skill.contains('photoshop')) return Icons.photo;

    // AI/ML
    if (skill.contains('ai') || skill.contains('machine learning') || skill.contains('ml')) return Icons.smart_toy;
    if (skill.contains('tensorflow') || skill.contains('pytorch')) return Icons.psychology;

    // Default icon
    return Icons.computer;
  }

// Helper function to categorize skills
  String _getSkillCategory(String skillName) {
    String skill = skillName.toLowerCase();

    if (skill.contains('dart') || skill.contains('flutter') || skill.contains('java') ||
        skill.contains('python') || skill.contains('javascript') || skill.contains('swift') ||
        skill.contains('kotlin') || skill.contains('php')) {
      return 'Language';
    }

    if (skill.contains('react') || skill.contains('angular') || skill.contains('vue') ||
        skill.contains('node') || skill.contains('express')) {
      return 'Framework';
    }

    if (skill.contains('mongodb') || skill.contains('sql') || skill.contains('firebase') ||
        skill.contains('database')) {
      return 'Database';
    }

    if (skill.contains('git') || skill.contains('docker') || skill.contains('aws') ||
        skill.contains('cloud')) {
      return 'Tool';
    }

    if (skill.contains('figma') || skill.contains('photoshop') || skill.contains('design')) {
      return 'Design';
    }

    if (skill.contains('ai') || skill.contains('ml') || skill.contains('machine learning') ||
        skill.contains('tensorflow') || skill.contains('pytorch')) {
      return 'AI/ML';
    }

    if (skill.contains('html') || skill.contains('css') || skill.contains('web')) {
      return 'Frontend';
    }

    return 'Tech';
  }

  // Updated Section Header
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'I\'m currently focused on developing expertise in ',
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 28,
                  fontWeight: FontWeight.w300,
                  color: textLight,
                ),
              ),
              TextSpan(
                text: title,
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 28,
                  fontWeight: FontWeight.w700,
                  color: purpleAccent,
                ),
              ),
              TextSpan(
                text: ' $subtitle',
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 28,
                  fontWeight: FontWeight.w300,
                  color: textLight,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(),

            // Skills Section
            _buildSkillsSection(),

            // Work Experience Section
            Container(
              key: _experienceKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Work Experience',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      color: textLight,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ExperienceSectionForDesignSix(
                    experiences: widget.userData["experiences"] as List<dynamic>? ?? [],
                  ),
                ],
              ),
            ),

            // Featured Projects Section
            Container(
              key: _projectsKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Featured Projects',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      color: textLight,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ProjectSliderForDesignSix(
                    projects: widget.userData["projects"] ?? [],
                  ),
                ],
              ),
            ),

            // Achievements Section
            Container(
              key: _achievementsKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Achievements',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      color: textLight,
                    ),
                  ),
                  const SizedBox(height: 50),
                  AchievementSliderForDesignSix(
                    achievements: widget.userData["achievements"] ?? [],
                  ),
                ],
              ),
            ),

            // Contact Section
            Container(
              key: _connectKey,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Connect With Me',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      color: textLight,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ConnectWithMeDesignSix(userData: widget.userData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}