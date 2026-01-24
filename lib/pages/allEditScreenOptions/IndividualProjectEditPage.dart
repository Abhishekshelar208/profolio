import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class IndividualProjectEditPage extends StatefulWidget {
  final Map<String, dynamic> project;

  const IndividualProjectEditPage({Key? key, required this.project}) : super(key: key);

  @override
  State<IndividualProjectEditPage> createState() => _IndividualProjectEditPageState();
}

class _IndividualProjectEditPageState extends State<IndividualProjectEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController techStackController;
  late TextEditingController githubController;
  late TextEditingController youtubeController;
  dynamic currentImage; // Can be File or String (URL) or XFile
  Uint8List? webImageBytes; // For reliable web preview

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.project['title']);
    descriptionController = TextEditingController(text: widget.project['description']);
    techStackController = TextEditingController(text: widget.project['techstack']);
    githubController = TextEditingController(text: widget.project['projectgithublink']);
    youtubeController = TextEditingController(text: widget.project['projectyoutubelink']);
    currentImage = widget.project['image'];
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          currentImage = picked;
          webImageBytes = bytes;
        });
      } else {
        setState(() {
          currentImage = picked;
        });
      }
    }
  }

  void _saveLocal() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "title": titleController.text,
        "description": descriptionController.text,
        "techstack": techStackController.text,
        "projectgithublink": githubController.text,
        "projectyoutubelink": youtubeController.text,
        "image": currentImage,
        "webImageBytes": webImageBytes,
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.blinker(
        color: Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
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
          "Edit Project Details",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveLocal,
            child: Text(
              "Done",
              style: GoogleFonts.blinker(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.5)),
                  ),
                  child: currentImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: kIsWeb
                              ? (webImageBytes != null
                                  ? Image.memory(webImageBytes!, fit: BoxFit.cover)
                                  : currentImage is String
                                      ? Image.network(currentImage as String, fit: BoxFit.cover)
                                      : const SizedBox())
                              : (!kIsWeb && currentImage is XFile)
                                  ? Image.file(io.File(currentImage.path), fit: BoxFit.cover)
                                  : (!kIsWeb && currentImage is io.File)
                                      ? Image.file(currentImage as io.File, fit: BoxFit.cover)
                                      : Image.network(currentImage as String, fit: BoxFit.cover),
                        )
                      : const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                style: GoogleFonts.blinker(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: _inputDecoration("Project Title"),
                validator: (val) => val!.isEmpty ? "Enter Title" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                style: GoogleFonts.blinker(fontSize: 16),
                decoration: _inputDecoration("Description"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: techStackController,
                style: GoogleFonts.blinker(fontSize: 16),
                decoration: _inputDecoration("Tech Stack (comma separated)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: githubController,
                style: GoogleFonts.blinker(fontSize: 16),
                decoration: _inputDecoration("GitHub Link"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: youtubeController,
                style: GoogleFonts.blinker(fontSize: 16),
                decoration: _inputDecoration("YouTube/Demo Link"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
