import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSliderForDesignSix extends StatefulWidget {
  final List<dynamic> projects;

  const ProjectSliderForDesignSix({super.key, required this.projects});

  @override
  State<ProjectSliderForDesignSix> createState() => _ProjectSliderForDesignSixState();
}

class _ProjectSliderForDesignSixState extends State<ProjectSliderForDesignSix>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
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
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
        _rotationController.repeat();
      }
    });
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  
  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
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
    
    if (widget.projects.isEmpty) {
      return _buildEmptyState();
    }
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Projects grid/slider
            Container(
              height: isMobile ? 500 : 600,
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
            
            const SizedBox(height: 40),
            
            // Navigation controls
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
      itemCount: widget.projects.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildProjectCard(widget.projects[index], index, true),
        );
      },
    );
  }
  
  Widget _buildDesktopLayout() {
    // Show 2 projects side by side on desktop
    int itemsPerPage = 2;
    int totalPages = (widget.projects.length / itemsPerPage).ceil();
    
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
        int endIndex = math.min(startIndex + itemsPerPage, widget.projects.length);
        
        return Row(
          children: [
            for (int i = startIndex; i < endIndex; i++) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _buildProjectCard(widget.projects[i], i, false),
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
  
  Widget _buildProjectCard(Map<String, dynamic> project, int index, bool isMobile) {
    bool isHovered = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: animationValue,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() => isHovered = true);
                  _scaleController.forward();
                },
                onExit: (_) {
                  setState(() => isHovered = false);
                  _scaleController.reverse();
                },
                child: AnimatedScale(
                  scale: isHovered ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildGlassmorphicCard(
                    elevation: isHovered ? 8.0 : 2.0,
                    backgroundColor: cardBg.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project mockup/image
                        Expanded(
                          flex: 3,
                          child: _buildProjectMockup(project, index, isMobile),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Project details
                        Expanded(
                          flex: 2,
                          child: _buildProjectDetails(project, isMobile),
                        ),
                      ],
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
  
  Widget _buildProjectMockup(Map<String, dynamic> project, int index, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            darkPrimary.withOpacity(0.5),
            purpleAccent.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          _buildBackgroundPattern(index),
          
          // Project image or mockup placeholder
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: project["image"]?.toString().isNotEmpty == true
                  ? Image.network(
                      project["image"],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildMockupPlaceholder(project, isMobile);
                      },
                    )
                  : _buildMockupPlaceholder(project, isMobile),
            ),
          ),
          
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    darkBg.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // Floating tech tags
          _buildFloatingTags(project),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundPattern(int index) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Transform.rotate(
                angle: _rotationAnimation.value + (index * 0.5),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: purpleAccent.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: Transform.rotate(
                angle: -_rotationAnimation.value * 0.7 + (index * 0.3),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentGlow.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildMockupPlaceholder(Map<String, dynamic> project, bool isMobile) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mockup device frame
          Container(
            width: isMobile ? 150 : 200,
            height: isMobile ? 100 : 140,
            decoration: BoxDecoration(
              color: textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: purpleAccent.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.web,
                    size: isMobile ? 30 : 40,
                    color: purpleAccent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project["title"]?.toString() ?? "Project",
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: textLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          // Mockup reflection
          const SizedBox(height: 8),
          Container(
            width: isMobile ? 150 : 200,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  textLight.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingTags(Map<String, dynamic> project) {
    List<String> technologies = [];
    if (project["techstack"]?.toString().isNotEmpty == true) {
      technologies = project["techstack"].toString().split(",").take(3).toList();
    }
    
    if (technologies.isEmpty) {
      technologies = ["Web", "Mobile", "UI"];
    }
    
    return Positioned(
      top: 16,
      left: 16,
      child: Wrap(
        spacing: 8,
        children: technologies.asMap().entries.map((entry) {
          int idx = entry.key;
          String tech = entry.value.trim();
          
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (idx * 200)),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: purpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: purpleAccent.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: purpleAccent,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildProjectDetails(Map<String, dynamic> project, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured Project label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: accentGlow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: accentGlow.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Featured Project',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: accentGlow,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Project title
        Text(
          project["title"]?.toString() ?? "Example Project",
          style: GoogleFonts.inter(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w700,
            color: textLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Project description
        Expanded(
          child: Text(
            project["description"]?.toString() ?? 
                "A web app for visualizing personalized Spotify data. View your "
                "top artists, top tracks, recently played tracks, and detailed audio "
                "information about each track. Create and save new playlists of "
                "recommended tracks based on your existing playlists and more.",
            style: GoogleFonts.inter(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w400,
              color: textGray,
              height: 1.5,
            ),
            maxLines: isMobile ? 4 : 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Action buttons
        Row(
          children: [
            _buildActionButton(
              "Live Demo",
              Icons.launch,
              () => _launchURL(project["liveurl"]?.toString() ?? ""),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              "Code",
              Icons.code,
              () => _launchURL(project["githuburl"]?.toString() ?? ""),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: purpleAccent.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: purpleAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: purpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavigationControls() {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    int totalPages = isMobile 
        ? widget.projects.length 
        : (widget.projects.length / 2).ceil();
    
    if (totalPages <= 1) return Container();
    
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
        
        // Page indicator dots
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
              Icons.web_outlined,
              size: 64,
              color: textGray.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Projects Available',
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
