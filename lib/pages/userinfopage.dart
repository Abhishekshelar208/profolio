import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:profolio/pages/designSelectionPage.dart';
import 'package:profolio/pages/portfoliolist.dart';
import 'package:profolio/pages/utils.dart';
import 'package:profolio/portfolioDesings/designone.dart';
import 'package:url_launcher/url_launcher.dart';

import '../portfolioDesings/designfour.dart';
import '../portfolioDesings/designthreee.dart';
import '../portfolioDesings/designtwo.dart';
import 'PaymentCodeVerificationPage.dart';
import 'VerifyDetailsPage.dart';
import 'loadingAnimation.dart';
import 'package:uuid/uuid.dart';

final List<Color> predefinedColors = [
  Colors.teal,
  Colors.teal,

];



class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key,required this.designName,required this.designPrice,});

  final String designName;
  final String designPrice;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  File? _achievementImageFile;
  File? _projectImageFile;
  File? _resumeFile;




  TextEditingController nameController = TextEditingController();
  TextEditingController aboutyourselfController = TextEditingController();
  TextEditingController useremailController = TextEditingController();
  TextEditingController graduationYearController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController achievementsController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController portfolioController = TextEditingController();
  TextEditingController toolsController = TextEditingController();
  TextEditingController achievementTitleController = TextEditingController();
  TextEditingController achievementDescriptionController = TextEditingController();
  TextEditingController softSkillsController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController facebookController = TextEditingController();

  TextEditingController projectTitleController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  TextEditingController techStackController = TextEditingController();
  TextEditingController githubLinkController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();


  TextEditingController experienceTitleController = TextEditingController();
  TextEditingController experienceDescriptionController = TextEditingController();


  TextEditingController monthofexperienceContoller = TextEditingController();
  TextEditingController InternshipCompletedContoller = TextEditingController();
  TextEditingController ProjectCompletedContoller = TextEditingController();
  TextEditingController NoofSkillsController = TextEditingController();



  List<String> skillsList = [];
  List<Color> skillColors = [];
  List<Map<String, dynamic>> achievementsList = [];
  List<Map<String, dynamic>> projectsList = [];
  List<Map<String, dynamic>> experienceList = [];

  List<String> softSkillsList = [];
  List<Color> softSkillsColors = [];
  int softSkillColorIndex = 0;

  bool isLoading = false;

  bool isVerified = false; // add this in your StatefulWidget class



  List<String> toolsList = [];
  List<Color> languageColors = [];
  int languageColorIndex = 0; // To keep track of which color to use for languages



  Future<void> _pickAchievementImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _achievementImageFile = File(pickedFile.path);
      });
    }
  }


  Future<void> _pickProjectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _projectImageFile = File(pickedFile.path);
      });
    }
  }


  void _addSoftSkill() {
    if (softSkillsController.text.isNotEmpty) {
      setState(() {
        // Add the soft skill to the list
        softSkillsList.add(softSkillsController.text);

        // Add the color from the predefinedColors list in sequence
        softSkillsColors.add(predefinedColors[softSkillColorIndex]);

        // Move to the next color, reset to 0 if the end of the list is reached
        softSkillColorIndex = (softSkillColorIndex + 1) % predefinedColors.length;

        // Clear the soft skill input field
        softSkillsController.clear();
      });
    }
  }


  void _addAchievement() {
    if (achievementTitleController.text.isNotEmpty) {
      setState(() {
        achievementsList.add({
          "title": achievementTitleController.text,
          "image": _achievementImageFile,
          "description": achievementDescriptionController.text,
        });

        // Clear the input fields after adding the achievement
        achievementTitleController.clear();
        achievementDescriptionController.clear();
        _achievementImageFile = null;
      });
    }
  }


  void _addProjects() {
    if (projectTitleController.text.isNotEmpty) {
      setState(() {
        projectsList.add({
          "title": projectTitleController.text,
          // Store the file if provided; if not, leave it as null
          "image": _projectImageFile,
          "description": projectDescriptionController.text,
          "techstack": techStackController.text,
          "projectgithublink": githubLinkController.text,
          "projectyoutubelink": youtubeLinkController.text,
        });

        // Clear the input fields after adding the project
        projectTitleController.clear();
        projectDescriptionController.clear();
        techStackController.clear();
        githubLinkController.clear();
        youtubeLinkController.clear();
        _projectImageFile = null;
      });
    }
  }

  void _addExperiences() {
    if (experienceTitleController.text.isNotEmpty) {
      setState(() {
        experienceList.add({
          "title": experienceTitleController.text,
          "description": experienceDescriptionController.text,
        });

        // Clear the input fields after adding the project
        experienceTitleController.clear();
        experienceDescriptionController.clear();
      });
    }
  }




  void _addTools() {
    if (toolsController.text.isNotEmpty) {
      setState(() {
        // Add the language text to the list
        toolsList.add(toolsController.text);

        // Add the color from the predefinedColors list in sequence
        languageColors.add(predefinedColors[languageColorIndex]);

        // Move to the next color, reset to 0 if the end of the list is reached
        languageColorIndex = (languageColorIndex + 1) % predefinedColors.length;

        // Clear the language input field
        toolsController.clear();
      });
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _pickResumeFile() async {
    // Allow only PDF files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker or no file was selected
      print("No file selected");
    }
  }




  int colorIndex = 0; // Declare a variable to track the color index

  void _addSkill() {
    if (skillsController.text.isNotEmpty) {
      setState(() {
        // Add the skill text to the list
        skillsList.add(skillsController.text);

        // Add the color from the predefinedColors list in sequence
        skillColors.add(predefinedColors[colorIndex]);

        // Move to the next color, reset to 0 if the end of the list is reached
        colorIndex = (colorIndex + 1) % predefinedColors.length;

        // Clear the skill input field
        skillsController.clear();
      });
    }
  }

  void _saveUserInfo() {
    if (_formKey.currentState!.validate()) {
      print("User Info Saved!");
      // Here you can add logic to save user info to a database or backend
    }
  }

  void saveUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in!")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Validate required fields
      List<String> missingFields = [];
      if (nameController.text.trim().isEmpty) missingFields.add("Name");
      if (aboutyourselfController.text.trim().isEmpty) missingFields.add("Degree");
      if (useremailController.text.trim().isEmpty) missingFields.add("University");
      if (graduationYearController.text.trim().isEmpty) missingFields.add("Graduation Year");
      if (_imageFile == null) missingFields.add("Profile Picture");
      if (_resumeFile == null) missingFields.add("Resume File");
      if (skillsList.isEmpty) missingFields.add("Skills");
      if (softSkillsList.isEmpty) missingFields.add("Soft Skills");
      if (toolsList.isEmpty) missingFields.add("Languages");
      if (achievementsList.isEmpty) missingFields.add("Achievements");
      if (experienceList.isEmpty) missingFields.add("Experiences");
      if (projectsList.isEmpty) missingFields.add("Projects");
      if (user.email!.trim().isEmpty) missingFields.add("Email");

      if (missingFields.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Missing required fields: ${missingFields.join(", ")}")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      String email = user.email!;
      String profilePictureUrl = "";
      String resumeFileUrl = "";

      //Portfolio Id Generation

      // DatabaseReference counterRef = FirebaseDatabase.instance.ref("portfolioCounter");
      // DataSnapshot snapshot = await counterRef.get();
      // int currentCounter = snapshot.exists ? snapshot.value as int : 0;
      // String portfolioId = "PortFolio${(currentCounter + 1).toString().padLeft(6, '0')}";

      var uuid = Uuid();
      String portfolioId = "PortFolio${uuid.v4().split('-').first}";


      // Upload profile picture if available
      if (_imageFile != null) {
        //profilePictureUrl = await _uploadImageToFirebase(_imageFile!, "profile_pictures/${user.uid}");
        profilePictureUrl = await _uploadImageToFirebase(_imageFile!, "profile_pictures/${user.uid}/$portfolioId");
      }

      // Upload resume file if available; ensure it's a PDF
      if (_resumeFile != null) {
        resumeFileUrl = await _uploadImageToFirebase(_resumeFile!, "resumes/${user.uid}");
        // Alternatively, if you have a separate function for file uploads:
        // resumeFileUrl = await _uploadFileToFirebase(_resumeFile!, "resumes/${user.uid}");
      }

      List<Map<String, dynamic>> uploadedAchievements = [];
      for (var achievement in achievementsList) {
        String imageUrl = "";
        if (achievement["image"] != null) {
          imageUrl = await _uploadImageToFirebase(
            achievement["image"],
            "achievements/${user.uid}/${achievement["title"]}",
          );
        }else {
          imageUrl = "https://www.infopedia.ai/no-image.png";
        }
        uploadedAchievements.add({
          "title": achievement["title"],
          "description": achievement["description"],
          "image": imageUrl,
        });
      }

      List<Map<String, dynamic>> uploadedProjects = [];
      for (var projects in projectsList) {
        String projectImageUrl = "";
        // If a file is provided, upload it; otherwise, use the default image asset path.
        if (projects["image"] != null) {
          projectImageUrl = await _uploadImageToFirebase(
            projects["image"],
            "achievements/${user.uid}/${projects["title"]}",
          );
        } else {
          projectImageUrl = "https://www.infopedia.ai/no-image.png";
        }
        uploadedProjects.add({
          "title": projects["title"],
          "description": projects["description"],
          "techstack": projects["techstack"],
          "projectgithublink": projects["projectgithublink"],
          "projectyoutubelink": projects["projectyoutubelink"],
          "image": projectImageUrl,
        });
      }

      List<Map<String, dynamic>> uploadexperiences = [];
      for (var experiences in experienceList) {
        uploadexperiences.add({
          "title": experiences["title"],
          "description": experiences["description"],
        });
      }


      DatabaseReference userRef = FirebaseDatabase.instance.ref("Portfolio/$portfolioId");

      Map<String, dynamic> userData = {
        "selectedDesign": widget.designName.toString(),
        "designPrice": widget.designPrice.toString(),
        "personalInfo": {
          "fullName": nameController.text.trim(),
          "aboutyourself": aboutyourselfController.text.trim(),
          "useremail": useremailController.text.trim(),
          "graduationYear": graduationYearController.text.trim(),
          "profilePicture": profilePictureUrl,
        },
        "NoofSKills": NoofSkillsController.text.trim(),
        "MonthsofExperience": monthofexperienceContoller.text.trim(),
        "InternshipsCompleted": InternshipCompletedContoller.text.trim(),
        "NoofProjectsCompleted": ProjectCompletedContoller.text.trim(),
        "skills": skillsList,
        "softSkills": softSkillsList,
        "tools": toolsList,
        "resumefile": resumeFileUrl,
        "achievements": uploadedAchievements,
        "experiences": uploadexperiences,
        "projects": uploadedProjects,
        "accountLinks": {
          "email": email.trim(),
          "linkedin": linkedinController.text.trim().isEmpty ? "https://www.linkedin.com/feed/" : linkedinController.text.trim(),
          "github": githubController.text.trim().isEmpty ? "https://github.com/" : githubController.text.trim(),
          "instagram": instagramController.text.trim().isEmpty ? "https://instagram.com/" : instagramController.text.trim(),
          "whatsapp": whatsappController.text.trim().isEmpty ? "https://web.whatsapp.com/" : whatsappController.text.trim(),
          "portfolio": portfolioController.text.trim(),
        },
      };

      await userRef.set(userData);
      // await counterRef.set(currentCounter + 1);


      Utils().toastMessage("Your Portfolio is created Successfully.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PortfolioListPage(),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



// Function to upload image to Firebase Storage and return download URL
  Future<String> _uploadImageToFirebase(File imageFile, String path) async {
    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "Create Portfolio",
          style: GoogleFonts.blinker(
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Personal Details", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(
                height: 10,
              ),
              _buildTextField(nameController, "Name", Icons.person,
                  isEnabled: false, // disables the field
                  defaultValue: "Ex: Abhishek Shelar", // sets default value
                  ),
              _buildTextField(aboutyourselfController, "About Yourself", Icons.book,
                isEnabled: false, // disables the field
                defaultValue: "Ex: I’m an enthusiastic engineering student passionate about technology and innovation. I enjoy solving real-world problems through creative thinking and teamwork. With a strong foundation in programming and project design, I’m eager to learn, grow, and contribute meaningfully. I thrive in dynamic environments and aim to make a positive impact.", // sets default value
              ),
              _buildTextField(useremailController, "Email", Icons.account_balance,
                isEnabled: false, // disables the field
                defaultValue: "Ex: youremail@gmail.com", // sets default value
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: false, // ✅ Disables the field
                controller: TextEditingController(text: "Ex: 98768986543"), // ✅ Sets default value
                style: GoogleFonts.blinker(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // controller: InternshipCompletedContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "No of Internship Completed",
                  labelStyle: GoogleFonts.blinker(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Color(0xff1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(graduationYearController, "Year of Graduation", Icons.date_range, keyboardType: TextInputType.number,
                isEnabled: false, // disables the field
                defaultValue: "Ex: 2028", // sets default value
              ),



              SizedBox(
                height: 50,
              ),
              Text("Skills Section", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(
                height: 15,
              ),
              TextFormField(
                enabled: false, // ✅ Disables the field
                controller: TextEditingController(text: "Ex: 8"), // ✅ Sets default value
                style: GoogleFonts.blinker(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // controller: NoofSkillsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "No of Skills",
                  labelStyle: GoogleFonts.blinker(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Color(0xff1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(skillsController, "Skills", Icons.star,
                      isEnabled: false, // disables the field
                      defaultValue: "Ex: Java", // sets default value
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue, size: 35),
                    onPressed: _addSkill,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(skillsList.length, (index) {
                  return Chip(
                    label: Text(skillsList[index],
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Apply the border radius here
                    ),
                    onDeleted: () {
                      setState(() {
                        skillsList.removeAt(index);
                        skillColors.removeAt(index);
                      });
                    },
                  );
                }),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(softSkillsController, "Soft Skills", Icons.accessibility,
                      isEnabled: false, // disables the field
                      defaultValue: "Ex: Communication", // sets default value
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue, size: 35),
                    onPressed: _addSoftSkill,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(softSkillsList.length, (index) {
                  return Chip(
                    label: Text(softSkillsList[index],
                      style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),),
                    // backgroundColor: softSkillsColors[index],  if you want multiple colors
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Apply the border radius here
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        softSkillsList.removeAt(index);
                        softSkillsColors.removeAt(index);
                      });
                    },
                  );
                }),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(toolsController, "Tools / Software Known", Icons.language,
                      isEnabled: false, // disables the field
                      defaultValue: "Ex: VS Code", // sets default value
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue, size: 35),
                    onPressed: _addTools,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(toolsList.length, (index) {
                  return Chip(
                    label: Text(toolsList[index],
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                    // backgroundColor: languageColors[index],
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Border radius of 100
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        toolsList.removeAt(index);
                        languageColors.removeAt(index);
                      });
                    },
                  );
                }),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Experience Section", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false, // ✅ Disables the field
                controller: TextEditingController(text: "Ex: 18"), // ✅ Sets default value
                style: GoogleFonts.blinker(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // controller: monthofexperienceContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Months of Experience',
                  labelStyle: GoogleFonts.blinker(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Color(0xff1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(experienceTitleController, "Experience Title", Icons.emoji_events,
                isEnabled: false, // disables the field
                defaultValue: "Ex: Internship at XYZ Tech Solutions", // sets default value
              ),
              _buildTextField(experienceDescriptionController, "Experience Description", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: Completed a 6-week internship focused on real-time software development. Gained hands-on experience in Flutter, Firebase, and UI/UX design. Collaborated on building a functional mobile app for task management. Learned teamwork, version control, and client communication while meeting tight deadlines and delivering quality outcomes.", // sets default value
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: _addExperiences,
                icon: Icon(Icons.add_circle, color: Colors.white, size: 25,),
                label: Text("Add Experience", style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
              SizedBox(height: 10,),

              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(experienceList.length, (index) {
                  return Chip(
                    label: Text(experienceList[index]["title"],
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        experienceList.removeAt(index);
                      });
                    },
                  );
                }),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Project Section", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false, // ✅ Disables the field
                controller: TextEditingController(text: "Ex: 5"), // ✅ Sets default value
                style: GoogleFonts.blinker(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // controller: ProjectCompletedContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'No of Project Completed',
                  labelStyle: GoogleFonts.blinker(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Color(0xff1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(projectTitleController, "Project Title", Icons.emoji_events,
                isEnabled: false, // disables the field
                defaultValue: "Ex: QR Based System", // sets default value
              ),
              _buildTextField(projectDescriptionController, "Project Description", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: Completed a 6-week project focused on real-time software development. Gained hands-on experience in Flutter, Firebase, and UI/UX design. Collaborated on building a functional mobile app for task management. Learned teamwork, version control, and client communication while meeting tight deadlines and delivering quality outcomes.", // sets default value
              ),
              _buildTextField(techStackController, "Tech Used", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: Java, Python, etc", // sets default value
              ),
              _buildTextField(githubLinkController, "Github Code link", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: https://www.github.com/username", // sets default value
              ),
              _buildTextField(youtubeLinkController, "Youtube Link", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: https://www.youtube.com/videotitle", // sets default value
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label: Text("Select Image", style: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),
                      icon: Icon(Icons.image, color: Colors.black54, size: 35),
                      onPressed: _pickProjectImage,
                    ),
                    _projectImageFile != null
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_projectImageFile!, height: 100, width: 100, fit: BoxFit.cover))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: _addProjects,
                icon: Icon(Icons.add_circle, color: Colors.white, size: 25,),
                label: Text("Add Project", style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
              SizedBox(height: 10,),

              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(projectsList.length, (index) {
                  return Chip(
                    label: Text(projectsList[index]["title"],
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        projectsList.removeAt(index);
                      });
                    },
                  );
                }),
              ),


              SizedBox(
                height: 50,
              ),
              Text("Achievement Section", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(
                height: 20,
              ),
              _buildTextField(achievementTitleController, "Achievement Title", Icons.emoji_events,
                isEnabled: false, // disables the field
                defaultValue: "Ex: First Rank in Diploma", // sets default value
              ),
              _buildTextField(achievementDescriptionController, "Achievement Description", Icons.description,
                isEnabled: false, // disables the field
                defaultValue: "Ex: In my diploma I secure First rank in Second and Third Year Engineering. I also get awarded by Principle Sir and HOD Sir of Information Technology of Saraswati College of Engineering. In my diploma I secure First rank in Second and Third Year Engineering. I also get awarded by Principle Sir and HOD Sir of Information Technology of Saraswati College of Engineering.", // sets default value
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label:  Text("Select Image", style: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),
                      icon: Icon(Icons.image, color: Colors.black54, size: 35),
                      onPressed: _pickAchievementImage,
                    ),
                    _achievementImageFile != null
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_achievementImageFile!, height: 100, width: 100, fit: BoxFit.cover))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              ElevatedButton.icon(
                onPressed: _addAchievement,
                icon: Icon(Icons.add_circle, color: Colors.white, size: 25,),
                label: Text("Add Achievement", style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
              SizedBox(height: 10,),






              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(achievementsList.length, (index) {
                  return Chip(
                    label: Text(achievementsList[index]["title"],
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        achievementsList.removeAt(index);
                      });
                    },
                  );
                }),
              ),

              SizedBox(
                height: 50,
              ),

              Text("Account Links", style: GoogleFonts.blinker(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              SizedBox(
                height: 20,
              ),

              _buildTextField(linkedinController, "LinkedIn", Icons.linked_camera,
                isEnabled: false, // disables the field
                defaultValue: "Ex: https://www.linkedin.com/username", // sets default value
              ),
              _buildTextField(githubController, "GitHub", Icons.code,
                isEnabled: false, // disables the field
                defaultValue: "Ex: https://www.Github.com/username", // sets default value
              ),
              _buildTextField(instagramController, "Instagram", Icons.code,
                isEnabled: false, // disables the field
                defaultValue: "Ex: https://www.instagram.com/username", // sets default value
              ),
              _buildTextField(whatsappController, "WhatsApp No", Icons.numbers,
                isEnabled: false, // disables the field
                defaultValue: "Ex: 98768986543", // sets default value
              ),

              FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label: Text("Select Resume", style: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),
                      icon: Icon(Icons.picture_as_pdf, color: Colors.black54, size: 35),
                      onPressed: _pickResumeFile, // Your function to pick a PDF file
                    ),
                    _resumeFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:  Center(
                        child: Text(
                          path.basename(_resumeFile!.path),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.blinker(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {

                  _addExperiences();
                  _addProjects();
                  _addAchievement();
                  _addSkill();
                  _addSoftSkill();
                  _addTools();
                  // Always open the verification page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyDetailsPage(
                        nameController: nameController,
                        aboutyourselfController: aboutyourselfController,
                        useremailController: useremailController,
                        graduationYearController: graduationYearController,
                        imageFile: _imageFile,
                        resumeFile: _resumeFile,
                        skillsList: skillsList,
                        softSkillsList: softSkillsList,
                        toolsList: toolsList,
                        achievementsList: achievementsList,
                        experienceList: experienceList,
                        projectsList: projectsList,
                        onVerificationComplete: (bool verified) {
                          setState(() {
                            isVerified = verified; // ✅ Only set true if all fields are filled
                          });
                        },
                      ),
                    ),
                  );

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AbsorbPointer( // Prevent manual tap on checkbox
                      child: Checkbox(
                        checkColor: Colors.blue,
                        value: isVerified,
                        onChanged: null, // Disable direct checkbox change
                      ),
                    ),
                    Text(
                      "Please verify the details",
                      style: GoogleFonts.blinker(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              if (isVerified) // ✅ Only show when verified
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentCodeVerificationPage(
                          designPrice: widget.designPrice,
                          onVerified: () => saveUserData(),
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  ),
                  child: Text(
                    "Create",
                    style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              SizedBox(height: 20,),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        bool isEmail = false,
        bool isEnabled = true, // <-- Add this parameter
        String? defaultValue,  // <-- Optional: allow default value
      }) {
    // Set default value if provided and controller is empty
    if (defaultValue != null && controller.text.isEmpty) {
      controller.text = defaultValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: isEnabled, // <-- Disable the field if false
        keyboardType: keyboardType,
        style: GoogleFonts.blinker(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        validator: (value) {
          if (!isEnabled) return null; // Skip validation if disabled
          if (value == null || value.isEmpty) {
            return "This field cannot be empty";
          }
          if (isEmail &&
              !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                  .hasMatch(value)) {
            return "Enter a valid email address";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: hint,
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

}






