import 'package:flutter/material.dart';
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
  int currentPage = 0;

  // List of 7 design URLs
  final List<String> designUrls = [
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000027",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000026",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000013",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000024",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000026",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000013",
    "https://profolio-abhishek-shelar.web.app/#/portfolio/PortFolio000026",
  ];

  void _nextPage() {
    if (currentPage < designUrls.length - 1) {
      setState(() {
        currentPage++;
      });
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectDesign() {
    final List<String> designNames = [
      "DesignOne",
      "DesignTwo",
      "DesignThree",
      "DesignFour",
      "DesignFive",
      "DesignSix",
      "DesignSeven",
    ];

    String selectedDesign = designNames[currentPage];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(designName: selectedDesign),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Portfolio Design", style: GoogleFonts.blinker()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: designUrls.length,
                physics: NeverScrollableScrollPhysics(), // Disable swipe
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.zero,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri(designUrls[index]),
                        ),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _previousPage,
                icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: _nextPage,
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Select button
          ElevatedButton(
            onPressed: _selectDesign,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              "Select",
              style: GoogleFonts.blinker(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
