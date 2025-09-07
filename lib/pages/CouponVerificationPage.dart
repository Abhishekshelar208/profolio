import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponVerificationPage extends StatefulWidget {
  const CouponVerificationPage({super.key});

  @override
  State<CouponVerificationPage> createState() => _CouponVerificationPageState();
}

class _CouponVerificationPageState extends State<CouponVerificationPage> {
  final TextEditingController couponController = TextEditingController();
  String? resultMessage;
  bool isLoading = false;

  void verifyCoupon() async {
    final coupon = couponController.text.trim();

    if (coupon.isEmpty) {
      setState(() {
        resultMessage = "Please enter a coupon code or skip.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = null;
    });

    try {
      final ref = FirebaseDatabase.instance.ref("CouponCodes/$coupon");
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        setState(() {
          resultMessage = "Invalid coupon code.";
        });
        return;
      }

      final data = snapshot.value as Map;
      final rupeesOff = int.tryParse(data['rupeesOff'].toString()) ?? 0;
      final shopName = data['shopName'] ?? 'Shop';

      setState(() {
        resultMessage = "✅ ₹$rupeesOff off at $shopName!";
      });

      // Return rupeesOff back to previous page after short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, {
          'rupeesOff': rupeesOff,
          'couponCode': coupon,
        });
      });
    } catch (e) {
      setState(() {
        resultMessage = "Something went wrong: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void skipCoupon() {
    setState(() {
      resultMessage = "Proceeding without coupon code.";
    });

    // Return 0 discount to previous page after short delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      appBar: AppBar(
        title: Text(
          "Coupon Code",
          style: GoogleFonts.blinker(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xffe0eae5),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: couponController,
              style: GoogleFonts.blinker(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: "Enter Coupon Code (optional)",
                labelStyle: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: verifyCoupon,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                "Verify",
                style: GoogleFonts.blinker(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: skipCoupon,
              child: Text(
                "I don’t have Coupon Code",
                style: GoogleFonts.blinker(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (resultMessage != null)
              Text(
                resultMessage!,
                style: GoogleFonts.blinker(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
