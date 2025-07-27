//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:profolio/pages/userinfopage.dart';
//
// class PortfolioDesignSelectionPage extends StatefulWidget {
//   @override
//   _PortfolioDesignSelectionPageState createState() =>
//       _PortfolioDesignSelectionPageState();
// }
//
// class _PortfolioDesignSelectionPageState
//     extends State<PortfolioDesignSelectionPage> {
//   final PageController _pageController = PageController();
//   int currentPage = 0;
//
//   // List of design URLs
//   final List<String> designUrls = [
//     "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio520f3800",
//     "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio5fadbabc",
//     "https://i.pinimg.com/1200x/7b/4d/fa/7b4dfadca0e599d98bef3f3dda7b48b9.jpg",
//     "https://i.pinimg.com/1200x/7b/4d/fa/7b4dfadca0e599d98bef3f3dda7b48b9.jpg",
//     "https://i.pinimg.com/1200x/7b/4d/fa/7b4dfadca0e599d98bef3f3dda7b48b9.jpg",
//     "https://i.pinimg.com/1200x/7b/4d/fa/7b4dfadca0e599d98bef3f3dda7b48b9.jpg",
//     "https://i.pinimg.com/1200x/7b/4d/fa/7b4dfadca0e599d98bef3f3dda7b48b9.jpg",
//   ];
//
//   final List<String> designNames = [
//     "DesignOne",
//     "DesignTwo",
//     "DesignThree",
//     "DesignFour",
//     "DesignFive",
//     "DesignSix",
//     "DesignSeven",
//   ];
//
//   final List<String> designPrices = [
//     "In just ₹49",
//     "In just ₹99",
//     "In just ₹149",
//     "In just ₹199",
//     "In just ₹249",
//     "In just ₹299",
//     "In just ₹499",
//   ];
//
//   void _nextPage() {
//     if (currentPage < designUrls.length - 1) {
//       setState(() => currentPage++);
//       _pageController.animateToPage(
//         currentPage,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _previousPage() {
//     if (currentPage > 0) {
//       setState(() => currentPage--);
//       _pageController.animateToPage(
//         currentPage,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   // void _selectDesign() {
//   //   String selectedDesign = designNames[currentPage];
//   //
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => UserInfoPage(designName: selectedDesign),
//   //     ),
//   //   );
//   // }
//
//   void _selectDesign() {
//     String selectedDesign = designNames[currentPage];
//     String selectedPrice = designPrices[currentPage];
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserInfoPage(
//           designName: selectedDesign,
//           designPrice: selectedPrice,
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff121212),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff121212),
//         title: Text(
//           "Select Portfolio Design",
//           style: GoogleFonts.blinker(
//             color: const Color(0xfffaa629),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: designUrls.length,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Card(
//                           color: const Color(0xff1e1e1e),
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: InAppWebView(
//                               initialUrlRequest: URLRequest(
//                                 url: WebUri(designUrls[index]),
//                               ),
//                               initialOptions: InAppWebViewGroupOptions(
//                                 crossPlatform: InAppWebViewOptions(
//                                   javaScriptEnabled: true,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "${designPrices[index]}",
//                         style: GoogleFonts.blinker(
//                           fontSize: 16,
//                           color: Color(0xfffaa629),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _previousPage,
//                 icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//                 label: Text(
//                   "Previous",
//                   style: GoogleFonts.blinker(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xfffaa629),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: _nextPage,
//                 icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
//                 label: Text(
//                   "Next",
//                   style: GoogleFonts.blinker(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xfffaa629),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _selectDesign,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xfffaa629),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//             ),
//             child: Text(
//               "Select Design",
//               style: GoogleFonts.blinker(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/userinfopage.dart';

class PortfolioDesignSelectionPage extends StatefulWidget {
  @override
  _PortfolioDesignSelectionPageState createState() =>
      _PortfolioDesignSelectionPageState();
}

class _PortfolioDesignSelectionPageState
    extends State<PortfolioDesignSelectionPage> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> designList = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDesigns();
  }

  void fetchDesigns() async {
    final DatabaseReference _dbRef =
    FirebaseDatabase.instance.ref("PortfolioDetails");
    final snapshot = await _dbRef.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> tempList = [];
      for (var child in snapshot.children) {
        final data = Map<String, dynamic>.from(child.value as Map);
        tempList.add({
          'PortfolioName': data['PortfolioName'] ?? '',
          'PortfolioPrice': data['PortfolioPrice'] ?? '',
          'PortfolioUrl': data['PortfolioUrl'] ?? '',
        });
      }

      setState(() {
        designList = tempList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToNextPage() {
    if (currentIndex < designList.length - 1) {
      setState(() => currentIndex++);
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToPreviousPage() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0eae5),
      body: SafeArea(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : designList.isEmpty
            ? Center(
          child: Text(
            'No designs found.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
            : Column(
          children: [
            SizedBox(height: 30),
            FittedBox(
              child: Text(
                'Select Portfolio Design',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card with only WebView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: designList.length,
                itemBuilder: (context, index) {
                  final design = designList[index];
                  final encodedUrl = Uri.encodeFull(design['PortfolioUrl']);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: WebUri(encodedUrl),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            SizedBox(height: 20),

            // Design Name & Price (based on currentIndex)
            Text(
              designList[currentIndex]['PortfolioName'],
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 4),
            Text(
              designList[currentIndex]['PortfolioPrice'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 15),


            // Navigation Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _goToPreviousPage,
                  icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final selectedDesign = designList[currentIndex];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInfoPage(
                          designName: selectedDesign['PortfolioName'],
                          designPrice: selectedDesign['PortfolioPrice'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Select This Design',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: _goToNextPage,
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );

  }
}
