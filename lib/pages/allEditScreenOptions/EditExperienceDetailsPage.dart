// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// class EditExperienceDetailsPage extends StatefulWidget {
//   final String portfolioId;
//
//   const EditExperienceDetailsPage({Key? key, required this.portfolioId}) : super(key: key);
//
//   @override
//   _EditExperienceDetailsPageState createState() => _EditExperienceDetailsPageState();
// }
//
// class _EditExperienceDetailsPageState extends State<EditExperienceDetailsPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late DatabaseReference _experienceRef;
//
//   List<Map<String, String>> experienceList = [];
//
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _experienceRef = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/experiences");
//     _loadExperiences();
//   }
//
//   Future<void> _loadExperiences() async {
//     final snapshot = await _experienceRef.get();
//     if (snapshot.exists) {
//       List<Map<String, String>> loadedExperiences = [];
//       final data = List.from(snapshot.value as List);
//       for (var item in data) {
//         loadedExperiences.add({
//           "title": item["title"] ?? "",
//           "description": item["description"] ?? "",
//         });
//       }
//       setState(() {
//         experienceList = loadedExperiences;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         experienceList = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _saveExperiences() async {
//     await _experienceRef.set(experienceList);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Experiences updated")),
//     );
//     Navigator.pop(context); // Close the page
//   }
//
//   void _addExperience() {
//     String title = titleController.text.trim();
//     String desc = descriptionController.text.trim();
//     if (title.isNotEmpty && desc.isNotEmpty) {
//       setState(() {
//         experienceList.add({"title": title, "description": desc});
//         titleController.clear();
//         descriptionController.clear();
//       });
//     }
//   }
//
//   void _removeExperience(int index) {
//     setState(() {
//       experienceList.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Experiences"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveExperiences,
//             tooltip: "Save Changes",
//           )
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
//                   decoration: InputDecoration(labelText: "Experience Title"),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: "Description"),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _addExperience,
//                   child: Text("Add Experience"),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: experienceList.length,
//               itemBuilder: (context, index) {
//                 final exp = experienceList[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     title: Text(exp["title"] ?? ""),
//                     subtitle: Text(exp["description"] ?? ""),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _removeExperience(index),
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



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

    await _experienceRef.set(experienceList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text(
        "✅ Experience Updated",
        style: GoogleFonts.blinker(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),),
    );

    Navigator.pop(context);
  }


  void _addExperience() {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();
    if (title.isNotEmpty && desc.isNotEmpty) {
      setState(() {
        experienceList.add({"title": title, "description": desc});
        titleController.clear();
        descriptionController.clear();
      });
    }
  }

  void _removeExperience(int index) {
    setState(() {
      experienceList.removeAt(index);
    });
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
        elevation: 0,
        title: Text(
          "Edit Experiences",
          style: GoogleFonts.blinker(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.save, color: Color(0xfffaa629)),
          //   onPressed: _saveExperiences,
          //   tooltip: "Save Changes",
          // )
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: _saveExperiences,
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
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
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
                      labelText: "Experience Title",
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addExperience,
                      icon: const Icon(Icons.add, color: Colors.white, size: 23,),
                      label: Text(
                        "Add Experience",
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
          ),
          const SizedBox(height: 8),

          Expanded(
            child: experienceList.isEmpty
                ? const Center(
              child: Text(
                "No experiences added yet.",
                style: TextStyle(color: Colors.white60),
              ),
            )
                : ListView.builder(
              itemCount: experienceList.length,
              itemBuilder: (context, index) {
                final exp = experienceList[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      exp["title"] ?? "",
                      style: GoogleFonts.blinker(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        exp["description"] ?? "",
                        style: GoogleFonts.blinker(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeExperience(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
