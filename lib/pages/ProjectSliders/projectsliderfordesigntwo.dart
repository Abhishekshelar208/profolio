// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../fullscreenimageview.dart';
//
// class ProjectSliderForDesignTwo extends StatefulWidget {
//   final List<Map<String, dynamic>> projects; // Projects data
//
//   ProjectSliderForDesignTwo({required this.projects});
//
//   @override
//   _ProjectSliderForDesignTwoState createState() => _ProjectSliderForDesignTwoState();
// }
//
// class _ProjectSliderForDesignTwoState extends State<ProjectSliderForDesignTwo> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   double currentPage = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         currentPage = _pageController.page ?? 0;
//       });
//     });
//   }
//
//   void _launchURL(String url) async {
//     if (url.isNotEmpty) {
//       Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         print("Could not launch $url");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isDesktop = constraints.maxWidth > 800; // Detect PC
//         return Column(
//           children: [
//             SizedBox(
//               height: isDesktop ? 600 : 450, // Increased height for PC
//               child: isDesktop
//                   ? GridView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.75, // Adjust the card aspect ratio
//                 ),
//                 itemCount: widget.projects.length,
//                 itemBuilder: (context, index) {
//                   return _buildProjectCard(index, isDesktop);
//                 },
//               )
//                   : PageView.builder(
//                 controller: _pageController,
//                 itemCount: widget.projects.length,
//                 physics: BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   double scale = (index == currentPage.round()) ? 1.0 : 0.8;
//                   return TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0.9, end: scale),
//                     duration: Duration(milliseconds: 300),
//                     builder: (context, double scale, child) {
//                       return Transform.scale(
//                         scale: scale,
//                         child: _buildProjectCard(index, isDesktop),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             if (!isDesktop) // Show dots only on mobile
//               SizedBox(height: 16),
//             if (!isDesktop)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(widget.projects.length, (index) {
//                   bool isActive = index == currentPage.round();
//                   return Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: isActive ? 12 : 8,
//                     height: isActive ? 12 : 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isActive ? Colors.white : Colors.grey,
//                     ),
//                   );
//                 }),
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildProjectCard(int index, bool isDesktop) {
//     return Card(
//       color: Color(0xff1E1E1E),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Project image
//               if (widget.projects[index]["image"] != null &&
//                   widget.projects[index]["image"].isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => FullScreenImageView(
//                         imageUrl: widget.projects[index]["image"],
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       widget.projects[index]["image"],
//                       width: double.infinity,
//                       height: isDesktop ? 300 : 200, // Larger image for PC
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.image_not_supported,
//                         size: 50,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 8),
//               // Project title
//               Text(
//                 widget.projects[index]["title"] ?? "No Title",
//                 style: GoogleFonts.blinker(
//                   fontSize: 30,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               // Project description
//               Text(
//                 widget.projects[index]["description"] ?? "No Description",
//                 style: GoogleFonts.blinker(
//                   fontSize: 15,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               // Project tech stack
//               Text(
//                 widget.projects[index]["techstack"] ?? "No techstack",
//                 style: GoogleFonts.blinker(
//                   fontSize: 20,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Action buttons (GitHub & YouTube)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectgithublink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.code, color: Colors.white),
//                     label: Text(
//                       "GitHub",
//                       style: GoogleFonts.blinker(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectyoutubelink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.video_library, color: Colors.white),
//                     label: Text(
//                       "YouTube",
//                       style: GoogleFonts.blinker(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../fullscreenimageview.dart';
//
// class ProjectSliderForDesignTwo extends StatefulWidget {
//   final List<Map<String, dynamic>> projects; // Projects data
//
//   ProjectSliderForDesignTwo({required this.projects});
//
//   @override
//   _ProjectSliderForDesignTwoState createState() => _ProjectSliderForDesignTwoState();
// }
//
// class _ProjectSliderForDesignTwoState extends State<ProjectSliderForDesignTwo> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   double currentPage = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         currentPage = _pageController.page ?? 0;
//       });
//     });
//   }
//
//   void _launchURL(String url) async {
//     if (url.isNotEmpty) {
//       Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         print("Could not launch $url");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isDesktop = constraints.maxWidth > 800; // Detect PC
//
//         return Column(
//           children: [
//             isDesktop
//                 ? GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: widget.projects.length,
//               itemBuilder: (context, index) {
//                 return _buildProjectCard(index, isDesktop);
//               },
//             )
//                 : SizedBox(
//               height: 450,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: widget.projects.length,
//                 physics: BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   double scale = (index == currentPage.round()) ? 1.0 : 0.8;
//                   return TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0.9, end: scale),
//                     duration: Duration(milliseconds: 300),
//                     builder: (context, double scale, child) {
//                       return Transform.scale(
//                         scale: scale,
//                         child: _buildProjectCard(index, isDesktop),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             if (!isDesktop)
//               Column(
//                 children: [
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(widget.projects.length, (index) {
//                       bool isActive = index == currentPage.round();
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: isActive ? 12 : 8,
//                         height: isActive ? 12 : 8,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: isActive ? Colors.white : Colors.grey,
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildProjectCard(int index, bool isDesktop) {
//     return Card(
//       color: Color(0xff1E1E1E),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.projects[index]["image"] != null &&
//                   widget.projects[index]["image"].isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => FullScreenImageView(
//                         imageUrl: widget.projects[index]["image"],
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       widget.projects[index]["image"],
//                       width: double.infinity,
//                       height: isDesktop ? 300 : 200,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.image_not_supported,
//                         size: 50,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["title"] ?? "No Title",
//                 style: GoogleFonts.blinker(
//                   fontSize: 30,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["description"] ?? "No Description",
//                 style: GoogleFonts.blinker(
//                   fontSize: 15,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["techstack"] ?? "No techstack",
//                 style: GoogleFonts.blinker(
//                   fontSize: 20,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectgithublink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.code, color: Colors.white),
//                     label: Text(
//                       "GitHub",
//                       style: GoogleFonts.blinker(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectyoutubelink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.video_library, color: Colors.white),
//                     label: Text(
//                       "YouTube",
//                       style: GoogleFonts.blinker(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../fullscreenimageview.dart';
//
// class ProjectSliderForDesignTwo extends StatefulWidget {
//   final List<Map<String, dynamic>> projects;
//
//   ProjectSliderForDesignTwo({required this.projects});
//
//   @override
//   _ProjectSliderForDesignTwoState createState() => _ProjectSliderForDesignTwoState();
// }
//
// class _ProjectSliderForDesignTwoState extends State<ProjectSliderForDesignTwo> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   double currentPage = 0.0;
//   int currentPCPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         currentPage = _pageController.page ?? 0;
//       });
//     });
//   }
//
//   void _launchURL(String url) async {
//     if (url.isNotEmpty) {
//       Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         print("Could not launch $url");
//       }
//     }
//   }
//
//   void _nextPCPage() {
//     final maxPage = (widget.projects.length / 3).ceil();
//     if (currentPCPage < maxPage - 1) {
//       setState(() => currentPCPage++);
//     }
//   }
//
//   void _prevPCPage() {
//     if (currentPCPage > 0) {
//       setState(() => currentPCPage--);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isDesktop = constraints.maxWidth > 800;
//
//         return Column(
//           children: [
//             if (isDesktop)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back_ios),
//                     onPressed: _prevPCPage,
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: List.generate(3, (index) {
//                         int realIndex = currentPCPage * 3 + index;
//                         if (realIndex < widget.projects.length) {
//                           return Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: _buildProjectCard(realIndex, true),
//                             ),
//                           );
//                         } else {
//                           return Expanded(child: Container());
//                         }
//                       }),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.arrow_forward_ios),
//                     onPressed: _nextPCPage,
//                   ),
//                 ],
//               )
//             else
//               SizedBox(
//                 height: 450,
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: widget.projects.length,
//                   physics: BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     double scale = (index == currentPage.round()) ? 1.0 : 0.8;
//                     return TweenAnimationBuilder(
//                       tween: Tween<double>(begin: 0.9, end: scale),
//                       duration: Duration(milliseconds: 300),
//                       builder: (context, double scale, child) {
//                         return Transform.scale(
//                           scale: scale,
//                           child: _buildProjectCard(index, false),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             if (!isDesktop)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(widget.projects.length, (index) {
//                   bool isActive = index == currentPage.round();
//                   return Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: isActive ? 12 : 8,
//                     height: isActive ? 12 : 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isActive ? Colors.white : Colors.grey,
//                     ),
//                   );
//                 }),
//               )
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildProjectCard(int index, bool isDesktop) {
//     return Card(
//       color: Color(0xff1E1E1E),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.projects[index]["image"] != null && widget.projects[index]["image"].isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => FullScreenImageView(
//                         imageUrl: widget.projects[index]["image"],
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       widget.projects[index]["image"],
//                       width: double.infinity,
//                       height: isDesktop ? 300 : 200,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.image_not_supported,
//                         size: 50,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["title"] ?? "No Title",
//                 style: GoogleFonts.blinker(
//                   fontSize: 30,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["description"] ?? "No Description",
//                 style: GoogleFonts.blinker(
//                   fontSize: 15,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 widget.projects[index]["techstack"] ?? "No techstack",
//                 style: GoogleFonts.blinker(
//                   fontSize: 20,
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectgithublink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.code, color: Colors.white),
//                     label: Text("GitHub", style: GoogleFonts.blinker(fontSize: 15, color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       final url = widget.projects[index]["projectyoutubelink"] ?? "";
//                       _launchURL(url);
//                     },
//                     icon: Icon(Icons.video_library, color: Colors.white),
//                     label: Text("YouTube", style: GoogleFonts.blinker(fontSize: 15, color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../fullscreenimageview.dart';

class ProjectSliderForDesignTwo extends StatefulWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectSliderForDesignTwo({Key? key, required this.projects}) : super(key: key);

  @override
  _ProjectSliderForDesignTwoState createState() => _ProjectSliderForDesignTwoState();
}

class _ProjectSliderForDesignTwoState extends State<ProjectSliderForDesignTwo> {
  int currentStartIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        if (!isDesktop) return _buildMobileView();

        int endIndex = (currentStartIndex + 3).clamp(0, widget.projects.length);
        List<Map<String, dynamic>> visibleProjects = widget.projects.sublist(currentStartIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...visibleProjects.map<Widget>((project) {
                  return SizedBox(
                    width: (constraints.maxWidth - 48) / 3, // Adjusted width without arrows
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildProjectCard(project, true),
                    ),
                  );
                }).toList(),
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
          height: 500,
          child: PageView.builder(
            itemCount: widget.projects.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildProjectCard(widget.projects[index], false);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.projects.length, (index) {
            bool isActive = index == currentStartIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.white : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isDesktop) {
    final List<String> techStack = project["techstack"]?.split(",") ?? [];

    return Card(
      color: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project["image"] != null && project["image"].toString().isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageView(imageUrl: project["image"]),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    project["image"],
                    width: double.infinity,
                    height: isDesktop ? 200 : 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),

            Text(
              project["title"] ?? "No Title",
              style: GoogleFonts.blinker(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  project["description"] ?? "No Description",
                  style: GoogleFonts.blinker(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: techStack.map((tech) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(
                        tech.trim(),
                        style: GoogleFonts.blinker(
                          color: const Color(0xfffaa629),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchURL(project["projectgithublink"] ?? ""),
                  icon: const Icon(Icons.code, color: Colors.white),
                  label: Text(
                    "GitHub",
                    style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchURL(project["projectyoutubelink"] ?? ""),
                  icon: const Icon(Icons.play_circle_outline, color: Colors.black),
                  label: Text(
                    "Demo",
                    style: GoogleFonts.blinker(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
