// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:profolio/pages/designSelectionPage.dart';
// import 'package:profolio/pages/userinfopage.dart';
// import 'package:profolio/portfolioDesings/designfour.dart';
//
// import '../portfolioDesings/designone.dart';
// import '../portfolioDesings/designthreee.dart';
// import '../portfolioDesings/designtwo.dart';
// import 'package:share_plus/share_plus.dart';
//
// import 'editPortfolioScreen.dart'; // Import share_plus
//
// class PortfolioListPage extends StatefulWidget {
//   @override
//   _PortfolioListPageState createState() => _PortfolioListPageState();
// }
//
// class _PortfolioListPageState extends State<PortfolioListPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late DatabaseReference _portfolioRef;
//
//   @override
//   void initState() {
//     super.initState();
//     _portfolioRef = FirebaseDatabase.instance.ref("Portfolio");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("My Portfolios")),
//         body: Center(child: Text("User not logged in")),
//       );
//     }
//
//     // Query portfolios where accountLinks/email equals the current user's email
//     Query portfolioQuery =
//     _portfolioRef.orderByChild("accountLinks/email").equalTo(user.email);
//
//     return Scaffold(
//       appBar: AppBar(title: Text("My Portfolios")),
//       body: StreamBuilder(
//         stream: portfolioQuery.onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text("No portfolios found"));
//           }
//
//           // Convert snapshot value to Map<String, dynamic>
//           Map<String, dynamic> portfoliosMap =
//           Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
//
//           // Build portfolio cards
//           List<Widget> portfolioCards = [];
//           portfoliosMap.forEach((portfolioId, portfolioData) {
//             // Convert portfolioData to Map<String, dynamic>
//             final Map<String, dynamic> data =
//             Map<String, dynamic>.from(portfolioData as Map);
//
//             // Ensure that list fields are properly cast
//             if (data.containsKey("achievements") && data["achievements"] is List) {
//               data["achievements"] = (data["achievements"] as List)
//                   .map((e) => Map<String, dynamic>.from(e))
//                   .toList();
//             }
//             if (data.containsKey("projects") && data["projects"] is List) {
//               data["projects"] = (data["projects"] as List)
//                   .map((e) => Map<String, dynamic>.from(e))
//                   .toList();
//             }
//
//             portfolioCards.add(
//               GestureDetector(
//                 onTap: () {
//                   // Fetch the selectedDesign field and navigate accordingly.
//                   String selectedDesign = data["selectedDesign"] ?? "DesignOne";
//                   Widget targetPage;
//                   if (selectedDesign == "DesignOne") {
//                     targetPage = DesignOne(userData: data);
//                   } else if (selectedDesign == "DesignTwo") {
//                     targetPage = DesignTwo(userData: data);
//                   } else if (selectedDesign == "DesignThree") {
//                     targetPage = DesignThree(userData: data);
//                   } else if (selectedDesign == "DesignFour") {
//                     targetPage = DesignFour(userData: data);
//                   } else {
//                     // Fallback to DesignOne if not recognized
//                     targetPage = DesignOne(userData: data);
//                   }
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => targetPage),
//                   );
//                 },
//                 child: Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "Portfolio ID: $portfolioId",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         // IconButton(
//                         //   icon: Icon(Icons.share),
//                         //   onPressed: () {
//                         //     // Generate share link for this portfolio
//                         //     String shareLink =
//                         //         "https://profolio-abhishek-shelar.web.app/#/portfolio/$portfolioId";
//                         //     // Use share_plus to open the system share sheet
//                         //     Share.share(
//                         //       shareLink,
//                         //       subject: "Check out my portfolio",
//                         //     );
//                         //   },
//                         // ),
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           tooltip: "Edit Portfolio",
//                           onPressed: () {
//                             // TODO: Navigate to edit screen (not implemented yet)
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditPortfolioOptionsScreen(portfolioId: portfolioId),
//                               ),
//                             );
//
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.share),
//                           tooltip: "Share Portfolio",
//                           onPressed: () {
//                             String shareLink =
//                                 "https://profolio-abhishek-shelar.web.app/#/portfolio/$portfolioId";
//                             Share.share(
//                               shareLink,
//                               subject: "Check out my portfolio",
//                             );
//                           },
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           });
//
//           return ListView(
//             children: portfolioCards,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => PortfolioDesignSelectionPage()));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/designSelectionPage.dart';
import 'package:profolio/portfolioDesings/designfour.dart';
import 'package:profolio/portfolioDesings/designone.dart';
import 'package:profolio/portfolioDesings/designthreee.dart';
import 'package:profolio/portfolioDesings/designtwo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'CreatePaymentCodePage.dart';
import 'TransactionHistoryPage.dart';
import 'UploadImagePage.dart';
import 'adminPages/AdminDashboardPage.dart';
import 'adminPages/AdminPortfolioManagerPage.dart';
import 'adminPages/GenerateCouponCodePage.dart';
import 'adminPages/ShopListPage.dart';
import 'editPortfolioScreen.dart';

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
    _portfolioRef = FirebaseDatabase.instance.ref("Portfolio"); // ✅ Make sure this matches your DB path
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
        backgroundColor: Color(0xffe0eae5),
        appBar: AppBar(
          backgroundColor: Color(0xffe0eae5),
          title: Text(
            "The ProFolio",
            style: GoogleFonts.blinker(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.space_dashboard_rounded, color: Colors.black54,),
            //   tooltip: "Admin Dashboard",
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
            //     );
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.history, color: Colors.black54,),
              tooltip: "Transaction History",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.black54,),
              tooltip: "Coupon Code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopListPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.vpn_key, color: Colors.black54,),
              tooltip: "Create Payment Code",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePaymentCodePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.design_services, color: Colors.black54,),
              tooltip: "Designs",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPortfolioManagerPage()),
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
              return Center(child:
              Text(
                "No Portfolio Found",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),);
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
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    color: Colors.white.withOpacity(0.9),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white60],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.08),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Portfolio",
                              style: GoogleFonts.blinker(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "ID: $portfolioId",
                              style: GoogleFonts.blinker(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Buttons aligned to bottom right
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Edit Button
                                  SizedBox(
                                    width: 80,
                                    height: 35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPortfolioOptionsScreen(portfolioId: portfolioId),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Edit",
                                        style: GoogleFonts.blinker(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Share Button
                                  SizedBox(
                                    width: 80,
                                    height: 35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        backgroundColor: Colors.blueAccent,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        String shareLink =
                                            "https://profolio-abhishek-shelar.web.app/#/portfolio/$portfolioId";

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Share Portfolio"),
                                              content: SizedBox(
                                                width: 250,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      QrImageView(
                                                        data: shareLink,
                                                        version: QrVersions.auto,
                                                        size: 200.0,
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      const SizedBox(height: 16),
                                                      ElevatedButton.icon(
                                                        icon: const Icon(Icons.share, color: Colors.black),
                                                        label: const Text("Share Link"),
                                                        onPressed: () {
                                                          Share.share(shareLink,
                                                              subject: "Check out my portfolio");
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Close"),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Share",
                                        style: GoogleFonts.blinker(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),


                                  // Delete Button
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete Portfolio",
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                            "Delete Portfolio",
                                            style: GoogleFonts.blinker(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          content: Text(
                                            "Are you sure to delete this ?",
                                            style: GoogleFonts.blinker(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(
                                                "Cancel",
                                                style: GoogleFonts.blinker(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await _portfolioRef.child(portfolioId).remove();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Portfolio deleted successfully")),
                                                );
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Delete",
                                                style: GoogleFonts.blinker(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),




                ),
              );
            });

            return ListView(children: portfolioCards);
          },
        ),
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PortfolioDesignSelectionPage(),
                ),
              );
            },
            shape: const CircleBorder(), // Explicitly make it circular
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),

      ),
    );
  }
}
