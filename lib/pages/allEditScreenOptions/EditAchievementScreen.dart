// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class EditAchievementScreen extends StatefulWidget {
//   final String portfolioId;
//
//   const EditAchievementScreen({Key? key, required this.portfolioId}) : super(key: key);
//
//   @override
//   State<EditAchievementScreen> createState() => _EditAchievementScreenState();
// }
//
// class _EditAchievementScreenState extends State<EditAchievementScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late DatabaseReference _achievementRef;
//
//   List<Map<String, dynamic>> achievementsList = [];
//
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//
//   File? _selectedImage;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _achievementRef = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/achievements");
//     _loadAchievements();
//   }
//
//   Future<void> _loadAchievements() async {
//     final snapshot = await _achievementRef.get();
//     if (snapshot.exists) {
//       List<Map<String, dynamic>> loaded = [];
//       final data = List.from(snapshot.value as List);
//       for (var item in data) {
//         loaded.add({
//           "title": item["title"] ?? "",
//           "description": item["description"] ?? "",
//           "image": item["image"] ?? "",
//         });
//       }
//       setState(() {
//         achievementsList = loaded;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         achievementsList = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _selectedImage = File(picked.path);
//       });
//     }
//   }
//
//   Future<String> _uploadImage(File imageFile, String title) async {
//     final user = _auth.currentUser;
//     final ref = FirebaseStorage.instance
//         .ref()
//         .child('achievements/${user!.uid}/$title');
//     final uploadTask = ref.putFile(imageFile);
//     final snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }
//
//   void _addAchievement() {
//     String title = titleController.text.trim();
//     String desc = descriptionController.text.trim();
//     if (title.isNotEmpty && desc.isNotEmpty) {
//       setState(() {
//         achievementsList.add({
//           "title": title,
//           "description": desc,
//           "image": _selectedImage ?? "", // File uploaded on save
//         });
//         titleController.clear();
//         descriptionController.clear();
//         _selectedImage = null;
//       });
//     }
//   }
//
//   void _removeAchievement(int index) {
//     setState(() {
//       achievementsList.removeAt(index);
//     });
//   }
//
//   Future<void> _saveAchievements() async {
//     setState(() => isLoading = true);
//
//     final user = _auth.currentUser;
//     List<Map<String, dynamic>> finalAchievements = [];
//
//     for (var ach in achievementsList) {
//       String imageUrl = "";
//
//       if (ach["image"] is File) {
//         imageUrl = await _uploadImage(ach["image"], ach["title"]);
//       } else if (ach["image"].toString().startsWith("http")) {
//         imageUrl = ach["image"];
//       } else {
//         imageUrl = "https://www.infopedia.ai/no-image.png";
//       }
//
//       finalAchievements.add({
//         "title": ach["title"],
//         "description": ach["description"],
//         "image": imageUrl,
//       });
//     }
//
//     await _achievementRef.set(finalAchievements);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Achievements updated")),
//     );
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Achievements"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveAchievements,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(labelText: "Title"),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: "Description"),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.image),
//                       label: Text("Pick Image"),
//                       onPressed: _pickImage,
//                     ),
//                     SizedBox(width: 10),
//                     _selectedImage != null
//                         ? Image.file(_selectedImage!, width: 50, height: 50)
//                         : SizedBox(),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _addAchievement,
//                   child: Text("Add Achievement"),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: achievementsList.length,
//               itemBuilder: (context, index) {
//                 final ach = achievementsList[index];
//                 return Card(
//                   child: ListTile(
//                     leading: ach["image"] is File
//                         ? Image.file(ach["image"], width: 40, height: 40)
//                         : Image.network(ach["image"], width: 40, height: 40, errorBuilder: (_, __, ___) => Icon(Icons.image)),
//                     title: Text(ach["title"] ?? ""),
//                     subtitle: Text(ach["description"] ?? ""),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _removeAchievement(index),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

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

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? _selectedImage;
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

  Future<void> _pickImage({int? index}) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (index != null) {
          achievementsList[index]["image"] = File(picked.path);
        } else {
          _selectedImage = File(picked.path);
        }
      });
    }
  }


  Future<String> _uploadImage(File imageFile, String title) async {
    final user = _auth.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('achievements/${user!.uid}/$title');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _addAchievement() {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();
    if (title.isNotEmpty && desc.isNotEmpty) {
      setState(() {
        achievementsList.add({
          "title": title,
          "description": desc,
          "image": _selectedImage ?? "",
        });
        titleController.clear();
        descriptionController.clear();
        _selectedImage = null;
      });
    }
  }

  void _removeAchievement(int index) {
    setState(() {
      achievementsList.removeAt(index);
    });
  }

  Future<void> _saveAchievements() async {
    if (achievementsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one achievement before saving.")),
      );
      return;
    }

    for (var ach in achievementsList) {
      if ((ach["title"]?.toString().trim().isEmpty ?? true) ||
          (ach["description"]?.toString().trim().isEmpty ?? true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All achievements must have title and description.")),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    final user = _auth.currentUser;
    List<Map<String, dynamic>> finalAchievements = [];

    for (var ach in achievementsList) {
      String imageUrl = "";

      if (ach["image"] is File) {
        imageUrl = await _uploadImage(ach["image"], ach["title"]);
      } else if (ach["image"].toString().startsWith("http")) {
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
        "✅ Achievement Updated Successfully.",
        style: GoogleFonts.blinker(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "Edit Achievements",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: _saveAchievements,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical:4),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,

                    style: GoogleFonts.blinker(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(

                      labelText: "Achievement Title",
                      labelStyle: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    style: GoogleFonts.blinker(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle:  GoogleFonts.blinker(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: Text("Pick Image",
                          style: GoogleFonts.blinker(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 10),
                      _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addAchievement,
                      icon: const Icon(Icons.add, color: Colors.white, size: 25,),
                      label: Text(
                        "Add Achievement",
                        style: GoogleFonts.blinker(
                          fontSize: 18,
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: achievementsList.length,
                itemBuilder: (context, index) {
                  final ach = achievementsList[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => _pickImage(index: index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ach["image"] is File
                              ? Image.file(
                            ach["image"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            ach["image"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image),
                          ),
                        ),

                      ),

                      title: Text(
                        ach["title"] ?? "",
                        style: GoogleFonts.blinker(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          ach["description"] ?? "",
                          style: GoogleFonts.blinker(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeAchievement(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xff2c2c2c),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

