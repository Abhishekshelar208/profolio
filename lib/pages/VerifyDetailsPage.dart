import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class VerifyDetailsPage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController aboutyourselfController;
  final TextEditingController useremailController;
  final TextEditingController graduationYearController;
  final File? imageFile;
  final File? resumeFile;
  final List skillsList;
  final List softSkillsList;
  final List toolsList;
  final List achievementsList;
  final List experienceList;
  final List projectsList;
  final Function(bool) onVerificationComplete; // ✅ Callback to parent

  const VerifyDetailsPage({
    super.key,
    required this.nameController,
    required this.aboutyourselfController,
    required this.useremailController,
    required this.graduationYearController,
    required this.imageFile,
    required this.resumeFile,
    required this.skillsList,
    required this.softSkillsList,
    required this.toolsList,
    required this.achievementsList,
    required this.experienceList,
    required this.projectsList,
    required this.onVerificationComplete,
  });

  @override
  State<VerifyDetailsPage> createState() => _VerifyDetailsPageState();
}

class _VerifyDetailsPageState extends State<VerifyDetailsPage> {
  bool isPerfect = false;
  List<String> missingFields = [];

  void validateDetails() {
    missingFields.clear();

    if (widget.nameController.text.trim().isEmpty) missingFields.add("Name");
    if (widget.aboutyourselfController.text.trim().isEmpty) missingFields.add("About Yourself");
    if (widget.useremailController.text.trim().isEmpty) missingFields.add("Email");
    if (widget.graduationYearController.text.trim().isEmpty) missingFields.add("Graduation Year");
    if (widget.imageFile == null) missingFields.add("Set Profile Picture");
    if (widget.resumeFile == null) missingFields.add("Upload Resume File");
    if (widget.skillsList.isEmpty) missingFields.add("Skills");
    if (widget.softSkillsList.isEmpty) missingFields.add("Soft Skills");
    if (widget.toolsList.isEmpty) missingFields.add("Languages");
    if (widget.achievementsList.isEmpty) missingFields.add("Achievements");
    if (widget.experienceList.isEmpty) missingFields.add("Experiences");
    if (widget.projectsList.isEmpty) missingFields.add("Projects");

    setState(() {
      isPerfect = missingFields.isEmpty;
    });

    if (isPerfect) {
      // ✅ Automatically go back and inform parent
      widget.onVerificationComplete(true);
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "Verification Page",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: validateDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffaa629),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  "Click to Verify",
                  style: GoogleFonts.blinker(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (!isPerfect) ...[
              Text(
                "⚠️ Missing Required Fields:",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: missingFields.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.redAccent),
                    title: Text(
                      missingFields[index],
                      style: GoogleFonts.blinker(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                },
              ),
            ],

            if (isPerfect) ...[
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      "All details are perfect!",
                      style: GoogleFonts.blinker(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
