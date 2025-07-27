// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// import 'AddNewProjectPage.dart';
//
// class EditProjectScreen extends StatefulWidget {
//   final String portfolioId;
//
//   const EditProjectScreen({Key? key, required this.portfolioId}) : super(key: key);
//
//   @override
//   _EditProjectScreenState createState() => _EditProjectScreenState();
// }
//
// class _EditProjectScreenState extends State<EditProjectScreen> {
//   List<Map<String, dynamic>> projects = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProjects();
//   }
//
//   Future<void> _fetchProjects() async {
//     DatabaseReference ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/projects");
//     final snapshot = await ref.get();
//     if (snapshot.exists) {
//       final data = snapshot.value as List<dynamic>;
//       projects = data.map((e) => Map<String, dynamic>.from(e)).toList();
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _pickImage(int index) async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         projects[index]['image'] = File(picked.path);
//       });
//     }
//   }
//
//   Future<void> _addProject() async {
//     final newProject = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => AddNewProjectPage()),
//     );
//     if (newProject != null && newProject is Map<String, dynamic>) {
//       setState(() {
//         projects.add(newProject);
//       });
//     }
//   }
//
//   void _removeProject(int index) {
//     setState(() {
//       projects.removeAt(index);
//     });
//   }
//
//   Future<String> _uploadImageToFirebase(File imageFile, String path) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     final task = ref.putFile(imageFile);
//     final snapshot = await task;
//     return await snapshot.ref.getDownloadURL();
//   }
//
//   Future<void> _saveProjects() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     List<Map<String, dynamic>> finalProjects = [];
//
//     for (var project in projects) {
//       String imageUrl = project["image"] is File
//           ? await _uploadImageToFirebase(
//           project["image"],
//           "projects/${widget.portfolioId}/${project["title"]}")
//           : project["image"]?.toString() ?? "https://www.infopedia.ai/no-image.png";
//
//       finalProjects.add({
//         "title": project["title"],
//         "description": project["description"],
//         "techstack": project["techstack"],
//         "projectgithublink": project["projectgithublink"],
//         "projectyoutubelink": project["projectyoutubelink"],
//         "image": imageUrl,
//       });
//     }
//
//     await FirebaseDatabase.instance
//         .ref("Portfolio/${widget.portfolioId}/projects")
//         .set(finalProjects);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Projects updated successfully!")),
//     );
//
//     setState(() {
//       isLoading = false;
//     });
//     Navigator.pop(context);
//   }
//
//   Widget _buildProjectCard(int index) {
//     final project = projects[index];
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextFormField(
//               initialValue: project["title"],
//               decoration: InputDecoration(labelText: "Project Title"),
//               onChanged: (val) => project["title"] = val,
//             ),
//             TextFormField(
//               initialValue: project["description"],
//               decoration: InputDecoration(labelText: "Description"),
//               onChanged: (val) => project["description"] = val,
//             ),
//             TextFormField(
//               initialValue: project["techstack"],
//               decoration: InputDecoration(labelText: "Tech Stack"),
//               onChanged: (val) => project["techstack"] = val,
//             ),
//             TextFormField(
//               initialValue: project["projectgithublink"],
//               decoration: InputDecoration(labelText: "GitHub Link"),
//               onChanged: (val) => project["projectgithublink"] = val,
//             ),
//             TextFormField(
//               initialValue: project["projectyoutubelink"],
//               decoration: InputDecoration(labelText: "YouTube Link"),
//               onChanged: (val) => project["projectyoutubelink"] = val,
//             ),
//             const SizedBox(height: 12),
//             GestureDetector(
//               onTap: () => _pickImage(index),
//               child: Column(
//                 children: [
//                   Icon(Icons.image, size: 40, color: Colors.blueAccent),
//                   Text("Select Image", style: TextStyle(color: Colors.blueAccent)),
//                   SizedBox(height: 8),
//                   if (project["image"] != null)
//                     (project["image"] is File)
//                         ? Image.file(project["image"], height: 100)
//                         : Image.network(project["image"], height: 100),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: () => _removeProject(index),
//               icon: Icon(Icons.delete),
//               label: Text("Remove Project"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Projects"),
//         actions: [
//           IconButton(onPressed: _addProject, icon: Icon(Icons.add)),
//           IconButton(onPressed: _saveProjects, icon: Icon(Icons.save)),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : projects.isEmpty
//           ? Center(child: Text("No projects yet. Click + to add one."))
//           : ListView.builder(
//         itemCount: projects.length,
//         itemBuilder: (context, index) => _buildProjectCard(index),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils.dart';
import 'AddNewProjectPage.dart';

class EditProjectScreen extends StatefulWidget {
  final String portfolioId;

  const EditProjectScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}/projects");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.value as List<dynamic>;
      projects = data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage(int index) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        projects[index]['image'] = File(picked.path);
      });
    }
  }

  Future<void> _addProject() async {
    final newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNewProjectPage()),
    );
    if (newProject != null && newProject is Map<String, dynamic>) {
      setState(() {
        projects.add(newProject);
      });
    }
  }

  void _removeProject(int index) {
    setState(() {
      projects.removeAt(index);
    });
  }

  Future<String> _uploadImageToFirebase(File imageFile, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final task = ref.putFile(imageFile);
    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  // Future<void> _saveProjects() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   List<Map<String, dynamic>> finalProjects = [];
  //
  //   for (var project in projects) {
  //     String imageUrl = project["image"] is File
  //         ? await _uploadImageToFirebase(
  //         project["image"],
  //         "projects/${widget.portfolioId}/${project["title"]}")
  //         : project["image"]?.toString() ?? "https://www.infopedia.ai/no-image.png";
  //
  //     finalProjects.add({
  //       "title": project["title"],
  //       "description": project["description"],
  //       "techstack": project["techstack"],
  //       "projectgithublink": project["projectgithublink"],
  //       "projectyoutubelink": project["projectyoutubelink"],
  //       "image": imageUrl,
  //     });
  //   }
  //
  //   await FirebaseDatabase.instance
  //       .ref("Portfolio/${widget.portfolioId}/projects")
  //       .set(finalProjects);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Projects updated successfully!")),
  //   );
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //   Navigator.pop(context);
  // }

  Future<void> _saveProjects() async {
    if (projects.isEmpty) {
      Utils().toastMessage('⚠️ Please add at least one project before saving.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> finalProjects = [];

    for (var project in projects) {
      String imageUrl = project["image"] is File
          ? await _uploadImageToFirebase(
          project["image"],
          "projects/${widget.portfolioId}/${project["title"]}")
          : project["image"]?.toString() ?? "https://www.infopedia.ai/no-image.png";

      finalProjects.add({
        "title": project["title"],
        "description": project["description"],
        "techstack": project["techstack"],
        "projectgithublink": project["projectgithublink"],
        "projectyoutubelink": project["projectyoutubelink"],
        "image": imageUrl,
      });
    }

    await FirebaseDatabase.instance
        .ref("Portfolio/${widget.portfolioId}/projects")
        .set(finalProjects);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "✅ Project Updated Successfully.",
            style: GoogleFonts.blinker(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
    );

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
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
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    final project = projects[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorColor: Colors.blue,
            initialValue: project["title"],
            decoration: _inputDecoration("Project Title"),
            style: GoogleFonts.blinker(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (val) => project["title"] = val,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: project["description"],
            decoration: _inputDecoration("Description"),
            style: GoogleFonts.blinker(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (val) => project["description"] = val,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: project["techstack"],
            decoration: _inputDecoration("Tech Stack"),
            style: GoogleFonts.blinker(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
            onChanged: (val) => project["techstack"] = val,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: project["projectgithublink"],
            decoration: _inputDecoration("GitHub Link"),
            style: GoogleFonts.blinker(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (val) => project["projectgithublink"] = val,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: project["projectyoutubelink"],
            decoration: _inputDecoration("YouTube Link"),
            style: GoogleFonts.blinker(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (val) => project["projectyoutubelink"] = val,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _pickImage(index),
            child: Row(
              children: [
                const Icon(Icons.image, size: 35, color: Colors.blue),
                const SizedBox(width: 2),
                Text(
                  "Select Image",
                  style: GoogleFonts.blinker(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 20),
                if (project["image"] != null)
                  (project["image"] is File)
                      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(project["image"], height: 50))
                      : ClipRRect(borderRadius: BorderRadius.circular(8), child:  Image.network(project["image"], height: 50)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _removeProject(index),
              icon: const Icon(Icons.delete, color: Colors.white),
              label: Text(
                "Remove Project",
                style: GoogleFonts.blinker(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
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
          "Edit Projects",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue, // Background color (same as icon color)
              shape: BoxShape.circle,   // Make it circular
            ),
            child: IconButton(
              onPressed: _addProject,
              icon: const Icon(Icons.add, color: Colors.white), // White icon for contrast
            ),
          ),
          SizedBox(width: 3,),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _saveProjects,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.blinker(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : projects.isEmpty
          ? const Center(
        child: Text(
          "No projects yet. Click + to add one.",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) => _buildProjectCard(index),
      ),
    );
  }
}
