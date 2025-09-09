import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSliderForDesignThree extends StatefulWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectSliderForDesignThree({super.key, required this.projects});

  @override
  _ProjectSliderForDesignThreeState createState() => _ProjectSliderForDesignThreeState();
}

class _ProjectSliderForDesignThreeState extends State<ProjectSliderForDesignThree>
    with TickerProviderStateMixin {
  int currentStartIndex = 0;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
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
    setState(() {
      currentStartIndex = (currentStartIndex - 3).clamp(0, widget.projects.length - 1);
    });
  }

  void _showNext() {
    setState(() {
      if (currentStartIndex + 3 < widget.projects.length) {
        currentStartIndex += 3;
      }
    });
  }

  // Glassmorphism Container matching designThree.dart
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
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: child,
        ),
      ),
    );
  }

  // Animated project card with floating effect
  Widget _buildAnimatedProjectCard(Map<String, dynamic> project, bool isDesktop, int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 200)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: _buildProjectCard(project, isDesktop),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        if (!isDesktop) return _buildMobileView();

        // Ensure we always show exactly 3 project slots for consistent layout
        int endIndex = (currentStartIndex + 3).clamp(0, widget.projects.length);
        List<Map<String, dynamic>> visibleProjects = widget.projects.sublist(currentStartIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Previous button with glass effect
                _buildGlassMorphismContainer(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    onPressed: currentStartIndex > 0 ? _showPrevious : null,
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Exactly 3 project slots container
                Expanded(
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      if (slotIndex < visibleProjects.length) {
                        // Display actual project
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: _buildAnimatedProjectCard(
                              visibleProjects[slotIndex], 
                              true, 
                              slotIndex
                            ),
                          ),
                        );
                      } else {
                        // Empty placeholder to maintain 3-column layout
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(), // Empty space
                          ),
                        );
                      }
                    }),
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Next button with glass effect
                _buildGlassMorphismContainer(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    onPressed: currentStartIndex + 3 < widget.projects.length ? _showNext : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
                child: _buildAnimatedProjectCard(widget.projects[index], false, index),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        
        // Glass morphism page indicators
        _buildGlassMorphismContainer(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.projects.length, (index) {
              bool isActive = index == currentStartIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF1DD1A1)],
                        )
                      : null,
                  color: isActive ? null : Colors.white.withValues(alpha: 0.4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isDesktop) {
    final List<String> techStack = project["techstack"]?.split(",") ?? [];

    return _buildGlassMorphismContainer(
      height: isDesktop ? 480 : 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image with rounded corners and hover effect
          if (project["image"] != null && project["image"].toString().isNotEmpty)
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: _buildGlassMorphismContainer(
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
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6C63FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Close",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6C63FF).withValues(alpha: 0.1),
                        Color(0xFF1DD1A1).withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      project["image"],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        height: 160,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          SizedBox(height: 16),

          // Project title with gradient text
          Text(
            project["title"] ?? "No Title",
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.white, Color(0xFF6C63FF)],
                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),

          SizedBox(height: 8),

          // Project description
          Expanded(
            flex: 2,
            child: Text(
              project["description"] ?? "No Description",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.4,
              ),
              maxLines: isDesktop ? 3 : 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 12),

          // Tech stack chips with glass effect
          if (techStack.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: techStack.length > 3 ? 3 : techStack.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF6C63FF).withValues(alpha: 0.3),
                          Color(0xFF1DD1A1).withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      techStack[index].trim(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: 16),

          // Action buttons with glass morphism
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF6C63FF).withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6C63FF).withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(project["projectgithublink"] ?? ""),
                    icon: Icon(Icons.code, color: Colors.white, size: 18),
                    label: Text(
                      "GitHub",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1DD1A1), Color(0xFF1DD1A1).withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF1DD1A1).withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(project["projectyoutubelink"] ?? ""),
                    icon: Icon(Icons.video_library, color: Colors.white, size: 18),
                    label: Text(
                      "YouTube",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
