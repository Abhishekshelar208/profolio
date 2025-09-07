import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UpdateDemoVideoPage extends StatefulWidget {
  const UpdateDemoVideoPage({Key? key}) : super(key: key);

  @override
  State<UpdateDemoVideoPage> createState() => _UpdateDemoVideoPageState();
}

class _UpdateDemoVideoPageState extends State<UpdateDemoVideoPage> {
  final TextEditingController _linkController = TextEditingController();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child("DemoVideoLink");

  YoutubePlayerController? _youtubeController;
  String? _videoId;

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _videoId = videoId;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      setState(() {});
    }
  }

  void _saveLink() async {
    final url = _linkController.text.trim();
    if (url.isNotEmpty) {
      await _ref.set({"url": url});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video link updated successfully!")),
      );
      _initializePlayer(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _ref.once().then((snapshot) {
      final data = snapshot.snapshot.value as Map?;
      if (data != null && data['url'] != null) {
        _linkController.text = data['url'];
        _initializePlayer(data['url']);
      }
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Update Demo Video",
          style: GoogleFonts.blinker(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paste the YouTube video link below to update the demo video shown to users.",
                style: GoogleFonts.blinker(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _linkController,
                style: GoogleFonts.blinker(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Enter YouTube video link",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: _saveLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Save Video Link",
                    style: GoogleFonts.blinker(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_youtubeController != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Demo Video Preview:",
                      style: GoogleFonts.blinker(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
