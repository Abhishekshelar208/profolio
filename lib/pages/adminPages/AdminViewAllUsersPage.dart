import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class AdminViewAllUsersPage extends StatefulWidget {
  @override
  _AdminViewAllUsersPageState createState() => _AdminViewAllUsersPageState();
}

class _AdminViewAllUsersPageState extends State<AdminViewAllUsersPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('ProFolioUsersLists');
  Map<dynamic, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      setState(() {
        userData = snapshot.value as Map;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffe0eae5),
        title: Text(
          "ProFolio Users",
          style: GoogleFonts.blinker(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: userData!.length,
        itemBuilder: (context, index) {
          String key = userData!.keys.elementAt(index);
          var user = userData![key];

          return ListTile(
            title: Text(user['Name'] ?? 'No Name',
              style: GoogleFonts.blinker(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            trailing: ElevatedButton(
              child: Text('Open',
                style: GoogleFonts.blinker(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailsPage(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}





class UserDetailsPage extends StatelessWidget {
  final Map user;

  const UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    List<String> portfolios = [];

    if (user['Portfolios'] != null) {
      Map<dynamic, dynamic> portfolioMap = user['Portfolios'];
      portfolios = portfolioMap.values.map<String>((e) => e.toString()).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffe0eae5),
        title: Text(user['Name'] ?? 'User Details',
        style: GoogleFonts.blinker(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 ${user['Name']}", style: GoogleFonts.blinker(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),),
            SizedBox(height: 8),
            FittedBox(
              child: Text("📧 ${user['EmailID']}",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text("📱 ${user['ContactNo']}",
              style: GoogleFonts.blinker(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text("📂 Portfolios:", style: GoogleFonts.blinker(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),),
            SizedBox(height: 8),
            ...portfolios.map((p) => Row(
              children: [
                Expanded(child: Text("- $p",
                  style: GoogleFonts.blinker(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                )),
                ElevatedButton(
                  onPressed: () {
                    final url = "https://profolio-abhishek-shelar.web.app/#/portfolio/$p";
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Link copied to clipboard!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("Visit",
                    style: GoogleFonts.blinker(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
