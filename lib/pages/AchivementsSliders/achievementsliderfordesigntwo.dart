// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../fullscreenimageview.dart';
//
// class AchievementSliderForDesignTwo extends StatefulWidget {
//   final List<Map<String, dynamic>> achievements; // Achievements data
//
//   AchievementSliderForDesignTwo({required this.achievements});
//
//   @override
//   _AchievementSliderForDesignTwoState createState() => _AchievementSliderForDesignTwoState();
// }
//
// class _AchievementSliderForDesignTwoState extends State<AchievementSliderForDesignTwo> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   double currentPage = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Listen for page changes
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
//         bool isDesktop = constraints.maxWidth > 800;
//
//         return Column(
//           children: [
//             isDesktop
//                 ? // Grid view for larger screens
//             GridView.builder(
//               shrinkWrap: true,
//               itemCount: widget.achievements.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 childAspectRatio: 0.75,
//               ),
//               itemBuilder: (context, index) {
//                 return _buildAchievementCard(widget.achievements[index], index, isDesktop);
//               },
//             )
//                 : // Page view for mobile screens
//             SizedBox(
//               height: isDesktop ? 350 : 350,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: widget.achievements.length,
//                 physics: BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   double scale = (index == currentPage.round()) ? 1.0 : 0.8;
//                   return TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0.8, end: scale),
//                     duration: Duration(milliseconds: 300),
//                     builder: (context, double scale, child) {
//                       return Transform.scale(
//                         scale: scale,
//                         child: _buildAchievementCard(
//                             widget.achievements[index], index, isDesktop),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//             // Dot indicators for mobile view
//             if (!isDesktop)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(widget.achievements.length, (index) {
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
//   // Widget to build achievement card (common for both grid and slider)
//   Widget _buildAchievementCard(Map<String, dynamic> achievement, int index, bool isDesktop) {
//     return Card(
//       color: Color(0xff1E1E1E),
//       margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 6,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Achievement image
//               if (achievement["image"] != null && achievement["image"].isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => FullScreenImageView(
//                         imageUrl: achievement["image"],
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       achievement["image"],
//                       width: double.infinity,
//                       height: isDesktop ? 300 : 150,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.image_not_supported,
//                         size: 50,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 8),
//               // Achievement title
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5.0),
//                     child: Text(
//                       achievement["title"] ?? "No Title",
//                       style: GoogleFonts.blinker(
//                         fontSize: isDesktop ? 24 : 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Achievement description
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0, top: 4.0),
//                 child: Text(
//                   achievement["description"] ?? "No Description",
//                   style: GoogleFonts.blinker(
//                     fontSize: isDesktop ? 16 : 14,
//                     color: Colors.white60,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../fullscreenimageview.dart';

class AchievementSliderForDesignTwo extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  AchievementSliderForDesignTwo({required this.achievements});

  @override
  _AchievementSliderForDesignTwoState createState() =>
      _AchievementSliderForDesignTwoState();
}

class _AchievementSliderForDesignTwoState
    extends State<AchievementSliderForDesignTwo> {
  int currentStartIndex = 0;

  void _showPrevious() {
    setState(() {
      currentStartIndex =
          (currentStartIndex - 3).clamp(0, widget.achievements.length - 1);
    });
  }

  void _showNext() {
    setState(() {
      if (currentStartIndex + 3 < widget.achievements.length) {
        currentStartIndex += 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      if (!isDesktop) {
        return _buildMobileView();
      }

      int endIndex =
      (currentStartIndex + 3).clamp(0, widget.achievements.length);
      List<Map<String, dynamic>> visibleAchievements =
      widget.achievements.sublist(currentStartIndex, endIndex);

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: visibleAchievements
                .map((achievement) => SizedBox(
              width: (constraints.maxWidth - 48) / 3, // Adjusted width without arrows
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildAchievementCard(achievement, true),
              ),
            ))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget _buildMobileView() {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: PageView.builder(
            itemCount: widget.achievements.length,
            onPageChanged: (index) {
              setState(() {
                currentStartIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildAchievementCard(widget.achievements[index], false);
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.achievements.length, (index) {
            bool isActive = index == currentStartIndex;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
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

  Widget _buildAchievementCard(
      Map<String, dynamic> achievement, bool isDesktop) {
    return Card(
      color: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (achievement["image"] != null &&
                achievement["image"].isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageView(
                        imageUrl: achievement["image"]),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    achievement["image"],
                    width: double.infinity,
                    height: isDesktop ? 220 : 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),

            Center(
              child: Text(
                achievement["title"] ?? "No Title",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  achievement["description"] ?? "No Description",
                  style: GoogleFonts.blinker(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

