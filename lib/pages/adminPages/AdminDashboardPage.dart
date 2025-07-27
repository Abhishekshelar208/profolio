import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int totalPortfolios = 0;
  Map<String, Map<String, int>> designStats = {}; // {'DesignOne': {'count': 3, 'price': 3200}}

  @override
  void initState() {
    super.initState();
    fetchPortfolioStats();
  }

  Future<void> fetchPortfolioStats() async {
    final dbRef = FirebaseDatabase.instance.ref("Portfolio");
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      totalPortfolios = data.length;

      for (var entry in data.entries) {
        final portfolio = entry.value as Map;
        final design = portfolio["selectedDesign"];
        final priceString = portfolio["designPrice"];
        final price = int.tryParse(priceString?.replaceAll(RegExp(r'[^\d]'), '') ?? "0") ?? 0;


        if (designStats.containsKey(design)) {
          designStats[design]!["count"] = designStats[design]!["count"]! + 1;
        } else {
          designStats[design] = {"count": 1, "price": price};
        }
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Text(
              //   "ProFolio",
              //   style: GoogleFonts.poppins(
              //     color: Colors.white,
              //     fontSize: 36,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              FittedBox(
                child: Text(
                  "Admin Dashboard",
                  style: GoogleFonts.blinker(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📊 Total Portfolios: $totalPortfolios",
                        style: GoogleFonts.blinker(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "🧩 Design Statistics",
                        style: GoogleFonts.blinker(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: designStats.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                          itemCount: designStats.length,
                          itemBuilder: (context, index) {
                            final designName = designStats.keys.elementAt(index);
                            final count = designStats[designName]!["count"];
                            final price = designStats[designName]!["price"];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        designName,
                                        style: GoogleFonts.blinker(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Count : $count",
                                        style: GoogleFonts.blinker(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₹$price",
                                    style: GoogleFonts.blinker(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
