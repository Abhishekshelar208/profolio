import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profolio/pages/utils.dart';

class EditSkillsScreen extends StatefulWidget {
  final String portfolioId;

  const EditSkillsScreen({Key? key, required this.portfolioId}) : super(key: key);

  @override
  State<EditSkillsScreen> createState() => _EditSkillsScreenState();
}

class _EditSkillsScreenState extends State<EditSkillsScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> skillsList = [];
  List<String> softSkillsList = [];
  List<String> toolsList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        skillsList = List<String>.from(data["skills"] ?? []);
        softSkillsList = List<String>.from(data["softSkills"] ?? []);
        toolsList = List<String>.from(data["tools"] ?? []);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Portfolio not found",style: TextStyle(
          color: Colors.black
        ),)),
      );
      Navigator.pop(context);
    }
  }

  void _saveChanges() async {
    if (skillsList.isEmpty || softSkillsList.isEmpty || toolsList.isEmpty) {
      Utils().toastMessage('⚠️ Please add at least one item in all fields (Skills, Soft Skills, Tools).');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final ref = FirebaseDatabase.instance.ref("Portfolio/${widget.portfolioId}");
    await ref.update({
      "skills": skillsList,
      "softSkills": softSkillsList,
      "tools": toolsList,
    });

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "✅ Skills Updated Successfully.",
            style: GoogleFonts.blinker(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
    );
    Navigator.pop(context);
  }


  Widget _buildEditableList({
    required String title,
    required List<String> list,
    required void Function(String) onAdd,
    required void Function(int) onRemove,
  }) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.blinker(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: List.generate(
            list.length,
                (index) => Chip(
              label: Text(list[index]),
                  labelStyle: GoogleFonts.blinker(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
              backgroundColor: Colors.blue,
              deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white,),
              onDeleted: () => onRemove(index),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue,width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.blinker(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Add new $title",
                    hintStyle: GoogleFonts.blinker(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color
                  shape: BoxShape.circle, // Circular shape
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white), // White icon for contrast
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      onAdd(text);
                      controller.clear();
                    }
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe0eae5),
        elevation: 0,
        title: Text(
          "Edit Skills",
          style: GoogleFonts.blinker(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildEditableList(
                title: "Skills",
                list: skillsList,
                onAdd: (value) => setState(() => skillsList.add(value)),
                onRemove: (index) => setState(() => skillsList.removeAt(index)),
              ),
              _buildEditableList(
                title: "Soft Skills",
                list: softSkillsList,
                onAdd: (value) => setState(() => softSkillsList.add(value)),
                onRemove: (index) => setState(() => softSkillsList.removeAt(index)),
              ),
              _buildEditableList(
                title: "Tools / Languages",
                list: toolsList,
                onAdd: (value) => setState(() => toolsList.add(value)),
                onRemove: (index) => setState(() => toolsList.removeAt(index)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
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
}
