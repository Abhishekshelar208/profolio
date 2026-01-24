import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IndividualExperienceEditPage extends StatefulWidget {
  final Map<String, String> experience;

  const IndividualExperienceEditPage({Key? key, required this.experience}) : super(key: key);

  @override
  State<IndividualExperienceEditPage> createState() => _IndividualExperienceEditPageState();
}

class _IndividualExperienceEditPageState extends State<IndividualExperienceEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.experience['title']);
    descriptionController = TextEditingController(text: widget.experience['description']);
  }

  void _saveLocal() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "title": titleController.text,
        "description": descriptionController.text,
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
          "Edit Experience Details",
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
              TextFormField(
                controller: titleController,
                style: GoogleFonts.blinker(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: _inputDecoration("Experience Title"),
                validator: (val) => val!.isEmpty ? "Enter Title" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 10,
                style: GoogleFonts.blinker(fontSize: 16),
                decoration: _inputDecoration("Description"),
                validator: (val) => val!.isEmpty ? "Enter Description" : null,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
