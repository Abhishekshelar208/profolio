import 'dart:ui';
import 'dart:math' show cos, sin;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/ConnectwithMe/ConnectWithMeDesignFour.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/AchivementsSliders/AchievementSliderForDesignFour.dart';
import '../pages/ConnectwithMe/connectwithmefordesignthree.dart';
import '../pages/ExperienceSliders/ExperienceSectionForDesignFour.dart';
import '../pages/ProjectSliders/ProjectSliderForDesignFour.dart';
import '../pages/fullscreenimageview.dart';
import '../pages/marqueechips.dart';

class DesignFour extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DesignFour({super.key, required this.userData});

  @override
  _DesignFourState createState() => _DesignFourState();
}

class _DesignFourState extends State<DesignFour> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(_rotateController);

    _fadeController.forward();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    _rotateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Floating Particles Background
  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: Stack(
        children: List.generate(15, (index) {
          return AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, child) {
              double top = (index * 80.0) % MediaQuery.of(context).size.height;
              double left = (index * 120.0) % MediaQuery.of(context).size.width;

              return Positioned(
                top: top + (_floatAnimation.value * (index % 3)),
                left: left,
                child: Transform.rotate(
                  angle: _rotateAnimation.value + (index * 0.5),
                  child: Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899),
                      ][index % 3].withOpacity(0.3),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Modern Glassmorphic Container
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

  // Hero Section with new layout
  Widget _buildHeroSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          // Profile Image with enhanced design
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Container(
                  width: isMobile ? 180 : 250,
                  height: isMobile ? 180 : 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899),
                        Color(0xFFF59E0B),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.4),
                        spreadRadius: 0,
                        blurRadius: 50,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.userData["personalInfo"]["profilePicture"].isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => FullScreenImageView(
                            imageUrl: widget.userData["personalInfo"]["profilePicture"],
                          ),
                        );
                      }
                    },
                    child: ClipOval(
                      child: Image.network(
                        widget.userData["personalInfo"]["profilePicture"],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 40),

          // Name with animated gradient
          FadeTransition(
            opacity: _fadeAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                widget.userData["personalInfo"]["fullName"],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 42 : 64,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Subtitle with typing effect simulation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6366F1).withOpacity(0.2),
                    Color(0xFF8B5CF6).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                "Creative Developer & Digital Innovator",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          SizedBox(height: 50),

          // Quick stats in a row
          _buildQuickStats(),
        ],
      ),
    );
  }

  // Quick stats section
  Widget _buildQuickStats() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickStatItem("${widget.userData["MonthsofExperience"]}+", "Experience", Color(0xFF6366F1)),
        _buildQuickStatItem("${widget.userData["InternshipsCompleted"]}+", "Internships", Color(0xFF6366F1)),
        _buildQuickStatItem("${widget.userData["NoofProjectsCompleted"]}+", "Projects", Color(0xFF8B5CF6)),
        _buildQuickStatItem("${widget.userData["NoofSKills"]}+", "Skills", Color(0xFFEC4899)),
      ],
    );
  }

  Widget _buildQuickStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.6)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // About section with new design
  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          _buildSectionTitle("ABOUT", "Who I Am"),
          SizedBox(height: 40),

          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 768;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildAboutContent(),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: _buildResumeCard(),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildAboutContent(),
                    SizedBox(height: 30),
                    _buildResumeCard(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutContent() {
    return _buildGlassMorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(width: 16),
              Text(
                "My Story",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            widget.userData["personalInfo"]["aboutyourself"] ??
                "Passionate about creating amazing digital experiences with modern technologies. I believe in the power of clean code, beautiful design, and innovative solutions that make a difference.",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard() {
    return _buildGlassMorphicCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Resume",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Download my detailed resume to know more about my experience",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6366F1).withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                final String resumeUrl = widget.userData["resumefile"] ?? "";
                if (resumeUrl.isNotEmpty) {
                  Uri uri = Uri.parse(resumeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              icon: Icon(Icons.download, color: Colors.white, size: 18),
              label: Text(
                "Download",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Skills section with innovative design
  Widget _buildSkillsSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          _buildSectionTitle("SKILLS", "What I Work With"),
          SizedBox(height: 40),

          // Skills Grid with Hexagonal Design
          _buildGlassMorphicCard(
            child: Column(
              children: [
                // Skills Header with animated icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rotateController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value * 0.5,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.code,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Technology Expertise",
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Hexagonal Skills Grid
                _buildHexagonalSkillsGrid(),

                SizedBox(height: 40),

                // Animated Progress Bars for Top Skills
                _buildSkillProgressBars(),

                SizedBox(height: 30),

                // Floating Skills Orbs
                Container(
                  height: 120,
                  child: _buildFloatingSkillsOrbs(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hexagonal Skills Grid
  Widget _buildHexagonalSkillsGrid() {
    List<dynamic> skills = widget.userData["skills"] as List<dynamic>;
    bool isMobile = MediaQuery.of(context).size.width < 768;

    // Take first 7 skills for hexagonal display (center + 6 around)
    List<String> displaySkills = skills.take(7).map((s) => s.toString()).toList();

    return Container(
      height: isMobile ? 200 : 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center hexagon (main skill)
          if (displaySkills.isNotEmpty)
            _buildHexagonSkill(
              displaySkills[0],
              0, 0,
              isCenter: true,
              size: isMobile ? 70 : 80,
            ),

          // Surrounding hexagons
          for (int i = 1; i < displaySkills.length; i++)
            _buildHexagonSkill(
              displaySkills[i],
              _getHexagonPosition(i - 1, isMobile).$1,
              _getHexagonPosition(i - 1, isMobile).$2,
              size: isMobile ? 55 : 65,
            ),
        ],
      ),
    );
  }

  // Get hexagon positions around center
  (double, double) _getHexagonPosition(int index, bool isMobile) {
    double radius = isMobile ? 80 : 100;
    double angle = (index * 60) * (3.14159 / 180); // 60 degrees apart
    return (radius * cos(angle), radius * sin(angle));
  }

  // Individual hexagon skill
  Widget _buildHexagonSkill(String skill, double offsetX, double offsetY, {bool isCenter = false, double size = 60}) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              offsetX + (isCenter ? 0 : _floatAnimation.value * 0.5),
              offsetY + (isCenter ? _floatAnimation.value * 0.3 : 0)
          ),
          child: Container(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Hexagon background with gradient
                ClipPath(
                  clipper: HexagonClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isCenter ? [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ] : [
                          Color(0xFF6366F1).withOpacity(0.6),
                          Color(0xFF8B5CF6).withOpacity(0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6366F1).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Skill text
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    skill,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: isCenter ? 10 : 8,
                      fontWeight: isCenter ? FontWeight.bold : FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Skill Progress Bars for top skills
  Widget _buildSkillProgressBars() {
    List<dynamic> skills = widget.userData["skills"] as List<dynamic>;
    List<String> topSkills = skills.take(4).map((s) => s.toString()).toList();
    List<double> skillLevels = [0.95, 0.88, 0.92, 0.85]; // Mock skill levels

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Proficiency Levels",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),

        ...topSkills.asMap().entries.map((entry) {
          int index = entry.key;
          String skill = entry.value;
          double level = index < skillLevels.length ? skillLevels[index] : 0.8;

          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${(level * 100).toInt()}%",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Animated progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: level,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6366F1).withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Floating Skills Orbs
  Widget _buildFloatingSkillsOrbs() {
    List<dynamic> skills = widget.userData["skills"] as List<dynamic>;
    List<String> orbSkills = skills.skip(7).take(10).map((s) => s.toString()).toList();

    return Stack(
      children: orbSkills.asMap().entries.map((entry) {
        int index = entry.key;
        String skill = entry.value;

        return AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            double leftOffset = (index * 60.0) % (MediaQuery.of(context).size.width - 140);
            double topOffset = 20 + (_floatAnimation.value * (index % 2 == 0 ? 1 : -1));

            return Positioned(
              left: leftOffset,
              top: topOffset,
              child: Transform.rotate(
                angle: _rotateAnimation.value * (index % 2 == 0 ? 1 : -1) * 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6366F1).withOpacity(0.4),
                        Color(0xFF8B5CF6).withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String subtitle, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6366F1).withOpacity(0.2),
                Color(0xFF8B5CF6).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: MediaQuery.of(context).size.width < 600 ? 32 : 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.0,
            colors: [
              Color(0xFF1E1B4B),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles background
            _buildFloatingParticles(),

            // Main content
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(),

                    // About Section
                    _buildAboutSection(),

                    // Skills Section
                    _buildSkillsSection(),

                    // Projects Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          _buildSectionTitle("PORTFOLIO", "Featured Projects"),
                          SizedBox(height: 40),
                          ProjectSliderForDesignFour(projects: widget.userData["projects"]),
                        ],
                      ),
                    ),

                    // Experience Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          _buildSectionTitle("JOURNEY", "Professional Experience"),
                          SizedBox(height: 40),
                          ExperienceSectionForDesignFour(experiences: widget.userData["experiences"] as List<dynamic>),
                        ],
                      ),
                    ),

                    // Achievements Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          _buildSectionTitle("ACHIEVEMENTS", "Recognition & Awards"),
                          SizedBox(height: 40),
                          AchievementSliderForDesignFour(achievements: widget.userData["achievements"]),
                        ],
                      ),
                    ),

                    // Contact Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: ConnectWithMeDesignFour(userData: widget.userData),
                    ),

                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hexagon Clipper for hexagonal shapes
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    for (int i = 0; i < 6; i++) {
      final double angle = (i * 60) * (3.14159 / 180);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}