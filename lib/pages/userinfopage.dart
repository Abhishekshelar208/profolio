import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;
import 'package:profolio/pages/designSelectionPage.dart';
import 'package:profolio/pages/portfoliolist.dart';
import 'package:profolio/pages/utils.dart';
import 'package:profolio/portfolioDesings/designone.dart';
import 'package:url_launcher/url_launcher.dart';

import '../portfolioDesings/designfour.dart';
import '../portfolioDesings/designthreee.dart';
import '../portfolioDesings/designtwo.dart';
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
  dynamic _imageFile;
  Uint8List? _profileBytes;
  dynamic _achievementImageFile;
  Uint8List? _achievementBytes;
  dynamic _projectImageFile;
  Uint8List? _projectBytes;
  dynamic _resumeFile;




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
  bool isVerified = true; // Set to true by default as we skip verification

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    nameController.text = "Your Full Name";
    aboutyourselfController.text = "I am a dedicated professional with a passion for excellence and a commitment to continuous learning. I enjoy taking on new challenges and collaborating with teams to achieve impactful results. With a solid foundation in my field, I strive to deliver high-quality work and contribute positively to every project I undertake.";
    useremailController.text = "your.email@example.com";
    graduationYearController.text = "202X";
    monthofexperienceContoller.text = "0";
    InternshipCompletedContoller.text = "0";
    ProjectCompletedContoller.text = "0";
    NoofSkillsController.text = "0";
    linkedinController.text = "https://www.linkedin.com/in/yourprofile";
    githubController.text = "https://github.com/yourusername";
    instagramController.text = "https://www.instagram.com/yourprofile";
    whatsappController.text = "911234567890";

    // Default lists
    skillsList = ["Skill 1", "Skill 2", "Skill 3", "Skill 4"];
    softSkillsList = ["Teamwork", "Problem Solving", "Communication"];
    toolsList = ["Tool 1", "Tool 2"];
    
    experienceList = [{
      "title": "Your Job Title / Position",
      "description": "Describe your key responsibilities and achievements in this role. Focus on the impact you made and the skills you utilized."
    }];

    projectsList = [{
      "title": "Your Project Title",
      "description": "Give a brief overview of your project, the problem it solves, and the technologies you used to build it.",
      "techstack": "Technology A, Technology B",
      "projectgithublink": "https://github.com/yourusername/project",
      "projectyoutubelink": "https://youtube.com/project_demo",
      "image": null
    }];

    achievementsList = [{
      "title": "Your Achievement Title",
      "description": "Describe your achievement or award in detail, highlighting why it was significant and what you earned.",
      "image": null
    }];
  }



  List<String> toolsList = [];
  List<Color> languageColors = [];
  int languageColorIndex = 0; // To keep track of which color to use for languages



  Future<void> _pickAchievementImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _achievementImageFile = pickedFile;
          _achievementBytes = bytes;
        });
      } else {
        setState(() {
          _achievementImageFile = pickedFile;
        });
      }
    }
  }


  Future<void> _pickProjectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _projectImageFile = pickedFile;
          _projectBytes = bytes;
        });
      } else {
        setState(() {
          _projectImageFile = pickedFile;
        });
      }
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
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _profileBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  // void _pickResumeFile() async {
  //   // Allow only PDF files
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     setState(() {
  //       _resumeFile = File(result.files.single.path!);
  //     });
  //   } else {
  //     // User canceled the picker or no file was selected
  //     print("No file selected");
  //   }
  // }

  void _pickResumeFile() async {
    // Allow only PDF files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final selectedFile = result.files.single;
      final int sizeInBytes = selectedFile.size;

      if (sizeInBytes <= 1024 * 1024) { // Check if file is ≤ 1MB
        setState(() {
          _resumeFile = selectedFile;
        });
      } else {
        // File too large: show a warning
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a PDF smaller than 1MB'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      // User canceled or no file selected
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




      // // 🔍 Check and update in ProFolioUsersLists
      // final usersListRef = FirebaseDatabase.instance.ref("ProFolioUsersLists");
      // final snapshot = await usersListRef.get();
      //
      // if (snapshot.exists) {
      //   final usersMap = Map<String, dynamic>.from(snapshot.value as Map);
      //
      //   usersMap.forEach((key, value) async {
      //     if ((value['EmailID'] ?? '').toString().toLowerCase() == email.toLowerCase()) {
      //       await usersListRef.child(key).update({
      //         "PortfolioID": portfolioId,
      //       });
      //     }
      //   });
      // }


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







// Function to upload image/file to Firebase Storage and return download URL
  Future<String> _uploadImageToFirebase(dynamic fileSource, String path) async {
    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask;
    if (kIsWeb) {
      if (fileSource is XFile) {
        uploadTask = storageRef.putData(await fileSource.readAsBytes());
      } else if (fileSource is PlatformFile) {
        uploadTask = storageRef.putData(fileSource.bytes!);
      } else {
        throw Exception("Unknown file type on web");
      }
    } else {
      if (fileSource is XFile) {
        uploadTask = storageRef.putFile(io.File(fileSource.path));
      } else if (fileSource is PlatformFile) {
        uploadTask = storageRef.putFile(io.File(fileSource.path!));
      } else if (fileSource is io.File) {
        uploadTask = storageRef.putFile(fileSource);
      } else {
        throw Exception("Unknown file type on mobile");
      }
    }
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: isLoading ? null : AppBar(
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "Create Portfolio",
          style: GoogleFonts.blinker(
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Container(
              color: Colors.white60,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'lib/assets/lottieAnimations/animationThree.json',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Creating your portfolio....",
                      style: GoogleFonts.blinker(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _imageFile != null
                      ? (kIsWeb
                          ? (_profileBytes != null
                              ? MemoryImage(_profileBytes!)
                              : null)
                          : (!kIsWeb && _imageFile is XFile)
                              ? FileImage(io.File(_imageFile.path))
                              : (!kIsWeb && _imageFile is io.File)
                                  ? FileImage(_imageFile as io.File)
                                  : null)
                      : null,
                  child: _imageFile == null
                      ? Image.asset("lib/assets/icons/user.png", color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Upload Your Media",
                style: GoogleFonts.blinker(
                  color: Colors.grey[800],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your details are pre-filled for convenience.",
                style: GoogleFonts.blinker(
                  color: Colors.blueGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              
              // Profile Picture Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _imageFile != null ? Icons.check_circle : Icons.circle_outlined,
                    color: _imageFile != null ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Profile Picture",
                    style: GoogleFonts.blinker(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Resume Picker
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 50),
                      onPressed: _pickResumeFile,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _resumeFile != null 
                        ? path.basename(_resumeFile!.path)
                        : "Upload Resume (PDF)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.blinker(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_resumeFile == null)
                      Text(
                        "Max size 1MB",
                        style: GoogleFonts.blinker(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_imageFile == null || _resumeFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please upload both Profile Picture and Resume")),
                      );
                      return;
                    }
                    saveUserData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: Text(
                    "Create Portfolio",
                    style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
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






