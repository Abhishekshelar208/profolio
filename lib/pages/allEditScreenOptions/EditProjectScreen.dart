import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;

import '../utils.dart';
import 'AddNewProjectPage.dart';
import 'IndividualProjectEditPage.dart';

class EditProjectScreen extends StatefulWidget {
  final String portfolioId;

  const EditProjectScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/projects");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      projects = data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage(int index) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        projects[index]['image'] = picked;
      });
    }
  }

  Future<void> _addProject() async {
    final newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNewProjectPage()),
    );
    if (newProject != null && newProject is Map<String, dynamic>) {
      setState(() {
        projects.add(newProject);
      });
    }
  }

  void _removeProject(int index) {
    setState(() {
      projects.removeAt(index);
    });
  }

  Future<String> _uploadImageToFirebase(dynamic imageSource, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask task;
    if (kIsWeb) {
      final XFile xFile = imageSource as XFile;
      task = ref.putData(await xFile.readAsBytes());
    } else {
      task = ref.putFile(imageSource as io.File);
    }
    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _saveProjects() async {
    if (projects.isEmpty) {
      Utils().toastMessage('⚠️ Please add at least one project before saving.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> finalProjects = [];

    for (var project in projects) {
      String imageUrl;
      bool isLocalImage = project["image"] is XFile || (!kIsWeb && project["image"] is io.File);

      if (isLocalImage) {
        imageUrl = await _uploadImageToFirebase(
          project["image"],
          "projects/${widget.portfolioId}/${project["title"]}");
      } else {
        imageUrl = project["image"]?.toString() ?? "https://www.infopedia.ai/no-image.png";
      }

      finalProjects.add({
        "title": project["title"],
        "description": project["description"],
        "techstack": project["techstack"],
        "projectgithublink": project["projectgithublink"],
        "projectyoutubelink": project["projectyoutubelink"],
        "image": imageUrl,
      });
    }

    await FirebaseDatabase.instance
        .ref("Portfolio/${widget.portfolioId}/projects")
        .set(finalProjects);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "✅ Projects Saved Successfully.",
            style: GoogleFonts.blinker(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
    );

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  Widget _buildProjectTile(int index) {
    final project = projects[index];
    return Card(
      key: ValueKey(project['title'] ?? index.toString()),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: project['image'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? (project['webImageBytes'] != null
                          ? Image.memory(project['webImageBytes'], fit: BoxFit.cover)
                          : Image.network(project['image'].toString(), fit: BoxFit.cover))
                      : (!kIsWeb && project['image'] is XFile)
                          ? Image.file(io.File(project['image'].path), fit: BoxFit.cover)
                          : (!kIsWeb && project['image'] is io.File)
                              ? Image.file(project['image'] as io.File, fit: BoxFit.cover)
                              : Image.network(project['image'].toString(), fit: BoxFit.cover),
                )
              : const Icon(Icons.image),
        ),
        title: Text(
          project['title'] ?? 'Untitled Project',
          style: GoogleFonts.blinker(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          project['techstack'] ?? '',
          style: GoogleFonts.blinker(color: Colors.blue),
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
                    builder: (_) => IndividualProjectEditPage(project: project),
                  ),
                );
                if (updated != null) {
                  setState(() {
                    projects[index] = updated;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeProject(index),
            ),
          ],
        ),
        onTap: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IndividualProjectEditPage(project: project),
            ),
          );
          if (updated != null) {
            setState(() {
              projects[index] = updated;
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
          "Manage Projects",
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
              onPressed: _addProject,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _saveProjects,
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
                    "Drag and drop projects to reorder. Tap a project to edit details.",
                    style: GoogleFonts.blinker(color: Colors.black54),
                  ),
                ),
                Expanded(
                  child: projects.isEmpty
                      ? const Center(
                          child: Text("No projects found. Click + to add one."),
                        )
                      : ReorderableListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) => _buildProjectTile(index),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final Map<String, dynamic> item = projects.removeAt(oldIndex);
                              projects.insert(newIndex, item);
                            });
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
