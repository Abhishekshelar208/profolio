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
  const UserInfoPage({super.key,required this.designName});

  final String designName;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User data saved successfully!")),
      );

      Widget selectedPage;
      if (widget.designName == "DesignOne") {
        selectedPage = DesignOne(userData: userData, );
      } else if (widget.designName == "DesignTwo") {
        selectedPage = DesignTwo(userData: userData, );
      } else if (widget.designName == "DesignThree") {
        selectedPage = DesignThree(userData: userData);
      } else if (widget.designName == "DesignFour") {
        selectedPage = DesignFour(userData: userData);
      } else {
        // Fallback to a default design page if none match
        selectedPage = DesignOne(userData: userData,);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => selectedPage,
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
      appBar: AppBar(title: Text("Create Portfolio"),centerTitle: true,),
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
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _buildTextField(nameController, "Name", Icons.person),
              _buildTextField(aboutyourselfController, "About Yourself", Icons.book),
              _buildTextField(useremailController, "Email", Icons.account_balance),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: InternshipCompletedContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined, color: Colors.teal),
                  hintText: 'No of Internship Completed',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(graduationYearController, "Year of Graduation", Icons.date_range, keyboardType: TextInputType.number),



              SizedBox(
                height: 20,
              ),
              Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: NoofSkillsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined, color: Colors.teal),
                  hintText: 'No of Skills',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(skillsController, "Skills", Icons.star),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                    onPressed: _addSkill,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(skillsList.length, (index) {
                  return Chip(
                    label: Text(skillsList[index], style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.teal,
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
                    child: _buildTextField(softSkillsController, "Soft Skills", Icons.accessibility),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                    onPressed: _addSoftSkill,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(softSkillsList.length, (index) {
                  return Chip(
                    label: Text(softSkillsList[index], style: TextStyle(color: Colors.white)),
                    // backgroundColor: softSkillsColors[index],  if you want multiple colors
                    backgroundColor: Colors.teal,
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
                    child: _buildTextField(toolsController, "Tools / Software Known", Icons.language),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                    onPressed: _addTools,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(toolsList.length, (index) {
                  return Chip(
                    label: Text(toolsList[index], style: TextStyle(color: Colors.white)),
                    // backgroundColor: languageColors[index],
                    backgroundColor: Colors.teal,
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
                height: 20,
              ),
              Text("Experiences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: monthofexperienceContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined, color: Colors.teal),
                  hintText: 'Months of Experience',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(experienceTitleController, "Experience Title", Icons.emoji_events),
              _buildTextField(experienceDescriptionController, "Experience Description", Icons.description),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                onPressed: _addExperiences,
              ),

              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(experienceList.length, (index) {
                  return Chip(
                    label: Text(experienceList[index]["title"], style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.teal,
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
                height: 20,
              ),
              Text("Projects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ProjectCompletedContoller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined, color: Colors.teal),
                  hintText: 'No of Projects Completed',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextField(projectTitleController, "Project Title", Icons.emoji_events),
              _buildTextField(projectDescriptionController, "Project Description", Icons.description),
              _buildTextField(techStackController, "Tech Used", Icons.description),
              _buildTextField(githubLinkController, "Github Code link", Icons.description),
              _buildTextField(youtubeLinkController, "Youtube Link", Icons.description),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label: Text("Upload Project Image"),
                      icon: Icon(Icons.image, color: Colors.teal, size: 35),
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
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                onPressed: _addProjects,
              ),

              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(projectsList.length, (index) {
                  return Chip(
                    label: Text(projectsList[index]["title"], style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.teal,
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
                height: 20,
              ),
              Text("Achievement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField(achievementTitleController, "Achievement Title", Icons.emoji_events),
              _buildTextField(achievementDescriptionController, "Achievement Description", Icons.description),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label: Text("Upload Achievement Image"),
                      icon: Icon(Icons.image, color: Colors.teal, size: 35),
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
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.teal, size: 35),
                onPressed: _addAchievement,
              ),




              // Displaying added achievements as chips
              Wrap(
                spacing: 8,
                children: List.generate(achievementsList.length, (index) {
                  return Chip(
                    label: Text(achievementsList[index]["title"], style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.teal,
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
                height: 20,
              ),

              Text("Account Links", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              _buildTextField(linkedinController, "LinkedIn", Icons.linked_camera),
              _buildTextField(githubController, "GitHub", Icons.code),
              _buildTextField(instagramController, "Instagram", Icons.code),
              _buildTextField(whatsappController, "WhatsApp No", Icons.numbers),

              FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      label: Text("Upload Resume"),
                      icon: Icon(Icons.picture_as_pdf, color: Colors.teal, size: 35),
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
                            color: Colors.white60,
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        onFinish: () {
                          saveUserData();
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Create"),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field cannot be empty";
          }
          if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\$").hasMatch(value)) {
            return "Enter a valid email address";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}





