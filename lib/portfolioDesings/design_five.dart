import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/AchivementsSliders/AchievementSliderForDesignFive.dart';
import 'package:profolio/pages/ConnectwithMe/ConnectWithMeDesignFive.dart';
import 'package:profolio/pages/ExperienceSliders/ExperienceSectionForDesignFive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/AchivementsSliders/AchievementSliderForDesignFour.dart';
import '../pages/ConnectwithMe/ConnectWithMeDesignFour.dart';
import '../pages/ExperienceSliders/ExperienceSectionForDesignFour.dart';
import '../pages/ProjectSliders/ProjectSliderForDesignFive.dart';
import '../pages/fullscreenimageview.dart';

/// Professional Elegant Portfolio Design - Design Five
/// Features: Clean aesthetics, subtle animations, professional layout
class DesignFive extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DesignFive({super.key, required this.userData});

  @override
  State<DesignFive> createState() => _DesignFiveState();
}

class _DesignFiveState extends State<DesignFive> with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  late ScrollController _scrollController;
  
  // Professional Color Palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color accentBlue = Color(0xFF1D4ED8);
  static const Color softGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color darkGray = Color(0xFF334155);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFFAFAFA);
  
  // Interaction states
  bool _isProfileHovered = false;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    // Fade animation for smooth entrances
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _scrollController = ScrollController();
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ═══════════════════ ELEGANT CARD COMPONENT ═══════════════════
  Widget _buildElegantCard({
    required Widget child,
    EdgeInsets? padding,
    double? elevation,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
          if (elevation != null)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: child,
    );
  }
  
  // ═══════════════════ PROFESSIONAL HERO SECTION ═══════════════════
  Widget _buildHeroSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: 20,
      ),
      child: Column(
        children: [
          // Professional Profile Image
          _buildProfileImage(),
          const SizedBox(height: 40),
          
          // Name and Title
          _buildNameAndTitle(),
          const SizedBox(height: 30),
          
          // Professional Description
          _buildDescription(),
          const SizedBox(height: 40),
          
          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 60),
          
          // Stats Overview
          _buildStatsOverview(),
        ],
      ),
    );
  }
  
  Widget _buildProfileImage() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isProfileHovered = true),
          onExit: (_) => setState(() => _isProfileHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(_isProfileHovered ? 0.2 : 0.1),
                  spreadRadius: _isProfileHovered ? 8 : 4,
                  blurRadius: _isProfileHovered ? 20 : 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryBlue.withOpacity(0.1),
                  width: 3,
                ),
              ),
              child: ClipOval(
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
                  child: Image.network(
                    widget.userData["personalInfo"]["profilePicture"],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [lightBlue, primaryBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
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
          ),
        ),
      ),
    );
  }
  
  Widget _buildNameAndTitle() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Name
            Text(
              widget.userData["personalInfo"]["fullName"],
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.w700,
                color: darkGray,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            
            // Professional Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: lightBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                "Professional Developer & Designer",
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDescription() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            widget.userData["personalInfo"]["aboutyourself"] ??
                "Passionate about creating exceptional digital experiences with clean, "
                "efficient code and thoughtful design. Committed to delivering "
                "high-quality solutions that make a meaningful impact.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: softGray,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Resume Button
            _buildPrimaryButton(
              "Download Resume",
              Icons.download_outlined,
              () async {
                final String resumeUrl = widget.userData["resumefile"] ?? "";
                if (resumeUrl.isNotEmpty) {
                  Uri uri = Uri.parse(resumeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
            ),
            const SizedBox(width: 16),
            
            // Contact Button
            _buildSecondaryButton(
              "Contact Me",
              Icons.mail_outline,
              () {
                // Scroll to contact section
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrimaryButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildSecondaryButton(String text, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: BorderSide(color: primaryBlue.withOpacity(0.3)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                "Experience",
                "${widget.userData["MonthsofExperience"]}+ Months",
                Icons.timeline_outlined,
                primaryBlue,
              ),
              _buildStatCard(
                "Projects",
                "${widget.userData["NoofProjectsCompleted"]}+ Completed",
                Icons.code_outlined,
                lightBlue,
              ),
              _buildStatCard(
                "Skills",
                "${widget.userData["NoofSKills"]}+ Technologies",
                Icons.psychology_outlined,
                accentBlue,
              ),
              if (!isMobile)
                _buildStatCard(
                  "Internships",
                  "${widget.userData["InternshipsCompleted"]}+ Completed",
                  Icons.school_outlined,
                  softGray,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value.split('+').first,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: darkGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: softGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // ═══════════════════ ABOUT SECTION ═══════════════════
  Widget _buildAboutSection() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          _buildSectionHeader("About", "Learn More About Me"),
          const SizedBox(height: 50),
          
          _buildElegantCard(
            elevation: 1,
            child: isMobile ? _buildAboutMobileLayout() : _buildAboutDesktopLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Content
        Expanded(
          flex: 2,
          child: _buildAboutContent(),
        ),
        const SizedBox(width: 40),
        
        // Quick Info
        Expanded(
          flex: 1,
          child: _buildResumeSection(),
        ),
      ],
    );
  }

  Widget _buildAboutMobileLayout() {
    return Column(
      children: [
        _buildAboutContent(),
        const SizedBox(height: 30),
        _buildResumeSection(),
      ],
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "Professional Background",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: darkGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Text(
          widget.userData["personalInfo"]["aboutyourself"] ??
              "I am a dedicated professional with expertise in modern development "
              "practices and a passion for creating innovative solutions. My approach "
              "combines technical excellence with creative problem-solving to deliver "
              "exceptional results that exceed expectations.",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: softGray,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.file_download_outlined,
            size: 32,
            color: primaryBlue,
          ),
          const SizedBox(height: 12),
          Text(
            "Resume",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Download my detailed resume to learn more about my experience",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: softGray,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildPrimaryButton(
              "Download",
              Icons.download,
              () async {
                final String resumeUrl = widget.userData["resumefile"] ?? "";
                if (resumeUrl.isNotEmpty) {
                  Uri uri = Uri.parse(resumeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // ═══════════════════ SKILLS SECTION ═══════════════════
  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: softWhite,
      child: Column(
        children: [
          _buildSectionHeader("Skills", "Technical Expertise"),
          const SizedBox(height: 50),
          
          _buildElegantCard(
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.code_outlined,
                      color: primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Technologies & Tools",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                _buildSkillsGrid(),
                const SizedBox(height: 30),
                
                _buildSkillProgressBars(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSkillsGrid() {
    List<dynamic> skills = widget.userData["skills"] as List<dynamic>;
    List<String> skillsList = skills.map((s) => s.toString()).toList();
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: skillsList.map((skill) => _buildSkillChip(skill)).toList(),
    );
  }
  
  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryBlue.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Text(
        skill,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
      ),
    );
  }
  
  Widget _buildSkillProgressBars() {
    List<dynamic> skills = widget.userData["skills"] as List<dynamic>;
    List<String> topSkills = skills.take(4).map((s) => s.toString()).toList();
    List<double> proficiencyLevels = [0.95, 0.88, 0.92, 0.85];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Proficiency Levels",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkGray,
          ),
        ),
        const SizedBox(height: 20),
        
        ...topSkills.asMap().entries.map((entry) {
          int index = entry.key;
          String skill = entry.value;
          double level = index < proficiencyLevels.length ? proficiencyLevels[index] : 0.8;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
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
                        fontWeight: FontWeight.w500,
                        color: darkGray,
                      ),
                    ),
                    Text(
                      "${(level * 100).toInt()}%",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: softGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: level,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, lightBlue],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: MediaQuery.of(context).size.width < 600 ? 28 : 36,
            fontWeight: FontWeight.w700,
            color: darkGray,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Section
            Container(
              color: pureWhite,
              child: _buildHeroSection(),
            ),
            
            // About Section
            _buildAboutSection(),
            
            // Skills Section  
            _buildSkillsSection(),
            
            // Projects Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: pureWhite,
              child: Column(
                children: [
                  _buildSectionHeader("Projects", "Featured Work"),
                  const SizedBox(height: 50),
                  ProjectSliderForDesignFive(projects: widget.userData["projects"]),
                ],
              ),
            ),
            
            // Experience Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: softWhite,
              child: Column(
                children: [
                  _buildSectionHeader("Experience", "Professional Journey"),
                  const SizedBox(height: 50),
                  ExperienceSectionForDesignFive(experiences: widget.userData["experiences"] as List<dynamic>),
                ],
              ),
            ),
            
            // Achievements Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: pureWhite,
              child: Column(
                children: [
                  _buildSectionHeader("Achievements", "Recognition & Awards"),
                  const SizedBox(height: 50),
                  AchievementSliderForDesignFive(achievements: widget.userData["achievements"]),
                ],
              ),
            ),
            
            // Contact Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: softWhite,
              child: Column(
                children: [
                  _buildSectionHeader("Contact", "Let's Connect"),
                  const SizedBox(height: 50),
                  ConnectWithMeDesignFive(userData: widget.userData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
