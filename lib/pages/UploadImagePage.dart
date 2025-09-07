import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _imageFile;
  bool _isLoading = false;
  String? _existingKey; // For tracking existing image

  final picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();
  final dbRef = FirebaseDatabase.instance.ref().child("UploadedImages");

  @override
  void initState() {
    super.initState();
    _fetchExistingImageKey();
  }

  Future<void> _fetchExistingImageKey() async {
    final snapshot = await dbRef.limitToLast(1).get();
    if (snapshot.exists) {
      setState(() {
        _existingKey = (snapshot.children.first.key);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String fileName = "main_uploaded_image"; // Fixed filename to overwrite
      final ref = storageRef.child("images/$fileName.jpg");

      await ref.putFile(_imageFile!);
      String downloadUrl = await ref.getDownloadURL();

      if (_existingKey != null) {
        // Update existing entry
        await dbRef.child(_existingKey!).set({
          "imageUrl": downloadUrl,
          "uploadedAt": DateTime.now().toIso8601String(),
        });
      } else {
        // Create new entry
        DatabaseReference newRef = dbRef.push();
        await newRef.set({
          "imageUrl": downloadUrl,
          "uploadedAt": DateTime.now().toIso8601String(),
        });
        _existingKey = newRef.key; // update local key
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );

      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCurrentImage() {
    return FutureBuilder<DataSnapshot>(
      future: dbRef.orderByKey().limitToLast(1).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data?.value == null) {
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 80, color: Colors.grey),
            ),
          );
        } else {
          Map data = snapshot.data!.value as Map;
          MapEntry entry = data.entries.first;
          String imageUrl = entry.value["imageUrl"];
          _existingKey = entry.key; // Save key for future updates

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Upload Payment Qr Image",
          style: GoogleFonts.blinker(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCurrentImage(),
            const SizedBox(height: 20),
            _imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _imageFile!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.image, color: Colors.white,),
              label: Text(
                "Select Image",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: _isLoading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.upload, color: Colors.white,),
              label: Text(
                "Upload Image",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: _isLoading ? null : _uploadImage,
            ),
          ],
        ),
      ),
    );
  }
}

