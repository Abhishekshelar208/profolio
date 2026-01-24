import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profolio/pages/fullscreenimageview.dart';

class AllProjectsPage extends StatelessWidget {
  final List<dynamic> projects;

  const AllProjectsPage({Key? key, required this.projects}) : super(key: key);

  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

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
          "All Projects",
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
              itemCount: projects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                // Increased ratio to 0.95 for even shorter cards
                childAspectRatio: isDesktop ? 0.95 : 0.85, 
              ),
              itemBuilder: (context, index) {
                final project = Map<String, dynamic>.from(projects[index]);
                return _buildProjectCard(context, project, isDesktop);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project, bool isDesktop) {
    final List<String> techStack = project["techstack"]?.toString().split(",") ?? [];

    return Card(
      color: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project["image"] != null && project["image"].toString().isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageView(imageUrl: project["image"]),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    project["image"],
                    width: double.infinity,
                    height: isDesktop ? 200 : 180,
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
            Text(
              project["title"] ?? "No Title",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.blinker(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  project["description"] ?? "No Description",
                  style: GoogleFonts.blinker(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: techStack.map((tech) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(
                        tech.trim(),
                        style: GoogleFonts.blinker(
                          color: const Color(0xfffaa629),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchURL(project["projectgithublink"] ?? ""),
                  icon: const Icon(Icons.code, color: Colors.white),
                  label: Text(
                    "GitHub",
                    style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchURL(project["projectyoutubelink"] ?? ""),
                  icon: const Icon(Icons.play_circle_outline, color: Colors.black),
                  label: Text(
                    "Demo",
                    style: GoogleFonts.blinker(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
