//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class SoftSkillSlider extends StatefulWidget {
//   final List<Map<String, String>> softskills; // List containing skill names and icons
//
//   SoftSkillSlider({required this.softskills});
//
//   @override
//   _SoftSkillSliderState createState() => _SoftSkillSliderState();
// }
//
// class _SoftSkillSliderState extends State<SoftSkillSlider> {
//   final PageController _pageController = PageController(viewportFraction: 0.5); // Controls the sliding effect
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
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 200, // Adjust height as needed for the PageView
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: widget.softskills.length,
//             physics: BouncingScrollPhysics(),
//             itemBuilder: (context, index) {
//               // Scale the card if it's the centered one
//               double scale = (index == currentPage.round()) ? 0.9 : 0.7;
//
//               return TweenAnimationBuilder(
//                 tween: Tween<double>(begin: 0.9, end: scale),
//                 duration: Duration(milliseconds: 300),
//                 builder: (context, double scale, child) {
//                   return Transform.scale(
//                     scale: scale,
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       elevation: (index == currentPage.round()) ? 8 : 3,
//                       color: Colors.white,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             widget.softskills[index]["icon"]!, // Icon path from skills list
//                             width: 40,
//                             height: 40,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             widget.softskills[index]["name"]!,
//                             style: GoogleFonts.blinker(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         SizedBox(height: 16), // Space between the PageView and the dot indicators
//         // Dot indicators
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(widget.softskills.length, (index) {
//             bool isActive = index == currentPage.round();
//             return Container(
//               margin: EdgeInsets.symmetric(horizontal: 4),
//               width: isActive ? 12 : 8,
//               height: isActive ? 12 : 8,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isActive ? Colors.black : Colors.grey,
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
//
//
//
