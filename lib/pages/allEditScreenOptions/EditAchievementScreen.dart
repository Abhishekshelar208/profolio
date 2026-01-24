import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;
import 'IndividualAchievementEditPage.dart';

class EditAchievementScreen extends StatefulWidget {
  final String portfolioId;

  const EditAchievementScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  State<EditAchievementScreen> createState() => _EditAchievementScreenState();
}

class _EditAchievementScreenState extends State<EditAchievementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _achievementRef;

  List<Map<String, dynamic>> achievementsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _achievementRef = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/achievements");
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final snapshot = await _achievementRef.get();
    if (snapshot.exists) {
      List<Map<String, dynamic>> loaded = [];
      final data = List.from(snapshot.value as List);
      for (var item in data) {
        loaded.add({
          "title": item["title"] ?? "",
          "description": item["description"] ?? "",
          "image": item["image"] ?? "",
        });
      }
      setState(() {
        achievementsList = loaded;
        isLoading = false;
      });
    } else {
      setState(() {
        achievementsList = [];
        isLoading = false;
      });
    }
  }

  Future<void> _addAchievement() async {
    final newAch = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const IndividualAchievementEditPage(achievement: {"title": "", "description": "", "image": ""}),
      ),
    );
    if (newAch != null && newAch is Map<String, dynamic>) {
      setState(() {
        achievementsList.add(newAch);
      });
    }
  }

  void _removeAchievement(int index) {
    setState(() {
      achievementsList.removeAt(index);
    });
  }

  Future<String> _uploadImage(dynamic imageSource, String title) async {
    final user = _auth.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('achievements/${user!.uid}/$title');
    UploadTask uploadTask;
    if (kIsWeb) {
      final XFile xFile = imageSource as XFile;
      uploadTask = ref.putData(await xFile.readAsBytes());
    } else {
      uploadTask = ref.putFile(imageSource as io.File);
    }
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _saveAchievements() async {
    if (achievementsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one achievement before saving.")),
      );
      return;
    }

    setState(() => isLoading = true);

    List<Map<String, dynamic>> finalAchievements = [];

    for (var ach in achievementsList) {
      String imageUrl = "";
      bool isLocalImage = ach["image"] is XFile || (!kIsWeb && ach["image"] is io.File);

      if (isLocalImage) {
        imageUrl = await _uploadImage(ach["image"], ach["title"]);
      } else if (ach["image"] != null && ach["image"].toString().startsWith("http")) {
        imageUrl = ach["image"];
      } else {
        imageUrl = "https://www.infopedia.ai/no-image.png";
      }

      finalAchievements.add({
        "title": ach["title"],
        "description": ach["description"],
        "image": imageUrl,
      });
    }

    await _achievementRef.set(finalAchievements);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Achievements Saved Successfully.",
          style: GoogleFonts.blinker(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  Widget _buildAchievementTile(int index) {
    final ach = achievementsList[index];
    return Card(
      key: ValueKey(ach['title'] ?? index.toString()),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: (ach["image"] != null && ach["image"] != "")
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? (ach['webImageBytes'] != null
                          ? Image.memory(ach['webImageBytes'], fit: BoxFit.cover)
                          : Image.network(ach['image'].toString(), fit: BoxFit.cover))
                      : (!kIsWeb && ach["image"] is XFile)
                          ? Image.file(io.File(ach["image"].path), fit: BoxFit.cover)
                          : (!kIsWeb && ach["image"] is io.File)
                              ? Image.file(ach["image"] as io.File, fit: BoxFit.cover)
                              : Image.network(ach["image"].toString(), fit: BoxFit.cover),
                )
              : const Icon(Icons.emoji_events, color: Colors.blue),
        ),
        title: Text(
          ach["title"] ?? "Untitled Achievement",
          style: GoogleFonts.blinker(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          ach["description"] ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.blinker(color: Colors.black54),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IndividualAchievementEditPage(achievement: ach),
                  ),
                );
                if (updated != null) {
                  setState(() {
                    achievementsList[index] = updated;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeAchievement(index),
            ),
          ],
        ),
        onTap: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IndividualAchievementEditPage(achievement: ach),
            ),
          );
          if (updated != null) {
            setState(() {
              achievementsList[index] = updated;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "Manage Achievements",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _addAchievement,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _saveAchievements,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Save All",
                style: GoogleFonts.blinker(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Drag and drop achievements to reorder. Tap an achievement to edit details.",
                    style: GoogleFonts.blinker(color: Colors.black54),
                  ),
                ),
                Expanded(
                  child: achievementsList.isEmpty
                      ? const Center(
                          child: Text("No achievements found. Click + to add one."),
                        )
                      : ReorderableListView.builder(
                          itemCount: achievementsList.length,
                          itemBuilder: (context, index) => _buildAchievementTile(index),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final Map<String, dynamic> item = achievementsList.removeAt(oldIndex);
                              achievementsList.insert(newIndex, item);
                            });
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

