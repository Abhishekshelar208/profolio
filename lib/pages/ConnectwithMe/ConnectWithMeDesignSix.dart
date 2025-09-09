import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectWithMeDesignSix extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ConnectWithMeDesignSix({super.key, required this.userData});

  @override
  State<ConnectWithMeDesignSix> createState() => _ConnectWithMeDesignSixState();
}

class _ConnectWithMeDesignSixState extends State<ConnectWithMeDesignSix>
    with TickerProviderStateMixin {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  
  // Form state
  bool _isSubmitting = false;
  
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
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
        _pulseController.repeat(reverse: true);
        _glowController.repeat(reverse: true);
      }
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
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
  
  void _sendEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      
      try {
        String email = widget.userData["personalInfo"]["email"] ?? "contact@example.com";
        String subject = "Portfolio Contact - ${_nameController.text}";
        String body = "Name: ${_nameController.text}\n"
                     "Email: ${_emailController.text}\n\n"
                     "Message:\n${_messageController.text}";
        
        String emailUrl = "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";
        
        _launchURL(emailUrl);
        
        // Clear form on success
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Message sent successfully!',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: purpleAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error sending message. Please try again.',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        setState(() => _isSubmitting = false);
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
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactInfo(),
        const SizedBox(height: 40),
        _buildContactForm(),
        const SizedBox(height: 40),
        _buildSocialLinks(),
      ],
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Contact info and social links
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildContactInfo(),
              const SizedBox(height: 40),
              _buildSocialLinks(),
            ],
          ),
        ),
        
        const SizedBox(width: 40),
        
        // Right side - Contact form
        Expanded(
          flex: 1,
          child: _buildContactForm(),
        ),
      ],
    );
  }
  
  Widget _buildContactInfo() {
    return _buildGlassmorphicCard(
      backgroundColor: cardBg.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Let's Connect",
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textLight,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Ready to bring your ideas to life? Drop me a message!',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textGray,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Contact details
          _buildContactItem(
            Icons.email_outlined,
            'Email',
            widget.userData["personalInfo"]["email"] ?? "contact@example.com",
            () => _launchURL("mailto:${widget.userData["personalInfo"]["email"] ?? ""}"),
          ),
          
          const SizedBox(height: 20),
          
          _buildContactItem(
            Icons.phone_outlined,
            'Phone',
            widget.userData["personalInfo"]["phone"] ?? "+1 234 567 8900",
            () => _launchURL("tel:${widget.userData["personalInfo"]["phone"] ?? ""}"),
          ),
          
          const SizedBox(height: 20),
          
          _buildContactItem(
            Icons.location_on_outlined,
            'Location',
            widget.userData["personalInfo"]["address"] ?? "San Francisco, CA",
            null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactItem(IconData icon, String label, String value, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: purpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: purpleAccent,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSocialLinks() {
    List<Map<String, dynamic>> socialLinks = [
      {
        'name': 'LinkedIn',
        'icon': Icons.work_outline,
        'url': widget.userData["personalInfo"]["linkedin"] ?? "",
        'color': Colors.blue,
      },
      {
        'name': 'GitHub',
        'icon': Icons.code,
        'url': widget.userData["personalInfo"]["github"] ?? "",
        'color': textLight,
      },
      {
        'name': 'Twitter',
        'icon': Icons.alternate_email,
        'url': widget.userData["personalInfo"]["twitter"] ?? "",
        'color': Colors.lightBlue,
      },
      {
        'name': 'Instagram',
        'icon': Icons.camera_alt,
        'url': widget.userData["personalInfo"]["instagram"] ?? "",
        'color': Colors.pink,
      },
    ];
    
    // Filter out empty URLs
    socialLinks = socialLinks.where((link) => link['url'].toString().isNotEmpty).toList();
    
    return _buildGlassmorphicCard(
      backgroundColor: cardBg.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Me',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textLight,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: socialLinks.map((social) => _buildSocialIcon(social)).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialIcon(Map<String, dynamic> social) {
    bool isHovered = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _launchURL(social['url']),
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isHovered ? social['color'].withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: isHovered ? social['color'] : textGray.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: social['color'].withOpacity(_glowAnimation.value * 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    social['icon'],
                    size: 24,
                    color: isHovered ? social['color'] : textGray,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildContactForm() {
    return _buildGlassmorphicCard(
      backgroundColor: cardBg.withOpacity(0.3),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Message',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textLight,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Name field
            _buildTextField(
              controller: _nameController,
              label: 'Your Name',
              hint: 'John Doe',
              icon: Icons.person_outline,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your name';
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'john@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Message field
            _buildTextField(
              controller: _messageController,
              label: 'Message',
              hint: 'Tell me about your project...',
              icon: Icons.message_outlined,
              maxLines: 4,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your message';
                return null;
              },
            ),
            
            const SizedBox(height: 30),
            
            // Send button
            _buildSendButton(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textGray,
          ),
        ),
        
        const SizedBox(height: 8),
        
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textLight,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: textGray.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              icon,
              color: purpleAccent,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: textGray.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: textGray.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: purpleAccent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _isSubmitting ? null : _sendEmail,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: _isSubmitting
                        ? [textGray.withOpacity(0.5), textGray.withOpacity(0.3)]
                        : [purpleAccent, purpleMid],
                  ),
                  boxShadow: _isSubmitting
                      ? null
                      : [
                          BoxShadow(
                            color: purpleAccent.withOpacity(_pulseAnimation.value * 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSubmitting) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textLight),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ] else ...[
                      const Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      _isSubmitting ? 'Sending...' : 'Send Message',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
