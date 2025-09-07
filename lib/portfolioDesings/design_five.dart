import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/AchivementsSliders/achievementsliderfordesigntwo.dart';
import '../pages/ConnectwithMe/connectwithmefordesigntwo.dart';
import '../pages/ExperienceSliders/experiencesliderfordesigntwo.dart';
import '../pages/fullscreenimageview.dart';
import '../pages/marqueechips.dart';
import '../pages/ProjectSliders/projectsliderfordesigntwo.dart';

class DesignFive extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DesignFive({super.key, required this.userData});

  @override
  _DesignFiveState createState() => _DesignFiveState();
}

class _DesignFiveState extends State<DesignFive> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _cardAnimationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _cardOpacityAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Floating animation for profile image
    _floatingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Card animations
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );


    _cardOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeIn),
    );

    _cardAnimationController.forward();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _cardAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  // Glassmorphism Container
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
            Colors.white.withAlpha(51),
            Colors.white.withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(77),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  // Animated Stats Card
  Widget _buildAnimatedStatCard(String title, String value, Color accentColor, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (delay * 200)),
      curve: Curves.bounceOut,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: _buildGlassMorphismContainer(
            width: MediaQuery.of(context).size.width < 600 ? 140 : 180,
            height: MediaQuery.of(context).size.width < 600 ? 120 : 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withAlpha(128)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.white, accentColor],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
                    color: Colors.white.withAlpha(204),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Stats Section
  Widget _buildStatsSection() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildAnimatedStatCard(
          "Months of Experience",
          "${widget.userData["MonthsofExperience"]}+",
          Color(0xFF6C63FF),
          0,
        ),
        _buildAnimatedStatCard(
          "Internships Completed",
          "${widget.userData["InternshipsCompleted"]}+",
          Color(0xFF1DD1A1),
          1,
        ),
        _buildAnimatedStatCard(
          "Projects Completed",
          "${widget.userData["NoofProjectsCompleted"]}+",
          Color(0xFFFF6B6B),
          2,
        ),
        _buildAnimatedStatCard(
          "Number of Skills",
          "${widget.userData["NoofSKills"]}+",
          Color(0xFFFECA57),
          3,
        ),
      ],
    );
  }

  // Floating Profile Image
  Widget _buildFloatingProfileImage() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C63FF).withAlpha(204),
                  Color(0xFF1DD1A1).withAlpha(204),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6C63FF).withAlpha(77),
                  spreadRadius: 5,
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            padding: EdgeInsets.all(6),
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
                  width: MediaQuery.of(context).size.width < 600 ? 180 : 280,
                  height: MediaQuery.of(context).size.width < 600 ? 180 : 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: MediaQuery.of(context).size.width < 600 ? 180 : 280,
                      height: MediaQuery.of(context).size.width < 600 ? 180 : 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF1DD1A1)],
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
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6C63FF).withAlpha(51),
                Color(0xFF1DD1A1).withAlpha(51),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withAlpha(77),
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withAlpha(230),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20),
        GradientText(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 42,
            fontWeight: FontWeight.bold,
          ),
          colors: [
            Colors.white,
            Color(0xFF6C63FF),
            Color(0xFF1DD1A1),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C1810),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  
                  // Greeting Section
                  AnimatedBuilder(
                    animation: _cardOpacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _cardOpacityAnimation.value,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withAlpha(26),
                                Colors.white.withAlpha(13),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withAlpha(51),
                            ),
                          ),
                          child: Text(
                            "👋 Hey there! I'm ${widget.userData["personalInfo"]["fullName"].toString().split(" ").first}",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white.withAlpha(230),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Main Hero Section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        // Desktop layout
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Image
                            Expanded(
                              flex: 2,
                              child: Center(child: _buildFloatingProfileImage()),
                            ),
                            SizedBox(width: 60),
                            // Text Content
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GradientText(
                                    "Creative Developer &\nDigital Innovator",
                                    style: GoogleFonts.poppins(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                    colors: [
                                      Colors.white,
                                      Color(0xFF6C63FF),
                                      Color(0xFF1DD1A1),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  _buildGlassMorphismContainer(
                                    child: Text(
                                      widget.userData["personalInfo"]["aboutyourself"] ?? "Passionate about creating amazing digital experiences",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.white.withAlpha(204),
                                        fontWeight: FontWeight.w300,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  // Resume Button
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF6C63FF), Color(0xFF1DD1A1)],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF6C63FF).withAlpha(102),
                                          spreadRadius: 2,
                                          blurRadius: 20,
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
                                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      icon: Icon(Icons.download, color: Colors.white, size: 22),
                                      label: Text(
                                        "Download Resume",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Mobile layout
                        return Column(
                          children: [
                            _buildFloatingProfileImage(),
                            SizedBox(height: 40),
                            GradientText(
                              "Creative Developer &\nDigital Innovator",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              colors: [
                                Colors.white,
                                Color(0xFF6C63FF),
                                Color(0xFF1DD1A1),
                              ],
                            ),
                            SizedBox(height: 30),
                            _buildGlassMorphismContainer(
                              child: Text(
                                widget.userData["personalInfo"]["aboutyourself"] ?? "Passionate about creating amazing digital experiences",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white.withAlpha(204),
                                  fontWeight: FontWeight.w300,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            // Resume Button
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF1DD1A1)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF6C63FF).withAlpha(102),
                                    spreadRadius: 2,
                                    blurRadius: 20,
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
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                icon: Icon(Icons.download, color: Colors.white, size: 22),
                                label: Text(
                                  "Download Resume",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  
                  SizedBox(height: 80),
                  
                  // Stats Section
                  _buildSectionHeader("Statistics", "My Journey So Far"),
                  _buildStatsSection(),
                  
                  SizedBox(height: 80),
                  
                  // Skills Section
                  _buildSectionHeader("Skills", "What I Work With"),
                  _buildGlassMorphismContainer(
                    child: SizedBox(
                      height: 60,
                      child: MarqueeChips(
                        velocity: 30.0,
                        chips: (widget.userData["skills"] as List<dynamic>).map<Widget>((skill) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF6C63FF).withAlpha(77),
                                  Color(0xFF1DD1A1).withAlpha(77),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(77),
                              ),
                            ),
                            child: Text(
                              skill.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 80),
                  
                  // Projects Section
                  _buildSectionHeader("Portfolio", "Featured Projects"),
                  ProjectSliderForDesignTwo(projects: widget.userData["projects"]),
                  
                  SizedBox(height: 80),
                  
                  // Achievements Section
                  _buildSectionHeader("Recognition", "My Achievements"),
                  AchievementSliderForDesignTwo(achievements: widget.userData["achievements"]),
                  
                  SizedBox(height: 80),
                  
                  // Experience Section
                  _buildSectionHeader("Journey", "My Experience"),
                  ExperienceSectionForDesignTwo(experiences: widget.userData["experiences"] as List<dynamic>),
                  
                  SizedBox(height: 80),
                  
                  // Connect Section
                  ConnectWithMedesignTwo(userData: widget.userData),
                  
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
