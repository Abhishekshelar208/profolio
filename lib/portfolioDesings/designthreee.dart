

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/fullscreenimageview.dart';

class DesignThree extends StatelessWidget {
  final Map<String, dynamic> userData;

  DesignThree({required this.userData,});


  @override
  Widget build(BuildContext context) {
    final String designId = "DesignOne";




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

    // void _sharePortfolio() async {
    //   String shareUrl = "https://profolio-abhishek-shelar.web.app/portfolio/$portfolioid";
    //   Uri uri = Uri.parse(shareUrl);
    //   if (await canLaunchUrl(uri)) {
    //     // You can use a package like "share_plus" for more advanced sharing options.
    //     await launchUrl(uri, mode: LaunchMode.externalApplication);
    //   } else {
    //     print("Could not launch share link");
    //   }
    // }


    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sharePortfolio,
      //   child: Icon(Icons.share),
      // ),
      backgroundColor: Color(0xffE8E7E3),
      //appBar: AppBar(title: Text("Portfolio Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            if (userData["personalInfo"]["profilePicture"].isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageView(
                      imageUrl: userData["personalInfo"]["profilePicture"],
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 81,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      userData["personalInfo"]["profilePicture"],
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ),

            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    // Hi, I'm ${userData["personalInfo"]["fullName"]} – Creating, Learning & Growing Every Day!
                    child: Text("${userData["personalInfo"]["fullName"]}",
                      style: GoogleFonts.blinker(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),)),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ...userData["languages"].map<Widget>((language) => Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 4.0),
            //       child: Transform.rotate(
            //         angle: 0, // Change this angle if you want any rotation
            //         child: Text(
            //           "$language,",
            //           style: GoogleFonts.blinker(
            //             fontSize: 20,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //     )).toList(),
            //   ],
            // ),

            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hi, I'm ${userData["personalInfo"]["fullName"]}\n– Creating, Learning &\n Growing Every Day!",
                      style: GoogleFonts.blinker(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Assuming resumeUrl is available in your userData or elsewhere
                    final String resumeUrl = userData["resumefile"] ?? "";

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
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Rounded button
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )

              ],
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Text("${userData["personalInfo"]["degree"]}",style: GoogleFonts.blinker(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                ),
                FittedBox(
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Text("${userData["personalInfo"]["university"]}",style: GoogleFonts.blinker(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ),
                FittedBox(
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Text("${userData["personalInfo"]["graduationYear"]}",style: GoogleFonts.blinker(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 50,
            ),



            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-- Skills --",style: GoogleFonts.blinker(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            SkillSlider(
              skills: (userData["skills"] as List<dynamic>)
                  .map<Map<String, String>>((skill) => {
                "name": skill.toString(), // Ensure it's a string
                "icon": "lib/assets/icons/resume.png"
              })
                  .toList(),
            ),

            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-- Soft Skills --",style: GoogleFonts.blinker(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            SoftSkillSlider(
              softskills: (userData["softSkills"] as List<dynamic>)
                  .map<Map<String, String>>((skill) => {
                "name": skill.toString(), // Ensure it's a string
                "icon": "lib/assets/icons/resume.png"
              })
                  .toList(),
            ),
            SizedBox(
              height: 50,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "-- Languages --",
                  style: GoogleFonts.blinker(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 10.0,
                  children: (userData["languages"] as List<dynamic>).map<Widget>((language) {
                    return Chip(
                      label: Text(
                        language.toString(),
                        style: GoogleFonts.blinker(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white), // Red border
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),






            // Container(
            //   height: 360, // Allocate a fixed height for the grid (adjust as needed)
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white,width: 4), // Red border
            //     borderRadius: BorderRadius.circular(20), // Optional: Rounded corners for the border
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: GridView.builder(
            //       shrinkWrap: true, // Ensures the grid takes only the necessary space
            //       physics: BouncingScrollPhysics(), // Allows scrolling within the container
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2, // Two cards per row
            //         crossAxisSpacing: 16, // Space between columns
            //         mainAxisSpacing: 16, // Space between rows
            //         childAspectRatio: 1.1, // Adjusts height vs width ratio
            //       ),
            //       itemCount: userData["softSkills"].length,
            //       itemBuilder: (context, index) {
            //         final skill = userData["softSkills"][index];
            //         return Card(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20), // Rounded corners
            //           ),
            //           elevation: 4, // Adds shadow for a better look
            //           color: Colors.white,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Image.asset(
            //                 "lib/assets/icons/resume.png", // Assuming the icon is named properly
            //                 width: 30, // Icon size
            //                 height: 30,
            //                 fit: BoxFit.contain,
            //               ),
            //               SizedBox(height: 10),
            //               FittedBox(
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            //                   child: Text(
            //                     skill,
            //                     style: GoogleFonts.blinker(
            //                       fontSize: 25,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),







            // SizedBox(height: 300),
            // Text("Name: ${userData["personalInfo"]["fullName"]}", style: TextStyle(fontSize: 18)),
            // Text("Degree: ${userData["personalInfo"]["degree"]}", style: TextStyle(fontSize: 18)),
            // Text("University: ${userData["personalInfo"]["university"]}", style: TextStyle(fontSize: 18)),
            // Text("Graduation Year: ${userData["personalInfo"]["graduationYear"]}", style: TextStyle(fontSize: 18)),
            // SizedBox(height: 10),
            // Text("Skills:", style: TextStyle(fontWeight: FontWeight.bold)),
            // ...userData["skills"].map<Widget>((skill) => Text("- $skill")).toList(),
            // Text("Soft Skills:", style: TextStyle(fontWeight: FontWeight.bold)),
            // ...userData["softSkills"].map<Widget>((softskill) => Text("- $softskill")).toList(),
            // Text("Languages:", style: TextStyle(fontWeight: FontWeight.bold)),
            // ...userData["languages"].map<Widget>((languages) => Text("- $languages")).toList(),



            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-- Projects --",style: GoogleFonts.blinker(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),

            SizedBox(
              height: 25,
            ),

            ProjectSlider(projects: userData["projects"]),

            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-- Achievements --",style: GoogleFonts.blinker(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),

            SizedBox(
              height: 25,
            ),

            AchievementSlider(
              achievements: userData["achievements"],
            ),

            SizedBox(
              height: 50,
            ),




            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-- Let's Connect --",style: GoogleFonts.blinker(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
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
                    final url = userData["accountLinks"]["instagram"] ?? "" ?? "No number";
                    _launchURL(url);
                  },
                  child: Container(
                    height: 40, // 6% of screen height
                    width: 40, // 12% of screen width
                    child: Image.asset('lib/assets/images/newinsta.png'),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final url = 'https://wa.me/91${userData["accountLinks"]["whatsapp"]}' ?? "No number";
                    _launchURL(url);

                  },
                  child: Container(
                    height: 40, // 6% of screen height
                    width: 40, // 12% of screen width
                    child: Image.asset('lib/assets/images/logo.png'),
                  ),
                ),
                GestureDetector(
                  //onTap: () => _launchUrl(userData["linkedin"] ?? ""),
                  onTap: () async {
                    final String resumeUrl = userData["accountLinks"]["linkedin"] ?? "";

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
                    child: Image.asset('lib/assets/images/newlinkedin.png'),
                  ),
                ),
                GestureDetector(
                  //onTap: () => _launchUrl(userData["github"] ?? ""),
                  onTap: () {
                    final url = userData["accountLinks"]["github"] ?? "" ?? "No projectgithublink";
                    _launchURL(url);
                  },
                  child: Container(
                    height: 40, // 6% of screen height
                    width: 40, // 12% of screen width
                    child: Image.asset('lib/assets/images/newgithub.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),

            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Thank you for exploring my portfolio!",style: GoogleFonts.blinker(
                    color: Colors.black,
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
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),),
                ],
              ),
            ),

            Image.asset("lib/assets/images/circleImage.jpg"),


          ],

        ),
      ),
    );

  }
}


class SkillSlider extends StatefulWidget {
  final List<Map<String, String>> skills; // List containing skill names and icons

  SkillSlider({required this.skills});

  @override
  _SkillSliderState createState() => _SkillSliderState();
}

class _SkillSliderState extends State<SkillSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.5); // Controls the sliding effect
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // Adjust height as needed for the PageView
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.skills.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Scale the card if it's the centered one
              double scale = (index == currentPage.round()) ? 0.9 : 0.7;

              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: scale),
                duration: Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: (index == currentPage.round()) ? 8 : 3,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.skills[index]["icon"]!, // Icon path from skills list
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.skills[index]["name"]!,
                            style: GoogleFonts.blinker(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 16), // Space between the PageView and the dot indicators
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.skills.length, (index) {
            bool isActive = index == currentPage.round();
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}






class ProjectSlider extends StatefulWidget {
  final List<Map<String, dynamic>> projects; // Projects data

  ProjectSlider({required this.projects});

  @override
  _ProjectSliderState createState() => _ProjectSliderState();
}

class _ProjectSliderState extends State<ProjectSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen for page changes
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slideable Project Cards
        SizedBox(
          height: 450, // Adjust height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.projects.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Highlight the center card by scaling
              double scale = (index == currentPage.round()) ? 1.0 : 0.8;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: scale),
                duration: Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: (index == currentPage.round()) ? 8 : 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Project image
                              if (widget.projects[index]["image"] != null &&
                                  widget.projects[index]["image"].isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => FullScreenImageView(
                                        imageUrl: widget.projects[index]["image"],
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      widget.projects[index]["image"],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),
                              // Project title
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  widget.projects[index]["title"] ?? "No Title",
                                  style: GoogleFonts.blinker(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Project description
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  widget.projects[index]["description"] ?? "No Description",
                                  style: GoogleFonts.blinker(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Project techstack
                              Text(
                                widget.projects[index]["techstack"] ?? "No techstack",
                                style: GoogleFonts.blinker(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Action buttons (Github & Youtube)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: (){
                                      final url = widget.projects[index]["projectgithublink"] ?? "No projectgithublink";
                                      _launchURL(url);
                                    },

                                    icon: Image.asset(
                                      "lib/assets/icons/resume.png",
                                      color: Colors.white,
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.contain,
                                    ),
                                    label: Text(
                                      "Github",
                                      style: GoogleFonts.blinker(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                  ),

                                  GestureDetector(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final url = widget.projects[index]["projectyoutubelink"] ?? "https://www.youtube.com/watch?v=uClbo5vyNjA";
                                        _launchURL(url);
                                      },
                                      icon: Image.asset(
                                        "lib/assets/icons/resume.png",
                                        color: Colors.white,
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.contain,
                                      ),
                                      label: Text(
                                        "Youtube",
                                        style: GoogleFonts.blinker(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 30,
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
          ),
        ),
        SizedBox(height: 16),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.projects.length, (index) {
            bool isActive = index == currentPage.round();
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}




class AchievementSlider extends StatefulWidget {
  final List<Map<String, dynamic>> achievements; // Achievements data

  AchievementSlider({required this.achievements});

  @override
  _AchievementSliderState createState() => _AchievementSliderState();
}

class _AchievementSliderState extends State<AchievementSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen for page changes
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slideable Achievement Cards
        SizedBox(
          height: 350, // Adjust height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.achievements.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Highlight the center card by scaling
              double scale = (index == currentPage.round()) ? 1.0 : 0.8;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.8, end: scale),
                duration: Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: (index == currentPage.round()) ? 8 : 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Achievement image
                              if (widget.achievements[index]["image"] != null &&
                                  widget.achievements[index]["image"].isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => FullScreenImageView(
                                        imageUrl: widget.achievements[index]["image"],
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      widget.achievements[index]["image"],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),
                              // Achievement title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      widget.achievements[index]["title"] ?? "No Title",
                                      style: GoogleFonts.blinker(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Achievement description
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, top: 4.0),
                                child: Text(
                                  widget.achievements[index]["description"] ?? "No Description",
                                  style: GoogleFonts.blinker(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
          ),
        ),
        SizedBox(height: 16),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.achievements.length, (index) {
            bool isActive = index == currentPage.round();
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}



class SoftSkillSlider extends StatefulWidget {
  final List<Map<String, String>> softskills; // List containing skill names and icons

  SoftSkillSlider({required this.softskills});

  @override
  _SoftSkillSliderState createState() => _SoftSkillSliderState();
}

class _SoftSkillSliderState extends State<SoftSkillSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.5); // Controls the sliding effect
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // Adjust height as needed for the PageView
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.softskills.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Scale the card if it's the centered one
              double scale = (index == currentPage.round()) ? 0.9 : 0.7;

              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: scale),
                duration: Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: (index == currentPage.round()) ? 8 : 3,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.softskills[index]["icon"]!, // Icon path from skills list
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.softskills[index]["name"]!,
                            style: GoogleFonts.blinker(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 16), // Space between the PageView and the dot indicators
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.softskills.length, (index) {
            bool isActive = index == currentPage.round();
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}




