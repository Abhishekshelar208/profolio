import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceSectionForDesignSix extends StatefulWidget {
  final List<dynamic> experiences;

  const ExperienceSectionForDesignSix({super.key, required this.experiences});

  @override
  State<ExperienceSectionForDesignSix> createState() => _ExperienceSectionForDesignSixState();
}

class _ExperienceSectionForDesignSixState extends State<ExperienceSectionForDesignSix>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _elevationController;
  
  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _elevationAnimation;
  
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
    
    _elevationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _elevationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  
  // Glassmorphism card component
  Widget _buildGlassmorphicCard({
    required Widget child,
    EdgeInsets? padding,
    double? blur,
    Color? backgroundColor,
    double borderRadius = 20,
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
                  blurRadius: elevation * 10,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null,
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
  
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    if (widget.experiences.isEmpty) {
      return _buildEmptyState();
    }
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Experience cards
            Container(
              height: isMobile ? 400 : 300,
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
            
            const SizedBox(height: 40),
            
            // Navigation dots and arrows
            _buildNavigationControls(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: widget.experiences.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildExperienceCard(widget.experiences[index], index, true),
        );
      },
    );
  }
  
  Widget _buildDesktopLayout() {
    int itemsPerPage = 2;
    int totalPages = (widget.experiences.length / itemsPerPage).ceil();
    
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: totalPages,
      itemBuilder: (context, pageIndex) {
        int startIndex = pageIndex * itemsPerPage;
        int endIndex = math.min(startIndex + itemsPerPage, widget.experiences.length);
        
        return Row(
          children: [
            for (int i = startIndex; i < endIndex; i++) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildExperienceCard(widget.experiences[i], i, false),
                ),
              ),
            ],
            // Fill remaining space if odd number of items
            if ((endIndex - startIndex) < itemsPerPage) 
              Expanded(child: Container()),
          ],
        );
      },
    );
  }
  
  Widget _buildExperienceCard(Map<String, dynamic> experience, int index, bool isMobile) {
    bool isHovered = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: animationValue * (isHovered ? 1.05 : 1.0),
              child: MouseRegion(
                onEnter: (_) {
                  setState(() => isHovered = true);
                  _elevationController.forward();
                },
                onExit: (_) {
                  setState(() => isHovered = false);
                  _elevationController.reverse();
                },
                child: _buildGlassmorphicCard(
                  elevation: isHovered ? 8.0 : 2.0,
                  backgroundColor: cardBg.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company logo area (simulated)
                      _buildCompanyLogo(experience),
                      
                      const SizedBox(height: 20),
                      
                      // Job title and company
                      _buildJobTitle(experience),
                      
                      const SizedBox(height: 12),
                      
                      // Duration
                      _buildDuration(experience),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      _buildDescription(experience, isMobile),
                      
                      const Spacer(),
                      
                      // Learn more button
                      _buildLearnMoreButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildCompanyLogo(Map<String, dynamic> experience) {
    // Create a stylized logo placeholder
    String companyName = experience["company"]?.toString() ?? "Company";
    String initials = companyName.length >= 2 
        ? companyName.substring(0, 2).toUpperCase() 
        : companyName.substring(0, 1).toUpperCase();
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [purpleAccent, accentGlow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textLight,
          ),
        ),
      ),
    );
  }
  
  Widget _buildJobTitle(Map<String, dynamic> experience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience["title"]?.toString() ?? "Position",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          experience["company"]?.toString() ?? "Company",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: purpleAccent,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDuration(Map<String, dynamic> experience) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: purpleAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        "${experience["startDate"]?.toString() ?? ""} - ${experience["endDate"]?.toString() ?? "Present"}",
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: purpleAccent,
        ),
      ),
    );
  }
  
  Widget _buildDescription(Map<String, dynamic> experience, bool isMobile) {
    String description = experience["description"]?.toString() ?? 
        "Take your client onboarding seamlessly by our amazing tool of digital onboarding process.";
    
    return Text(
      description,
      style: GoogleFonts.inter(
        fontSize: isMobile ? 12 : 13,
        fontWeight: FontWeight.w400,
        color: textGray,
        height: 1.5,
      ),
      maxLines: isMobile ? 4 : 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildLearnMoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: purpleAccent.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        'LEARN MORE',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: purpleAccent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  Widget _buildNavigationControls() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    int totalPages = isMobile 
        ? widget.experiences.length 
        : (widget.experiences.length / 2).ceil();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        _buildNavButton(
          Icons.arrow_back_ios,
          _currentIndex > 0,
          () {
            if (_currentIndex > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
        
        const SizedBox(width: 20),
        
        // Dots indicator
        Row(
          children: List.generate(totalPages, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index 
                    ? purpleAccent 
                    : textGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        
        const SizedBox(width: 20),
        
        // Next button
        _buildNavButton(
          Icons.arrow_forward_ios,
          _currentIndex < totalPages - 1,
          () {
            if (_currentIndex < totalPages - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildNavButton(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? purpleAccent.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? purpleAccent.withOpacity(0.3) : textGray.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? purpleAccent : textGray.withOpacity(0.5),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return _buildGlassmorphicCard(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: textGray.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Work Experience Available',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
