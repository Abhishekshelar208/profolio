import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSliderForDesignFive extends StatefulWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectSliderForDesignFive({super.key, required this.projects});

  @override
  State<ProjectSliderForDesignFive> createState() => _ProjectSliderForDesignFiveState();
}

class _ProjectSliderForDesignFiveState extends State<ProjectSliderForDesignFive>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Professional Color Palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color accentBlue = Color(0xFF1D4ED8);
  static const Color softGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color darkGray = Color(0xFF334155);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);

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

    // Slide animation for project cards
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Scale animation for hover effects
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

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
    _scaleController.dispose();
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

  void _showPrevious() {
    if (currentStartIndex > 0) {
      setState(() {
        currentStartIndex = (currentStartIndex - 3).clamp(0, widget.projects.length - 1);
        _slideController.reset();
        _slideController.forward();
      });
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.projects.length) {
      setState(() {
        currentStartIndex += 3;
        _slideController.reset();
        _slideController.forward();
      });
    }
  }

  // Professional Card Component
  Widget _buildProfessionalCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool elevated = false,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
          if (elevated)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  // Enhanced Project Card with Professional Design
  Widget _buildProjectCard(Map<String, dynamic> project, bool isDesktop, int index) {
    final List<String> techStack = project["techstack"]?.split(",") ?? [];
    bool isHovered = false;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: animationValue,
              child: StatefulBuilder(
                builder: (context, setCardState) {
                  return MouseRegion(
                    onEnter: (_) {
                      setCardState(() => isHovered = true);
                      _scaleController.forward();
                    },
                    onExit: (_) {
                      setCardState(() => isHovered = false);
                      _scaleController.reverse();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..scale(isHovered ? 1.02 : 1.0)
                        ..translate(0.0, isHovered ? -5.0 : 0.0),
                      child: _buildProfessionalCard(
                        height: isDesktop ? 480 : 460,
                        elevated: isHovered,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project Image with Professional Design
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () => _showProjectImageDialog(project),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        primaryBlue.withOpacity(0.1),
                                        lightBlue.withOpacity(0.05),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: primaryBlue.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: project["image"] != null && project["image"].toString().isNotEmpty
                                        ? Image.network(
                                      project["image"],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 48,
                                          color: softGray.withOpacity(0.6),
                                        ),
                                      ),
                                    )
                                        : Container(
                                      child: Icon(
                                        Icons.code_outlined,
                                        size: 48,
                                        color: primaryBlue.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Project Title with Professional Typography
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [primaryBlue, lightBlue],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    project["title"] ?? "Untitled Project",
                                    style: GoogleFonts.inter(
                                      fontSize: isDesktop ? 18 : 16,
                                      fontWeight: FontWeight.w700,
                                      color: darkGray,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Project Description
                            Expanded(
                              flex: 2,
                              child: Text(
                                project["description"] ?? "No description available.",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: softGray,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Tech Stack with Professional Chips
                            if (techStack.isNotEmpty) ...[
                              SizedBox(
                                height: 32,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: techStack.length > 4 ? 4 : techStack.length,
                                  itemBuilder: (context, techIndex) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: primaryBlue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: primaryBlue.withOpacity(0.15),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        techStack[techIndex].trim(),
                                        style: GoogleFonts.inter(
                                          color: primaryBlue,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Action Buttons with Professional Design
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfessionalButton(
                                    label: "View Code",
                                    icon: Icons.code_outlined,
                                    isPrimary: false,
                                    onPressed: () => _launchURL(project["projectgithublink"] ?? ""),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildProfessionalButton(
                                    label: "Live Demo",
                                    icon: Icons.launch_outlined,
                                    isPrimary: true,
                                    onPressed: () => _launchURL(project["projectyoutubelink"] ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Professional Button Component
  Widget _buildProfessionalButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? primaryBlue : Colors.transparent,
        foregroundColor: isPrimary ? Colors.white : primaryBlue,
        side: isPrimary ? null : BorderSide(color: primaryBlue.withOpacity(0.3)),
        elevation: isPrimary ? 2 : 0,
        shadowColor: isPrimary ? primaryBlue.withOpacity(0.3) : null,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Professional Image Dialog
  void _showProjectImageDialog(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
          decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project["title"] ?? "Project Image",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkGray,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: darkGray),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Image
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      project["image"],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 80,
                          color: softGray.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Professional Navigation Button
  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
    required bool isNext,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isEnabled ? primaryBlue : lightGray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ] : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isEnabled ? Colors.white : softGray,
          size: 20,
        ),
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Mobile View with Professional Design
  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 480,
          child: PageView.builder(
            itemCount: widget.projects.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildProjectCard(widget.projects[index], false, index),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Professional Page Indicators
        _buildProfessionalCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.projects.length, (index) {
              bool isActive = index == currentStartIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                    colors: [primaryBlue, lightBlue],
                  )
                      : null,
                  color: isActive ? null : lightGray,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Professional Project Counter
  Widget _buildProjectCounter(int startIndex, int endIndex, int total) {
    return _buildProfessionalCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue, lightBlue],
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Showing ${startIndex + 1}-${endIndex} of $total projects",
            style: GoogleFonts.inter(
              color: softGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.projects.isEmpty) {
      return _buildProfessionalCard(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.work_outline,
                  size: 40,
                  color: softGray,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No Projects Available",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Projects will appear here once they are added",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: softGray,
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

        // Desktop view: Show 3 projects in a row
        int endIndex = (currentStartIndex + 3).clamp(0, widget.projects.length);
        List<Map<String, dynamic>> visibleProjects = widget.projects.sublist(currentStartIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Previous button
                _buildNavButton(
                  icon: Icons.chevron_left,
                  isEnabled: currentStartIndex > 0,
                  onPressed: currentStartIndex > 0 ? _showPrevious : null,
                  isNext: false,
                ),

                const SizedBox(width: 24),

                // 3 project slots with professional spacing
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleProjects.length) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildProjectCard(
                                visibleProjects[slotIndex],
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

                const SizedBox(width: 24),

                // Next button
                _buildNavButton(
                  icon: Icons.chevron_right,
                  isEnabled: currentStartIndex + 3 < widget.projects.length,
                  onPressed: currentStartIndex + 3 < widget.projects.length ? _showNext : null,
                  isNext: true,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Professional project counter
            _buildProjectCounter(currentStartIndex, endIndex, widget.projects.length),
          ],
        );
      },
    );
  }
}
