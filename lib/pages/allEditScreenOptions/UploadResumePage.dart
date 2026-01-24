// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class UploadResumePage extends StatefulWidget {
//   final String portfolioId;
//
//   const UploadResumePage({super.key, required this.portfolioId});
//
//   @override
//   State<UploadResumePage> createState() => _UploadResumePageState();
// }
//
// class _UploadResumePageState extends State<UploadResumePage> {
//   File? _resumeFile;
//   bool isLoading = false;
//   String? uploadedUrl;
//
//   Future<void> _pickResumeFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _resumeFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<String> _uploadFileToFirebase(File file, String path) async {
//     Reference storageRef = FirebaseStorage.instance.ref().child(path);
//     UploadTask uploadTask = storageRef.putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }
//
//   Future<void> _uploadResume() async {
//     if (_resumeFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a PDF file.")),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw Exception("User not logged in");
//
//       String downloadUrl = await _uploadFileToFirebase(
//         _resumeFile!,
//         "resumes/${user.uid}/${widget.portfolioId}.pdf",
//       );
//
//       DatabaseReference ref = FirebaseDatabase.instance
//           .ref("Portfolio/${widget.portfolioId}/resumefile");
//
//       await ref.set(downloadUrl);
//
//       setState(() {
//         uploadedUrl = downloadUrl;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Resume uploaded successfully!")),
//       );
//
//       Navigator.pop(context); // Go back after success
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Upload failed: ${e.toString()}")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Widget _fileInfo() {
//     if (_resumeFile != null) {
//       return Text("Selected file: ${_resumeFile!.path.split('/').last}");
//     } else {
//       return Text("No file selected");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload Resume"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.cloud_upload),
//             onPressed: _uploadResume,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton.icon(
//               onPressed: _pickResumeFile,
//               icon: Icon(Icons.attach_file),
//               label: Text("Select Resume (PDF)"),
//             ),
//             SizedBox(height: 12),
//             _fileInfo(),
//             if (uploadedUrl != null) ...[
//               SizedBox(height: 20),
//               Text("Resume Uploaded:"),
//               SelectableText(uploadedUrl!),
//             ],
//             if (isLoading) CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;

class UploadResumePage extends StatefulWidget {
  final String portfolioId;

  const UploadResumePage({super.key, required this.portfolioId});

  @override
  State<UploadResumePage> createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  dynamic _resumeFile;
  bool isLoading = false;
  String? uploadedUrl;

  Future<void> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final selectedFile = result.files.single;
      final int sizeInBytes = selectedFile.size;
      final double sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ Pdf Must be less than 1 Mb",
              style: GoogleFonts.blinker(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        return;
      }

      setState(() {
        _resumeFile = selectedFile;
      });
    }
  }


  Future<String> _uploadFileToFirebase(dynamic fileSource, String path) async {
    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask;
    if (kIsWeb) {
      final PlatformFile platformFile = fileSource as PlatformFile;
      uploadTask = storageRef.putData(platformFile.bytes!);
    } else {
      final PlatformFile platformFile = fileSource as PlatformFile;
      uploadTask = storageRef.putFile(io.File(platformFile.path!));
    }
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _uploadResume() async {
    if (_resumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a PDF file.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      String downloadUrl = await _uploadFileToFirebase(
        _resumeFile!,
        "resumes/${user.uid}/${widget.portfolioId}.pdf",
      );

      DatabaseReference ref = FirebaseDatabase.instance
          .ref("Portfolio/${widget.portfolioId}/resumefile");

      await ref.set(downloadUrl);

      setState(() => uploadedUrl = downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "✅ Resume Uploaded Successfully!",
              style: GoogleFonts.blinker(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _fileInfo() {
    String fileName = "No file selected";
    if (_resumeFile != null) {
      if (kIsWeb) {
        fileName = "Selected file: ${(_resumeFile as PlatformFile).name}";
      } else {
        fileName = "Selected file: ${(_resumeFile as PlatformFile).name}";
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        fileName,
        style: GoogleFonts.blinker(
          color: Colors.black,
          fontSize: 16,
        ),
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
          "Upload Resume",
          style: GoogleFonts.blinker(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: _uploadResume,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              ),
              child: Text(
                "Upload",
                style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickResumeFile,
              icon: const Icon(Icons.attach_file, color: Colors.white),
              label: Text(
                "Select Resume (PDF)",
                style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            _fileInfo(),
            const SizedBox(height: 20),
            if (uploadedUrl != null) ...[
              Text(
                "Resume Uploaded:",
                style: GoogleFonts.blinker(
                  color: Color(0xfffaa629),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                uploadedUrl!,
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
