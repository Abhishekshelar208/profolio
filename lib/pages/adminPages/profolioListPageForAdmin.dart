

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/designSelectionPage.dart';
import 'package:profolio/portfolioDesings/designfour.dart';
import 'package:profolio/portfolioDesings/designone.dart';
import 'package:profolio/portfolioDesings/designthreee.dart';
import 'package:profolio/portfolioDesings/designtwo.dart';
import 'package:share_plus/share_plus.dart';

import '../CreatePaymentCodePage.dart';
import '../editPortfolioScreen.dart';
import 'AdminDashboardPage.dart';
import 'ShopListPage.dart';


class PortfolioListPageForAdmin extends StatefulWidget {
  @override
  _PortfolioListPageForAdminState createState() => _PortfolioListPageForAdminState();
}

class _PortfolioListPageForAdminState extends State<PortfolioListPageForAdmin> {
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
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          backgroundColor: const Color(0xff121212),
          title: Text("My Portfolios", style: GoogleFonts.blinker(color: Color(0xfffaa629))),
        ),
        body: const Center(child: Text("User not logged in", style: TextStyle(color: Colors.white))),
      );
    }

    Query portfolioQuery = _portfolioRef.orderByChild("accountLinks/email").equalTo(user.email);

    return WillPopScope(
      onWillPop: () async => false, // 🔒 Disables back navigation
      child: Scaffold(
        backgroundColor: const Color(0xff121212),
        appBar: AppBar(
          backgroundColor: const Color(0xff121212),
          title: Text(
            "My Portfolios",
            style: GoogleFonts.blinker(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xfffaa629),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.space_dashboard_rounded, color: Color(0xfffaa629)),
              tooltip: "Admin Dashboard",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Color(0xfffaa629)),
              tooltip: "Coupon Code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopListPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.vpn_key, color: Color(0xfffaa629)),
              tooltip: "Create Payment Code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePaymentCodePage()),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: portfolioQuery.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: Text("No portfolios found", style: TextStyle(color: Colors.white70)));
            }

            Map<String, dynamic> portfoliosMap =
            Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

            List<Widget> portfolioCards = [];
            portfoliosMap.forEach((portfolioId, portfolioData) {
              final Map<String, dynamic> data = Map<String, dynamic>.from(portfolioData as Map);

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
                    String selectedDesign = data["selectedDesign"] ?? "DesignOne";
                    Widget targetPage;
                    switch (selectedDesign) {
                      case "DesignTwo":
                        targetPage = DesignTwo(userData: data);
                        break;
                      case "DesignThree":
                        targetPage = DesignThree(userData: data);
                        break;
                      case "DesignFour":
                        targetPage = DesignFour(userData: data);
                        break;
                      default:
                        targetPage = DesignOne(userData: data);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
                  },
                  child: Card(
                    color: const Color(0xff1e1e1e),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Portfolio",
                                  style: GoogleFonts.blinker(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xfffaa629),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "ID: $portfolioId",
                                  style: GoogleFonts.blinker(
                                    fontSize: 14,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            tooltip: "Edit Portfolio",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPortfolioOptionsScreen(portfolioId: portfolioId),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.green),
                            tooltip: "Share Portfolio",
                            onPressed: () {
                              String shareLink =
                                  "https://profolio-abhishek-shelar.web.app/#/portfolio/$portfolioId";
                              Share.share(shareLink, subject: "Check out my portfolio");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                ),
              );
            });

            return ListView(children: portfolioCards);
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xfffaa629),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PortfolioDesignSelectionPage()));
          },
          child: const Icon(Icons.add, color: Colors.black87, size: 30,),
        ),
      ),
    );
  }
}
