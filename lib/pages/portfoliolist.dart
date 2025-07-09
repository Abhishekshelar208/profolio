import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profolio/pages/designSelectionPage.dart';
import 'package:profolio/pages/userinfopage.dart';
import 'package:profolio/portfolioDesings/designfour.dart';

import '../portfolioDesings/designone.dart';
import '../portfolioDesings/designthreee.dart';
import '../portfolioDesings/designtwo.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

class PortfolioListPage extends StatefulWidget {
  @override
  _PortfolioListPageState createState() => _PortfolioListPageState();
}

class _PortfolioListPageState extends State<PortfolioListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _portfolioRef;

  @override
  void initState() {
    super.initState();
    _portfolioRef = FirebaseDatabase.instance.ref("Portfolio");
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Portfolios")),
        body: Center(child: Text("User not logged in")),
      );
    }

    // Query portfolios where accountLinks/email equals the current user's email
    Query portfolioQuery =
    _portfolioRef.orderByChild("accountLinks/email").equalTo(user.email);

    return Scaffold(
      appBar: AppBar(title: Text("My Portfolios")),
      body: StreamBuilder(
        stream: portfolioQuery.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("No portfolios found"));
          }

          // Convert snapshot value to Map<String, dynamic>
          Map<String, dynamic> portfoliosMap =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          // Build portfolio cards
          List<Widget> portfolioCards = [];
          portfoliosMap.forEach((portfolioId, portfolioData) {
            // Convert portfolioData to Map<String, dynamic>
            final Map<String, dynamic> data =
            Map<String, dynamic>.from(portfolioData as Map);

            // Ensure that list fields are properly cast
            if (data.containsKey("achievements") && data["achievements"] is List) {
              data["achievements"] = (data["achievements"] as List)
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
            }
            if (data.containsKey("projects") && data["projects"] is List) {
              data["projects"] = (data["projects"] as List)
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
            }

            portfolioCards.add(
              GestureDetector(
                onTap: () {
                  // Fetch the selectedDesign field and navigate accordingly.
                  String selectedDesign = data["selectedDesign"] ?? "DesignOne";
                  Widget targetPage;
                  if (selectedDesign == "DesignOne") {
                    targetPage = DesignOne(userData: data);
                  } else if (selectedDesign == "DesignTwo") {
                    targetPage = DesignTwo(userData: data);
                  } else if (selectedDesign == "DesignThree") {
                    targetPage = DesignThree(userData: data);
                  } else if (selectedDesign == "DesignFour") {
                    targetPage = DesignFour(userData: data);
                  } else {
                    // Fallback to DesignOne if not recognized
                    targetPage = DesignOne(userData: data);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Portfolio ID: $portfolioId",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            // Generate share link for this portfolio
                            String shareLink =
                                "https://profolio-abhishek-shelar.web.app/#/portfolio/$portfolioId";
                            // Use share_plus to open the system share sheet
                            Share.share(
                              shareLink,
                              subject: "Check out my portfolio",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });

          return ListView(
            children: portfolioCards,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PortfolioDesignSelectionPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
