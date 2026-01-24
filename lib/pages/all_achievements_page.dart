import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/fullscreenimageview.dart';

class AllAchievementsPage extends StatelessWidget {
  final List<dynamic> achievements;

  const AllAchievementsPage({Key? key, required this.achievements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Achievements",
          style: GoogleFonts.blinker(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: achievements.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                // Using 0.95 aspect ratio as preferred by the user for Projects
                childAspectRatio: isDesktop ? 0.95 : 0.85, 
              ),
              itemBuilder: (context, index) {
                final achievement = Map<String, dynamic>.from(achievements[index]);
                return _buildAchievementCard(context, achievement, isDesktop);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, Map<String, dynamic> achievement, bool isDesktop) {
    return Card(
      color: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (achievement["image"] != null && achievement["image"].toString().isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageView(imageUrl: achievement["image"]),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    achievement["image"],
                    width: double.infinity,
                    height: isDesktop ? 220 : 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                achievement["title"] ?? "No Title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
