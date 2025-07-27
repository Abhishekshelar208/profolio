import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'allEditScreenOptions/EditAchievementScreen.dart';
import 'allEditScreenOptions/EditExperienceDetailsPage.dart';
import 'allEditScreenOptions/EditPersonalDetailsScreen.dart';
import 'allEditScreenOptions/EditProjectScreen.dart';
import 'allEditScreenOptions/EditSkillsScreen.dart';
import 'allEditScreenOptions/EditSocialLinksPage.dart';
import 'allEditScreenOptions/UploadResumePage.dart';

class EditPortfolioOptionsScreen extends StatelessWidget {
  final String portfolioId;

  const EditPortfolioOptionsScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        elevation: 0,
        title: Text(
          "Edit Portfolio",
          style: GoogleFonts.blinker(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOptionTile(context, "Personal Details Section", EditPersonalDetailsScreen(portfolioId: portfolioId)),
          _buildOptionTile(context, "Skills Section", EditSkillsScreen(portfolioId: portfolioId)),
          _buildOptionTile(context, "Project Section", EditProjectScreen(portfolioId: portfolioId)),
          _buildOptionTile(context, "Achievement Section", EditAchievementScreen(portfolioId: portfolioId)),
          _buildOptionTile(context, "Experience Section", EditExperienceDetailsPage(portfolioId: portfolioId)),
          _buildOptionTile(context, "Resume Upload Section", UploadResumePage(portfolioId: portfolioId)),
          _buildOptionTile(context, "Social Links Section", EditSocialLinksPage(portfolioId: portfolioId)),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, Widget screen) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          title,
          style: GoogleFonts.blinker(
            fontSize: 18,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.open_in_new_sharp, color: Colors.blue, size: 22),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
