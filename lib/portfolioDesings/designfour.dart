import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/AchivementsSliders/achievementsliderfordesigntwo.dart';
import '../pages/fullscreenimageview.dart';
import '../pages/marqueechips.dart';
import '../pages/ProjectSliders/projectsliderfordesigntwo.dart';

class DesignFour extends StatefulWidget {
  final Map<String, dynamic> userData;

  DesignFour({required this.userData});

  @override
  _DesignFourState createState() => _DesignFourState();
}

class _DesignFourState extends State<DesignFour> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollController;
  double _scrollRotationAngle = 0.0;
  double _scrollSpeedMultiplier = 0.001; // Control the scroll rotation speed

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the first animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Define the height animation (from 50 to 250)
    _heightAnimation = Tween<double>(
      begin: 270,
      end: 370,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Define the rotation animation (from 0 to 2 * pi)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 360 degrees in radians
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Define the opacity animation (from 0 to 1)
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the first animation when the screen loads
    _animationController.forward();

    // Initialize the scroll controller for the second animation
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Handle scroll events to rotate the image
  void _handleScroll() {
    setState(() {
      // Calculate the rotation angle based on scroll position
      _scrollRotationAngle = _scrollController.offset * _scrollSpeedMultiplier;
    });
  }




  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch $url");
      }
    }
  }

  // Reusable Widget for Statistic Card
  Widget _buildStatCard(String title, String value) {
    return Container(
      height: 120,
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Update the rotation angle when the user scrolls
          _handleScroll();
          return true;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "Hello, I'm ${widget.userData["personalInfo"]["fullName"].toString().split(" ").first} 👋",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientText(
                          "Hi, I'm ${widget.userData["personalInfo"]["fullName"]}\n– Creating, Learning &\n Growing Every Day!",
                          style: GoogleFonts.blinker(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                          colors: [
                            Colors.white,
                            Colors.grey[300]!,
                            Colors.grey[500]!,
                            Colors.grey[700]!,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final String resumeUrl = widget.userData["resumefile"] ?? "";
                        if (resumeUrl.isNotEmpty) {
                          Uri uri = Uri.parse(resumeUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            print("Could not launch $resumeUrl");
                          }
                        } else {
                          print("No resume file available to download.");
                        }
                      },
                      icon: Image.asset(
                        "lib/assets/icons/resume.png",
                        color: Colors.white,
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Resume",
                          style: GoogleFonts.blinker(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.white, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Animated image with bounce and rotation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.rotate(
                        // Combine both rotations (initial and scroll-based)
                        angle: _rotationAnimation.value + _scrollRotationAngle,
                        child: Container(
                          height: _heightAnimation.value,
                          width: _heightAnimation.value,
                          child: Image.asset(
                            "lib/assets/images/circleImage.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "Projects",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                if (widget.userData["personalInfo"]["profilePicture"].isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FullScreenImageView(
                          imageUrl: widget.userData["personalInfo"]["profilePicture"],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.userData["personalInfo"]["profilePicture"],
                          //width: 150,
                          height: 450,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "About",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Hi Everyone !  I'm",style: GoogleFonts.blinker(
                            fontSize: 30,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.userData["personalInfo"]["fullName"]}",style: GoogleFonts.blinker(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hello everyone I am Abhishek Shelar, Currently I am doing Computer Engg from Datta Meghe College of Engineering, i have completed more than 5+ real life application projects using Flutter.",
                        style: GoogleFonts.blinker(
                          fontSize: 20,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStatCard("Years of Experience", "2+"),
                          SizedBox(
                            width: 25,
                          ),
                          _buildStatCard("Clients", "20+"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildStatCard("Projects Completed", "40+"),
                          SizedBox(
                            width: 25,
                          ),
                          _buildStatCard("Hours of Designing", "100+"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1E1E),
                    border: Border.all(color: Colors.white, width: 0.8 ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 55,
                  width: 400,
                  child: MarqueeChips(
                    velocity: 30.0, // Adjust scrolling speed if needed
                    chips: (widget.userData["skills"] as List<dynamic>).map<Widget>((skill) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          skill.toString(),
                          style: GoogleFonts.blinker(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "Projects",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("My Latest ",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),),
                    Text("Projects",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ProjectSliderForDesignTwo(projects: widget.userData["projects"]),

                SizedBox(
                  height: 50,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "Achievements",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("My ",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),),
                    Text("Achievements",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                AchievementSliderForDesignTwo(
                  achievements: widget.userData["achievements"],
                ),


                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                      ),
                      child: Text(
                        "Soft Skills",
                        style: GoogleFonts.blinker(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                // ExperienceSlider(experience: userData["experiences"]),
                Column(
                  children: List.generate(
                    (widget.userData["languages"] as List<dynamic>).length ~/ 2 + 1,
                        (index) {
                      int start = index * 2;
                      int end = (start + 2) > (widget.userData["languages"] as List<dynamic>).length
                          ? (widget.userData["languages"] as List<dynamic>).length
                          : start + 2;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (widget.userData["languages"] as List<dynamic>)
                            .sublist(start, end)
                            .map<Widget>((language) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Chip(
                              label: Text(
                                language.toString(),
                                style: GoogleFonts.blinker(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: const Color(0xff1E1E1E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white,width: 0.5),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),



                SizedBox(
                  height: 50,
                ),





                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Connect with ",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),),
                    Text("Me",style: GoogleFonts.blinker(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        final url = widget.userData["accountLinks"]["instagram"] ?? "" ?? "No number";
                        _launchURL(url);
                      },
                      child: Container(
                        height: 40, // 6% of screen height
                        width: 40, // 12% of screen width
                        child: Image.asset('lib/assets/images/insta.png'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = 'https://wa.me/91${widget.userData["accountLinks"]["whatsapp"]}' ?? "No number";
                        _launchURL(url);

                      },
                      child: Container(
                        height: 40, // 6% of screen height
                        width: 40, // 12% of screen width
                        child: Image.asset('lib/assets/images/wplogo.png'),
                      ),
                    ),
                    GestureDetector(
                      //onTap: () => _launchUrl(userData["linkedin"] ?? ""),
                      onTap: () async {
                        final String resumeUrl = widget.userData["accountLinks"]["linkedin"] ?? "";

                        if (resumeUrl.isNotEmpty) {
                          Uri uri = Uri.parse(resumeUrl);
                          if (await canLaunchUrl(uri)) {
                            // Launches the URL in an external application (e.g., browser or PDF viewer)
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            print("Could not launch $resumeUrl");
                          }
                        } else {
                          print("No resume file available to download.");
                        }
                      },
                      child: Container(
                        height: 40, // 6% of screen height
                        width: 40, // 12% of screen width
                        child: Image.asset('lib/assets/images/linkedinlogo.webp'),
                      ),
                    ),
                    GestureDetector(
                      //onTap: () => _launchUrl(userData["github"] ?? ""),
                      onTap: () {
                        final url = widget.userData["accountLinks"]["github"] ?? "" ?? "No projectgithublink";
                        _launchURL(url);
                      },
                      child: Container(
                        height: 40, // 6% of screen height
                        width: 40, // 12% of screen width
                        child: Image.asset('lib/assets/images/githublogo2.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Thank you for exploring my portfolio!",style: GoogleFonts.blinker(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("I truly appreciate your time and interest in my work.",style: GoogleFonts.blinker(
                        fontSize: 24,
                        color: Colors.white60,
                        fontWeight: FontWeight.w600,
                      ),),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}