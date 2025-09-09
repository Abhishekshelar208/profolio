import 'dart:ui';
import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSliderForDesignFour extends StatefulWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectSliderForDesignFour({super.key, required this.projects});

  @override
  _ProjectSliderForDesignFourState createState() => _ProjectSliderForDesignFourState();
}

class _ProjectSliderForDesignFourState extends State<ProjectSliderForDesignFour>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _slideController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _slideController.dispose();
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
      });
    }
  }

  void _showNext() {
    if (currentStartIndex + 3 < widget.projects.length) {
      setState(() {
        currentStartIndex += 3;
      });
    }
  }

  // Enhanced Glassmorphic Container matching DesignFour
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

  // Enhanced Project Card for 3-column layout
  Widget _buildProjectCard(Map<String, dynamic> project, bool isDesktop, int index) {
    final List<String> techStack = project["techstack"]?.split(",") ?? [];

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * (index % 2 == 0 ? 0.5 : -0.5)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 200)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildGlassMorphicCard(
                  height: isDesktop ? 520 : 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Image with Enhanced Design
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _showProjectImageDialog(project),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF6366F1).withOpacity(0.2),
                                  Color(0xFF8B5CF6).withOpacity(0.2),
                                  Color(0xFFEC4899).withOpacity(0.2),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6366F1).withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: project["image"] != null && project["image"].toString().isNotEmpty
                                  ? Image.network(
                                project["image"],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 160,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              )
                                  : Container(
                                height: 160,
                                child: Icon(
                                  Icons.code,
                                  size: 60,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Project Title with Gradient Effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          project["title"] ?? "Untitled Project",
                          style: GoogleFonts.inter(
                            fontSize: isDesktop ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 12),

                      // Project Description
                      Expanded(
                        flex: 2,
                        child: Text(
                          project["description"] ?? "No description available.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Tech Stack with Animated Chips
                      if (techStack.isNotEmpty) ...[
                        Container(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: techStack.length > 3 ? 3 : techStack.length,
                            itemBuilder: (context, techIndex) {
                              return AnimatedBuilder(
                                animation: _rotateController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotateAnimation.value * 0.05 * (techIndex % 2 == 0 ? 1 : -1),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                      ),
                                      child: Text(
                                        techStack[techIndex].trim(),
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                      ],

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: "Code",
                              icon: Icons.code,
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              onPressed: () => _launchURL(project["projectgithublink"] ?? ""),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              label: "Demo",
                              icon: Icons.launch,
                              colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
                              onPressed: () => _launchURL(project["projectyoutubelink"] ?? ""),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Enhanced Action Button
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Project Image Dialog
  void _showProjectImageDialog(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: _buildGlassMorphicCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  project["image"],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildActionButton(
                label: "Close",
                icon: Icons.close,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Button
  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(icon == Icons.arrow_back_ios ? _floatAnimation.value * 0.3 : -_floatAnimation.value * 0.3, 0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                    : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.1)],
              ),
              shape: BoxShape.circle,
              boxShadow: isEnabled ? [
                BoxShadow(
                  color: Color(0xFF6366F1).withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ] : null,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile View (single project carousel)
  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 520,
          child: PageView.builder(
            itemCount: widget.projects.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildProjectCard(widget.projects[index], false, index),
              );
            },
          ),
        ),
        SizedBox(height: 20),

        // Page indicators
        _buildGlassMorphicCard(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.projects.length, (index) {
              bool isActive = index == currentStartIndex;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                      : null,
                  color: isActive ? null : Colors.white.withOpacity(0.4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.projects.isEmpty) {
      return _buildGlassMorphicCard(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code_off,
                size: 80,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                "No Projects Available",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
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
                  icon: Icons.arrow_back_ios,
                  isEnabled: currentStartIndex > 0,
                  onPressed: currentStartIndex > 0 ? _showPrevious : null,
                ),

                SizedBox(width: 20),

                // 3 project slots
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

                SizedBox(width: 20),

                // Next button
                _buildNavButton(
                  icon: Icons.arrow_forward_ios,
                  isEnabled: currentStartIndex + 3 < widget.projects.length,
                  onPressed: currentStartIndex + 3 < widget.projects.length ? _showNext : null,
                ),
              ],
            ),

            SizedBox(height: 30),

            // Project counter indicator
            _buildGlassMorphicCard(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                "${currentStartIndex + 1}-${endIndex} of ${widget.projects.length} Projects",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}