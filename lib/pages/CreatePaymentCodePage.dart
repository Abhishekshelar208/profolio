import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class CreatePaymentCodePage extends StatefulWidget {
  const CreatePaymentCodePage({super.key});

  @override
  State<CreatePaymentCodePage> createState() => _CreatePaymentCodePageState();
}

class _CreatePaymentCodePageState extends State<CreatePaymentCodePage> {
  bool isLoading = false;
  List<Map<String, dynamic>> codeList = [];

  @override
  void initState() {
    super.initState();
    fetchAllCodes();
  }

  Future<String> generateUniqueCode() async {
    String code;
    DatabaseReference paymentCodesRef = FirebaseDatabase.instance.ref("PaymentCodes");

    while (true) {
      code = const Uuid().v4().substring(0, 6); // generate 6-char code

      final snapshot = await paymentCodesRef.child(code).get();
      if (!snapshot.exists) {
        break; // code is unique
      }
    }

    return code;
  }

  Future<String> generateUniqueNumericCode() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("PaymentCodes");
    final Random random = Random();

    String newCode;
    bool exists = true;

    // Keep generating until we find a unique code
    do {
      newCode = (100000 + random.nextInt(900000)).toString(); // 6-digit code
      final snapshot = await ref.child(newCode).get();
      exists = snapshot.exists;
    } while (exists);

    return newCode;
  }


  Future<void> fetchAllCodes() async {
    final ref = FirebaseDatabase.instance.ref("PaymentCodes");
    final snapshot = await ref.get();
    List<Map<String, dynamic>> fetchedList = [];

    if (snapshot.exists) {
      snapshot.children.forEach((child) {
        final value = child.value as Map<dynamic, dynamic>;
        fetchedList.add({
          "code": value['code'],
          "isUsed": value['isUsed'],
          "timestamp": value['timestamp'],
        });
      });
    }

    setState(() {
      codeList = fetchedList;
    });
  }

  Future<void> createAndShareCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      String newCode = await generateUniqueNumericCode();

      DatabaseReference ref = FirebaseDatabase.instance.ref("PaymentCodes/$newCode");
      await ref.set({
        'code': newCode,
        'isUsed': false,
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() {
        codeList.add({
          "code": newCode,
          "isUsed": false,
          "timestamp": DateTime.now().toIso8601String(),
        });
      });

      String message = '''
🎉 Thank you for choosing *ProFolio* to build your digital portfolio!

🧾 Your **Secure Payment Code** is: $newCode

📌 Please use this code to activate your portfolio after completion.

🚫 Do not share this code with others. It is uniquely generated for your use.

If you have any issues, feel free to reach out to our support team.

Warm regards,  
Team ProFolio
''';

      await Share.share(message);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> deleteCode(String code) async {
    try {
      await FirebaseDatabase.instance.ref("PaymentCodes/$code").remove();
      setState(() {
        codeList.removeWhere((element) => element['code'] == code);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to delete code: $code")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Payment Code",
          style: GoogleFonts.blinker(
            color: const Color(0xfffaa629),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff121212),
        iconTheme: const IconThemeData(color: Color(0xfffaa629)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: createAndShareCode,
              icon: const Icon(Icons.key, color: Colors.black),
              label: Text(
                "Generate & Share Code",
                style: GoogleFonts.blinker(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfffaa629),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: codeList.isEmpty
                  ? const Text("No payment codes generated yet.")
                  : ListView.builder(
                itemCount: codeList.length,
                itemBuilder: (context, index) {
                  final item = codeList[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(
                        item['code'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text("Used: ${item['isUsed']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteCode(item['code']),
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
}
