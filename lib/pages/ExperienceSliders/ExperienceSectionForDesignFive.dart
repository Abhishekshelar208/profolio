import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceSectionForDesignFive extends StatefulWidget {
  final List<dynamic> experiences;

  const ExperienceSectionForDesignFive({super.key, required this.experiences});

  @override
  _ExperienceSectionForDesignFiveState createState() => _ExperienceSectionForDesignFiveState();
}

class _ExperienceSectionForDesignFiveState extends State<ExperienceSectionForDesignFive>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Professional Color Palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color softGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color darkGray = Color(0xFF334155);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color accentBlue = Color(0xFFEFF6FF);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _showPrevious() {
    if (currentStartIndex > 0) {
      setState(() {
        currentStartIndex = (currentStartIndex - 3).clamp(0, widget.experiences.length - 1);
      });
      _animateTransition();
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.experiences.length) {
      setState(() {
        currentStartIndex += 3;
      });
      _animateTransition();
    }
  }

  void _animateTransition() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  // Professional Card Container
  Widget _buildProfessionalCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isHovered = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(isHovered ? 0.15 : 0.08),
            spreadRadius: 0,
            blurRadius: isHovered ? 25 : 15,
            offset: Offset(0, isHovered ? 12 : 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: lightGray,
          width: 1,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: padding ?? const EdgeInsets.all(28),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -5.0 : 0.0),
        child: child,
      ),
    );
  }

  // Enhanced Experience Card
  Widget _buildExperienceCard(dynamic experience, bool isDesktop, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * animationValue),
              child: Opacity(
                opacity: _fadeAnimation.value * animationValue,
                child: MouseRegion(
                  onEnter: (_) => _scaleController.forward(),
                  onExit: (_) => _scaleController.reverse(),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1.0,
                      end: 1.02,
                    ).animate(CurvedAnimation(
                      parent: _scaleController,
                      curve: Curves.easeInOut,
                    )),
                    child: _buildProfessionalCard(
                      height: isDesktop ? 380 : 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Professional Header with Icon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Professional Icon Container
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [primaryBlue, lightBlue],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.work_outline,
                                  color: pureWhite,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Title and Company
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Position Title
                                    Text(
                                      experience["title"] ?? "Position Title",
                                      style: GoogleFonts.inter(
                                        fontSize: isDesktop ? 20 : 18,
                                        fontWeight: FontWeight.w600,
                                        color: darkGray,
                                        letterSpacing: -0.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 6),

                                    // Company Name
                                    Text(
                                      experience["company"] ?? "Company Name",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: primaryBlue,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Duration with Professional Styling
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: accentBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: lightBlue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule_outlined,
                                  size: 14,
                                  color: primaryBlue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  experience["duration"] ?? "Duration",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Professional Divider
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  lightBlue.withOpacity(0.6),
                                  lightBlue.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Experience Description
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                experience["description"] ?? 
                                "Professional experience description detailing key responsibilities, achievements, and contributions in this role. This section highlights the valuable skills and expertise gained during the tenure.",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: softGray,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Professional Achievement Indicator
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Professional Experience",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: softGray,
                                ),
                              ),
                            ],
                          ),
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

  // Professional Navigation Button
  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryBlue, lightBlue],
              )
            : null,
        color: isEnabled ? null : lightGray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
        border: Border.all(
          color: isEnabled ? Colors.transparent : lightGray,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isEnabled ? pureWhite : softGray,
          size: 20,
        ),
      ),
    );
  }

  // Mobile View with Professional PageView
  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            itemCount: widget.experiences.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildExperienceCard(widget.experiences[index], false, index),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Professional Page Indicators
        _buildProfessionalCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue, lightBlue],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              
              const SizedBox(width: 12),

              // Page indicators
              ...List.generate(widget.experiences.length, (index) {
                bool isActive = index == currentStartIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [primaryBlue, lightBlue],
                          )
                        : null,
                    color: isActive ? null : lightGray,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Empty state with professional design
    if (widget.experiences.isEmpty) {
      return _buildProfessionalCard(
        height: 380,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      lightGray,
                      lightGray.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.work_off_outlined,
                  color: softGray,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "No Experience Available",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                "Professional experience will be displayed here",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: softGray,
                  fontWeight: FontWeight.w400,
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

        // Desktop view: Show 3 experiences in a row
        int endIndex = (currentStartIndex + 3).clamp(0, widget.experiences.length);
        List<dynamic> visibleExperiences = widget.experiences.sublist(currentStartIndex, endIndex);

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
                ),

                const SizedBox(width: 24),

                // 3 experience slots
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleExperiences.length) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildExperienceCard(
                              visibleExperiences[slotIndex],
                              true,
                              slotIndex,
                            ),
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: SizedBox.shrink(),
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
                  isEnabled: currentStartIndex + 3 < widget.experiences.length,
                  onPressed: currentStartIndex + 3 < widget.experiences.length ? _showNext : null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Professional Experience Counter
            _buildProfessionalCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryBlue, lightBlue],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Text(
                    "Showing ${currentStartIndex + 1}-$endIndex of ${widget.experiences.length} experiences",
                    style: GoogleFonts.inter(
                      color: softGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
