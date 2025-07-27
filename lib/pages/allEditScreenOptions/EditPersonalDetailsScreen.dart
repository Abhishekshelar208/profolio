import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditPersonalDetailsScreen extends StatefulWidget {
  final String portfolioId;

  const EditPersonalDetailsScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  State<EditPersonalDetailsScreen> createState() => _EditPersonalDetailsScreenState();
}

class _EditPersonalDetailsScreenState extends State<EditPersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController noOfSkillsController = TextEditingController();
  final TextEditingController monthsOfExperienceController = TextEditingController();
  final TextEditingController internshipsCompletedController = TextEditingController();
  final TextEditingController noOfProjectsCompletedController = TextEditingController();

  File? _imageFile;
  String? currentProfileUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonalDetails();
  }

  void _loadPersonalDetails() async {
    final ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final personalInfo = Map<String, dynamic>.from(data["personalInfo"]);

      setState(() {
        nameController.text = personalInfo["fullName"] ?? '';
        aboutController.text = personalInfo["aboutyourself"] ?? '';
        currentProfileUrl = personalInfo["profilePicture"] ?? '';

        noOfSkillsController.text = data["NoofSKills"] ?? '';
        monthsOfExperienceController.text = data["MonthsofExperience"] ?? '';
        internshipsCompletedController.text = data["InternshipsCompleted"] ?? '';
        noOfProjectsCompletedController.text = data["NoofProjectsCompleted"] ?? '';

        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Portfolio not found")));
      Navigator.pop(context);
    }
  }

  void _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile, String path) async {
    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _savePersonalDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    String? profilePictureUrl = currentProfileUrl;
    if (_imageFile != null) {
      profilePictureUrl = await _uploadImageToFirebase(
        _imageFile!,
        "profile_pictures/${user.uid}/${widget.portfolioId}",
      );
    }

    final ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}");

    await ref.update({
      "personalInfo/fullName": nameController.text.trim(),
      "personalInfo/aboutyourself": aboutController.text.trim(),
      "personalInfo/profilePicture": profilePictureUrl,
      "NoofSKills": noOfSkillsController.text.trim(),
      "MonthsofExperience": monthsOfExperienceController.text.trim(),
      "InternshipsCompleted": internshipsCompletedController.text.trim(),
      "NoofProjectsCompleted": noOfProjectsCompletedController.text.trim(),
    });

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
      "✅ Details Updated Successfully.",
      style: GoogleFonts.blinker(
        color: Colors.blue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),));
    Navigator.pop(context);
  }

  Widget _buildProfileImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Profile Picture",
        //   style: GoogleFonts.blinker(
        //     fontSize: 16,
        //     color: Colors.white70,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xff1E1E1E),
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (currentProfileUrl != null && currentProfileUrl!.isNotEmpty)
                      ? NetworkImage(currentProfileUrl!)
                      : AssetImage("assets/default-avatar.png") as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: Color(0xffe0eae5),
        title: Text(
          "Edit Personal Details",
          style: GoogleFonts.blinker(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildProfileImage(),
              SizedBox(height: 20),

              _buildTextField(
                controller: nameController,
                label: "Full Name",
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),

              _buildTextField(
                maxlines: 3,
                controller: aboutController,
                label: "About Yourself",
                validator: (value) => value!.isEmpty ? "Enter about section" : null,
              ),

              _buildTextField(
                controller: noOfSkillsController,
                label: "No. of Skills",
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Skills Count" : null,
              ),

              _buildTextField(
                controller: monthsOfExperienceController,
                label: "Months of Experience",
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Experience in Months" : null,
              ),

              _buildTextField(
                controller: internshipsCompletedController,
                label: "Internships Completed",
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Internship Count" : null,
              ),

              _buildTextField(
                controller: noOfProjectsCompletedController,
                label: "Projects Completed",
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Project Count" : null,
              ),

              SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _savePersonalDetails,
              icon: const Icon(Icons.save, color: Colors.white),
              label: Text(
                "Save Changes",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    maxlines,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxlines,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.blinker(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.blinker(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black54), // normal border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 1.5), // when focused
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5), // on error
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5), // focused + error
          ),
        ),

      ),
    );
  }
}
