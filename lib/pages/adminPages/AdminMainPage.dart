import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CreatePaymentCodePage.dart';
import '../UploadImagePage.dart';
import 'AdminDashboardPage.dart';
import 'AdminPortfolioManagerPage.dart';
import 'AdminViewAllUsersPage.dart';
import 'ShopListPage.dart';
import 'UpdateDemoVideoPage.dart';

// Import your actual pages here


class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Admin Panel",
          style: GoogleFonts.blinker(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _AdminCard(
              icon: Icons.supervised_user_circle,
              label: "All Users Details",
              color: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminViewAllUsersPage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.space_dashboard_rounded,
              label: "Dashboard",
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.vpn_key,
              label: "Payment Code",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePaymentCodePage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.home,
              label: "Coupon Code",
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopListPage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.design_services,
              label: "Designs",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPortfolioManagerPage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.design_services,
              label: "Youtube",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdateDemoVideoPage()),
                );
              },
            ),
            _AdminCard(
              icon: Icons.image,
              label: "Payment Qr Image",
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadImagePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                radius: 28,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
