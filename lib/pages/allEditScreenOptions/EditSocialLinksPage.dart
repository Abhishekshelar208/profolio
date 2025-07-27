// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class EditSocialLinksPage extends StatefulWidget {
//   final String portfolioId;
//
//   const EditSocialLinksPage({Key? key, required this.portfolioId}) : super(key: key);
//
//   @override
//   _EditSocialLinksPageState createState() => _EditSocialLinksPageState();
// }
//
// class _EditSocialLinksPageState extends State<EditSocialLinksPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _linkedinController = TextEditingController();
//   final TextEditingController _githubController = TextEditingController();
//   final TextEditingController _instagramController = TextEditingController();
//   final TextEditingController _whatsappController = TextEditingController();
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSocialLinks();
//   }
//
//   Future<void> _loadSocialLinks() async {
//     final ref = FirebaseDatabase.instance
//         .ref("Portfolio/${widget.portfolioId}/accountLinks");
//     final snapshot = await ref.get();
//
//     if (snapshot.exists) {
//       final data = Map<String, dynamic>.from(snapshot.value as Map);
//       _linkedinController.text = data["linkedin"] ?? "";
//       _githubController.text = data["github"] ?? "";
//       _instagramController.text = data["instagram"] ?? "";
//       _whatsappController.text = data["whatsapp"] ?? "";
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _saveSocialLinks() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final ref = FirebaseDatabase.instance
//         .ref("Portfolio/${widget.portfolioId}/accountLinks");
//
//     await ref.update({
//       "linkedin": _linkedinController.text.trim(),
//       "github": _githubController.text.trim(),
//       "instagram": _instagramController.text.trim(),
//       "whatsapp": _whatsappController.text.trim(),
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Social links updated successfully!")),
//     );
//
//     Navigator.pop(context);
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       validator: (val) => val == null || val.isEmpty ? "Required" : null,
//     );
//   }
//
//   @override
//   void dispose() {
//     _linkedinController.dispose();
//     _githubController.dispose();
//     _instagramController.dispose();
//     _whatsappController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Social Links"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveSocialLinks,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _buildTextField("LinkedIn Link", _linkedinController),
//               _buildTextField("GitHub Link", _githubController),
//               _buildTextField("Instagram link", _instagramController),
//               _buildTextField("WhatsApp No", _whatsappController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSocialLinksPage extends StatefulWidget {
  final String portfolioId;

  const EditSocialLinksPage({Key? key, required this.portfolioId}) : super(key: key);

  @override
  _EditSocialLinksPageState createState() => _EditSocialLinksPageState();
}

class _EditSocialLinksPageState extends State<EditSocialLinksPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSocialLinks();
  }

  Future<void> _loadSocialLinks() async {
    final ref = FirebaseDatabase.instance
        .ref("Portfolio/${widget.portfolioId}/accountLinks");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      _linkedinController.text = data["linkedin"] ?? "";
      _githubController.text = data["github"] ?? "";
      _instagramController.text = data["instagram"] ?? "";
      _whatsappController.text = data["whatsapp"] ?? "";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveSocialLinks() async {
    if (!_formKey.currentState!.validate()) return;

    final ref = FirebaseDatabase.instance
        .ref("Portfolio/${widget.portfolioId}/accountLinks");

    await ref.update({
      "linkedin": _linkedinController.text.trim(),
      "github": _githubController.text.trim(),
      "instagram": _instagramController.text.trim(),
      "whatsapp": _whatsappController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
        "✅ Social links updated successfully!",
        style: GoogleFonts.blinker(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),),
    );

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
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        style: GoogleFonts.blinker(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: _inputDecoration(label),
      ),
    );
  }

  @override
  void dispose() {
    _linkedinController.dispose();
    _githubController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    super.dispose();
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
          "Edit Social Links",
          style: GoogleFonts.blinker(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: _saveSocialLinks,
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xfffaa629)),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("LinkedIn Link", _linkedinController),
              _buildTextField("GitHub Link", _githubController),
              _buildTextField("Instagram Link", _instagramController),
              _buildTextField("WhatsApp No", _whatsappController),
            ],
          ),
        ),
      ),
    );
  }
}
