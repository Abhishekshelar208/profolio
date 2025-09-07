import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class DemoVideoPage extends StatefulWidget {
  const DemoVideoPage({Key? key}) : super(key: key);

  @override
  State<DemoVideoPage> createState() => _DemoVideoPageState();
}

class _DemoVideoPageState extends State<DemoVideoPage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child("DemoVideoLink");
  YoutubePlayerController? _controller;
  String? _videoUrl;
  String? _videoId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoLink();
  }

  Future<void> _fetchVideoLink() async {
    final snapshot = await _ref.get();
    final data = snapshot.value as Map?;
    if (data != null && data['url'] != null) {
      _videoUrl = data['url'].toString().trim();
      _videoId = YoutubePlayer.convertUrlToId(_videoUrl!);

      if (_videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _launchYouTube() async {
    if (_videoUrl == null) return;
    final Uri url = Uri.parse(_videoUrl!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open YouTube")),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "App Tutorial",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "📽️ Watch this quick video to learn how to use the app effectively.",
              textAlign: TextAlign.center,
              style: GoogleFonts.blinker(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _controller != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.redAccent,
              ),
            )
                : Column(
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.red, size: 80),
                const SizedBox(height: 10),
                Text(
                  "No video link found",
                  style: GoogleFonts.blinker(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "✅ How to Use This App",
              style: GoogleFonts.blinker(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "• Watch till the end to understand all features\n"
                  "• Follow step-by-step instructions\n"
                  "• Share with friends and classmates",
              style: GoogleFonts.blinker(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            if (_videoUrl != null)
              ElevatedButton.icon(
                onPressed: _launchYouTube,
                icon: const Icon(Icons.play_circle_fill),
                label: Text(
                  "Watch on YouTube",
                  style: GoogleFonts.blinker(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
