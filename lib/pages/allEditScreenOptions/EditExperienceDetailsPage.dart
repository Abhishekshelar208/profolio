import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'IndividualExperienceEditPage.dart';

class EditExperienceDetailsPage extends StatefulWidget {
  final String portfolioId;

  const EditExperienceDetailsPage({Key? key, required this.portfolioId}) : super(key: key);

  @override
  _EditExperienceDetailsPageState createState() => _EditExperienceDetailsPageState();
}

class _EditExperienceDetailsPageState extends State<EditExperienceDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _experienceRef;

  List<Map<String, String>> experienceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _experienceRef = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/experiences");
    _loadExperiences();
  }

  Future<void> _loadExperiences() async {
    final snapshot = await _experienceRef.get();
    if (snapshot.exists) {
      List<Map<String, String>> loadedExperiences = [];
      final data = List.from(snapshot.value as List);
      for (var item in data) {
        loadedExperiences.add({
          "title": item["title"] ?? "",
          "description": item["description"] ?? "",
        });
      }
      setState(() {
        experienceList = loadedExperiences;
        isLoading = false;
      });
    } else {
      setState(() {
        experienceList = [];
        isLoading = false;
      });
    }
  }

  Future<void> _saveExperiences() async {
    if (experienceList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one experience before saving.")),
      );
      return;
    }

    setState(() => isLoading = true);
    await _experienceRef.set(experienceList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Experience Updated Successfully.",
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

  Future<void> _addExperience() async {
    final newExp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const IndividualExperienceEditPage(experience: {"title": "", "description": ""}),
      ),
    );
    if (newExp != null && newExp is Map<String, String>) {
      setState(() {
        experienceList.add(newExp);
      });
    }
  }

  void _removeExperience(int index) {
    setState(() {
      experienceList.removeAt(index);
    });
  }

  Widget _buildExperienceTile(int index) {
    final exp = experienceList[index];
    return Card(
      key: ValueKey(exp['title'] ?? index.toString()),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: Color(0xffe0eae5),
          child: Icon(Icons.work, color: Colors.blue),
        ),
        title: Text(
          exp["title"] ?? "Untitled Experience",
          style: GoogleFonts.blinker(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          exp["description"] ?? "",
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
                    builder: (_) => IndividualExperienceEditPage(experience: exp),
                  ),
                );
                if (updated != null) {
                  setState(() {
                    experienceList[index] = updated;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeExperience(index),
            ),
          ],
        ),
        onTap: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IndividualExperienceEditPage(experience: exp),
            ),
          );
          if (updated != null) {
            setState(() {
              experienceList[index] = updated;
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
        elevation: 0,
        title: Text(
          "Manage Experiences",
          style: GoogleFonts.blinker(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
              onPressed: _addExperience,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _saveExperiences,
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
                    "Drag and drop experiences to reorder. Tap an entry to edit details.",
                    style: GoogleFonts.blinker(color: Colors.black54),
                  ),
                ),
                Expanded(
                  child: experienceList.isEmpty
                      ? const Center(
                          child: Text("No experiences added yet."),
                        )
                      : ReorderableListView.builder(
                          itemCount: experienceList.length,
                          itemBuilder: (context, index) => _buildExperienceTile(index),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final Map<String, String> item = experienceList.removeAt(oldIndex);
                              experienceList.insert(newIndex, item);
                            });
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
