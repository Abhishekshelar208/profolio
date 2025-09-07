import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:profolio/pages/portfoliolist.dart';

class CreateStudentID extends StatefulWidget {
  const CreateStudentID({Key? key}) : super(key: key);

  @override
  State<CreateStudentID> createState() => _CreateStudentIDState();
}

class _CreateStudentIDState extends State<CreateStudentID> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool _isLoading = false; // <-- ADD this

  String? _enteredName;
  String? _enteredContact;

  void _showFormBeforeSignIn() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Enter Your Details",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "⚠️ Enter correct details. We are not responsible for incorrect information.",
              style: GoogleFonts.blinker(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: GoogleFonts.blinker(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
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
            SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.blinker(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Contact No",
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
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            ),
            onPressed: () {
              String name = nameController.text.trim();
              String contact = contactController.text.trim();

              if (name.isNotEmpty && contact.isNotEmpty) {
                _enteredName = name;
                _enteredContact = contact;
                Navigator.pop(context); // Close dialog
                _handleGoogleSignIn(); // Now trigger Google Sign-In
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill all fields")),
                );
              }
            },
            child: Text("Finish",
              style: GoogleFonts.blinker(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true); // show loading

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      if (kIsWeb) {
        await _auth.signInWithPopup(googleProvider);
      } else {
        await _auth.signInWithProvider(googleProvider);
      }

      User? user = _auth.currentUser;
      if (user != null && _enteredName != null && _enteredContact != null) {
        await _saveToDatabase(_enteredName!, _enteredContact!, user.email ?? "");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PortfolioListPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false); // hide loading after process
    }
  }



  // void _saveToDatabase(String name, String contact, String email) async {
  //   final dbRef = FirebaseDatabase.instance.ref().child("ProFolioUsersLists");
  //
  //   final newEntryRef = dbRef.push(); // Generates a unique key
  //
  //   await newEntryRef.set({
  //     "Name": name,
  //     "ContactNo": contact,
  //     "EmailID": email,
  //   });
  // }




  Future<void> _saveToDatabase(String name, String contact, String email) async {
    final dbRef = FirebaseDatabase.instance.ref().child("ProFolioUsersLists");

    final snapshot = await dbRef.orderByChild("EmailID").equalTo(email).once();

    if (snapshot.snapshot.value == null) {
      // Only add to database if email doesn't exist
      final newEntryRef = dbRef.push();
      await newEntryRef.set({
        "Name": name,
        "ContactNo": contact,
        "EmailID": email,
      });
    }
  }





  void _nextPage() {
    if (currentPage < 2) {
      setState(() => currentPage++);
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Widget> _buildSlides(double screenWidth) {
    return [
      _introSlide(
        screenWidth,
        "Welcome to ProFolio",
        "Build your personalized portfolio in minutes.",
        'lib/assets/lottieAnimations/animationThree.json',
      ),
      _introSlide(
        screenWidth,
        "Customize Effortlessly",
        "Add projects, skills, resume, and achievements easily.",
        'lib/assets/lottieAnimations/animationTwo.json',
      ),
      _introSlide(
        screenWidth,
        "Share & Shine",
        "Showcase your portfolio to the world with one link.",
        'lib/assets/lottieAnimations/animationFour.json',
      ),
    ];
  }

  Widget _introSlide(double width, String title, String subtitle, String lottiePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Lottie.asset(
              lottiePath,
              width: width * 0.85,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ),
        const SizedBox(height: 30),
        FittedBox(
          child: Text(
            title,
            style: GoogleFonts.blinker(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.blinker(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 40),
        if (currentPage == 2)
          ElevatedButton(
            onPressed: _showFormBeforeSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfffaa629),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Continue",
              style: GoogleFonts.blinker(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xfffaa629),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Continue",
              style: GoogleFonts.blinker(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffe0eae5),
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: _buildSlides(screenWidth),
            ),
          ),
        ),

        // 👇 Loading Overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Lottie.asset(
                'lib/assets/lottieAnimations/rocketAnimation.json', // <-- add your file here
                width: 300,
                height: 300,
                repeat: true,
              ),
            ),
          ),
      ],
    );
  }

}
