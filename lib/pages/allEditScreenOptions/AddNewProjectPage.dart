// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AddNewProjectPage extends StatefulWidget {
//   const AddNewProjectPage({super.key});
//
//   @override
//   State<AddNewProjectPage> createState() => _AddNewProjectPageState();
// }
//
// class _AddNewProjectPageState extends State<AddNewProjectPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   String title = '';
//   String description = '';
//   String techStack = '';
//   String githubLink = '';
//   String youtubeLink = '';
//   File? imageFile;
//
//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         imageFile = File(picked.path);
//       });
//     }
//   }
//
//   void _submitProject() {
//     if (_formKey.currentState!.validate()) {
//       Map<String, dynamic> newProject = {
//         "title": title,
//         "description": description,
//         "techstack": techStack,
//         "projectgithublink": githubLink,
//         "projectyoutubelink": youtubeLink,
//         "image": imageFile,
//       };
//
//       Navigator.pop(context, newProject);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add New Project")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Title"),
//                 onChanged: (val) => title = val,
//                 validator: (val) => val!.isEmpty ? "Required" : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Description"),
//                 onChanged: (val) => description = val,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Tech Stack"),
//                 onChanged: (val) => techStack = val,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "GitHub Link"),
//                 onChanged: (val) => githubLink = val,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "YouTube Link"),
//                 onChanged: (val) => youtubeLink = val,
//               ),
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Column(
//                   children: [
//                     Icon(Icons.image, size: 40, color: Colors.blue),
//                     Text("Select Image"),
//                     if (imageFile != null) Image.file(imageFile!, height: 100),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _submitProject,
//                 child: Text("Add Project"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddNewProjectPage extends StatefulWidget {
  const AddNewProjectPage({super.key});

  @override
  State<AddNewProjectPage> createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String techStack = '';
  String githubLink = '';
  String youtubeLink = '';
  File? imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  void _submitProject() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newProject = {
        "title": title,
        "description": description,
        "techstack": techStack,
        "projectgithublink": githubLink,
        "projectyoutubelink": youtubeLink,
        "image": imageFile,
      };

      Navigator.pop(context, newProject);
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
        borderRadius: BorderRadius.circular(10),
      ),
    );
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
          "Add New Project",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("Title"),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? "Enter Title" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("Description"),
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? "Enter Description" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("Tech Stack"),
                onChanged: (val) => techStack = val,
                validator: (val) => val!.isEmpty ? "Enter Tech Stack" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("GitHub Link"),
                onChanged: (val) => githubLink = val,
                validator: (val) => val!.isEmpty ? "Enter Github Link" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("YouTube Link"),
                onChanged: (val) => youtubeLink = val,
                validator: (val) => val!.isEmpty ? "Enter Youtube Link" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: Text(
                      "Pick Image",
                      style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        imageFile!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitProject,
                  icon: const Icon(Icons.add, color: Colors.white, size: 22,),
                  label: Text(
                    "Add Project",
                    style: GoogleFonts.blinker(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}
