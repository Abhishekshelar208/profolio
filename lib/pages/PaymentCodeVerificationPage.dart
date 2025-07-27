import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


import 'CouponVerificationPage.dart';
import 'loadingAnimation.dart';

class PaymentCodeVerificationPage extends StatefulWidget {
  final VoidCallback onVerified;
  final dynamic designPrice;

  const PaymentCodeVerificationPage({
    super.key,
    required this.onVerified,
    required this.designPrice,
  });

  @override
  State<PaymentCodeVerificationPage> createState() =>
      _PaymentCodeVerificationPageState();
}

class _PaymentCodeVerificationPageState
    extends State<PaymentCodeVerificationPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController transactionIdController =
  TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  int discount = 0;
  bool couponApplied = false;
  String appliedCouponCode = '';


  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageAndExtractTransactionID() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String fullText = recognizedText.text;

    // Try to extract transaction ID using regex
    final RegExp txnPattern = RegExp(r'(TXN|Txn|txn)?[A-Z0-9]{8,}');
    final match = txnPattern.firstMatch(fullText);

    String txnId = match?.group(0) ?? "";

    if (txnId.isNotEmpty) {
      transactionIdController.text = txnId;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction ID detected: $txnId")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Could not detect a Transaction ID in the image.")),
      );
    }

    await textRecognizer.close();
  }






  void verifyCode() async {
    final code = codeController.text.trim();
    final transactionId = transactionIdController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter Payment Code")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final ref = FirebaseDatabase.instance.ref("PaymentCodes/$code");
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid payment code.")),
        );
        return;
      }

      final data = snapshot.value as Map;

      if (data['isUsed'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This code has already been used.")),
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final email = currentUser?.email ?? "unknown";

      await ref.update({
        'isUsed': true,
        'usedBy': email,
        'transactionId': transactionId,
      });

      final priceString = widget.designPrice.replaceAll(RegExp(r'[^\d]'), '');
      final int originalPrice = int.tryParse(priceString) ?? 0;
      final int finalAmount = originalPrice - discount;

      final now = DateTime.now();
      final date = "${now.day.toString().padLeft(2, '0')} ${_monthName(now.month)} ${now.year}";
      final time = DateFormat('hh:mm a').format(now);

      final paymentRef = FirebaseDatabase.instance.ref("PaymentTransactions").push();
      final String usedCoupon = discount > 0 ? appliedCouponCode : "Not used";

      await paymentRef.set({
        'email': email,
        'finalAmount': finalAmount,
        'couponCode': usedCoupon,
        'transactionId': transactionId,
        'date': date,
        'time': time,
      });

      if (discount > 0 && appliedCouponCode.isNotEmpty) {
        final couponRef = FirebaseDatabase.instance.ref("CouponCodes/${appliedCouponCode}");
        final couponSnap = await couponRef.get();

        if (couponSnap.exists) {
          final couponData = couponSnap.value as Map;
          final currentCount = int.tryParse(couponData['totalUsers'].toString()) ?? 0;

          await couponRef.update({
            'totalUsers': currentCount + 1,
          });
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoadingScreen(onFinish: widget.onVerified),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }




  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }


  void _launchWhatsAppMessage(String txnId) async {
    // Extract numeric value from the designPrice string
    final numericPrice = int.tryParse(widget.designPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final finalAmount = numericPrice - discount;

    final message = Uri.encodeComponent(
      "I just paid ₹$finalAmount to you and my transaction ID is: $txnId. Please provide the payment confirmation code.",
    );

    final url = "https://wa.me/919004512415?text=$message";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        errorMessage = "Could not open WhatsApp.";
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    String priceText = widget.designPrice; // e.g., "In just 49"
    final match = RegExp(r'\d+').firstMatch(priceText); // find number in string
    int originalPrice = match != null ? int.parse(match.group(0)!) : 0;



    int finalAmount = originalPrice - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Verification",
          style: GoogleFonts.blinker(
            fontWeight: FontWeight.bold,
            color: const Color(0xfffaa629),
          ),
        ),
        backgroundColor: const Color(0xff121212),
        iconTheme: const IconThemeData(color: Color(0xfffaa629)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "You have to pay ₹$finalAmount to the following QR code",
              style: GoogleFonts.blinker(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            if (discount > 0)
              Text(
                "🎉 You saved ₹$discount!",
                style: GoogleFonts.blinker(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 16),
            if (!couponApplied)
              TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CouponVerificationPage(),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    final rupeesOff = result['rupeesOff'];
                    final couponCode = result['couponCode'];

                    if (rupeesOff is int && couponCode is String) {
                      setState(() {
                        discount = rupeesOff;
                        appliedCouponCode = couponCode; // Make sure this variable exists
                        couponApplied = true;
                      });
                    }
                  }
                },
                child: Text(
                  "Have any Coupon Code?",
                  style: GoogleFonts.blinker(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Image.asset(
            //   'lib/assets/images/FinalPaymentQr.png', // Replace with your QR code asset path or use NetworkImage
            //   height: 200,
            //   width: 200,
            //   fit: BoxFit.contain,
            // ),
            FutureBuilder<DataSnapshot>(
              future: FirebaseDatabase.instance
                  .ref()
                  .child("UploadedImages")
                  .orderByKey()
                  .limitToLast(1)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Firebase data loading
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data?.value == null) {
                  return const Icon(Icons.image, size: 100, color: Colors.grey); // Error or no image
                } else {
                  Map data = snapshot.data!.value as Map;
                  String imageUrl = data.values.first["imageUrl"];

                  return Image.network(
                    imageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image fully loaded
                      return const Center(
                        child: CircularProgressIndicator(), // While image is still loading
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.red,
                    ),
                  );
                }
              },
            ),


            const SizedBox(height: 32),
            TextField(
              style: GoogleFonts.blinker(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: transactionIdController,
              decoration: InputDecoration(
                labelText: 'Enter Transaction ID',
                labelStyle: GoogleFonts.blinker(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Color(0xff1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xfffaa629)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Color(0xfffaa629)),
                  onPressed: () {
                    final txnId = transactionIdController.text.trim();
                    if (txnId.isEmpty) {
                      setState(() {
                        errorMessage = "Please enter Transaction ID before sending.";
                      });
                      return;
                    }
                    _launchWhatsAppMessage(txnId);
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: pickImageAndExtractTransactionID,
              icon: const Icon(Icons.upload_file, color: Color(0xfffaa629)),
              label: Text(
                "Upload Payment Screenshot",
                style: GoogleFonts.blinker(
                  color: Color(0xfffaa629),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: GoogleFonts.blinker(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter Payment Code',
                labelStyle: GoogleFonts.blinker(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Color(0xff1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xfffaa629)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfffaa629),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                "Verify",
                style: GoogleFonts.blinker(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xff121212),
    );
  }
}

//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'loadingAnimation.dart';
//
// class PaymentCodeVerificationPage extends StatefulWidget {
//   final VoidCallback onVerified;
//   final dynamic designPrice;
//
//   const PaymentCodeVerificationPage({
//     super.key,
//     required this.onVerified,
//     required this.designPrice,
//   });
//
//   @override
//   State<PaymentCodeVerificationPage> createState() =>
//       _PaymentCodeVerificationPageState();
// }
//
// class _PaymentCodeVerificationPageState
//     extends State<PaymentCodeVerificationPage> {
//   final TextEditingController codeController = TextEditingController();
//   final TextEditingController transactionIdController =
//   TextEditingController();
//   bool isLoading = false;
//   String? errorMessage;
//
//   void verifyCode() async {
//     final code = codeController.text.trim();
//     final transactionId = transactionIdController.text.trim();
//
//     if (code.isEmpty || transactionId.isEmpty) {
//       setState(() => errorMessage =
//       "Please enter both Payment Code and Transaction ID.");
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final ref = FirebaseDatabase.instance.ref("PaymentCodes/$code");
//       final snapshot = await ref.get();
//
//       if (!snapshot.exists) {
//         setState(() => errorMessage = "Invalid payment code.");
//         return;
//       }
//
//       final data = snapshot.value as Map;
//
//       if (data['isUsed'] == true) {
//         setState(() => errorMessage = "This code has already been used.");
//         return;
//       }
//
//       // ✅ Mark as used and store user email
//       final currentUser = FirebaseAuth.instance.currentUser;
//       final email = currentUser?.email ?? "unknown";
//
//       await ref.update({
//         'isUsed': true,
//         'usedBy': email,
//         'transactionId': transactionId,
//       });
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => LoadingScreen(onFinish: widget.onVerified),
//         ),
//       );
//     } catch (e) {
//       setState(() => errorMessage = "Something went wrong: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // Add this controller and variables at the top of _PaymentCodeVerificationPageState
//   final TextEditingController couponController = TextEditingController();
//   int discountAmount = 0;
//   bool isCouponValid = false;
//
//   Future<void> checkCouponCode() async {
//     final code = couponController.text.trim();
//     if (code.isEmpty) return;
//
//     final ref = FirebaseDatabase.instance.ref("CouponCodes/$code");
//     final snapshot = await ref.get();
//
//     if (snapshot.exists) {
//       final data = snapshot.value as Map;
//       final off = int.tryParse(data['rupeesOff'].toString()) ?? 0;
//
//       setState(() {
//         discountAmount = off;
//         isCouponValid = true;
//         errorMessage = null;
//       });
//     } else {
//       setState(() {
//         discountAmount = 0;
//         isCouponValid = false;
//         errorMessage = "Invalid Coupon Code";
//       });
//     }
//   }
//
//   void _launchWhatsAppMessage(String txnId) async {
//     final int originalPrice = int.tryParse(widget.designPrice.toString()) ?? 0;
//     final int discountedPrice = (originalPrice - discountAmount).clamp(0, originalPrice);
//
//     // Build price line based on whether coupon is applied
//     final String priceLine = isCouponValid && discountAmount > 0
//         ? "I used coupon '${couponController.text.trim()}' and got ₹$discountAmount off.\nFinal amount paid: ₹$discountedPrice."
//         : "Amount paid: ₹$originalPrice.";
//
//     final String message = Uri.encodeComponent(
//       "✅ Payment Details:\n"
//           "$priceLine\n"
//           "Transaction ID: $txnId\n\n"
//           "Please confirm and send the payment confirmation code.",
//     );
//
//     final Uri url = Uri.parse("https://wa.me/919004512415?text=$message");
//
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       setState(() {
//         errorMessage = "Could not open WhatsApp.";
//       });
//     }
//   }
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Payment Verification",
//           style: GoogleFonts.blinker(
//             fontWeight: FontWeight.bold,
//             color: const Color(0xfffaa629),
//           ),
//         ),
//         backgroundColor: const Color(0xff121212),
//         iconTheme: const IconThemeData(color: Color(0xfffaa629)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: couponController,
//               style: GoogleFonts.blinker(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               decoration: InputDecoration(
//                 labelText: 'Enter Coupon Code (Optional)',
//                 labelStyle: GoogleFonts.blinker(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xff1E1E1E),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xfffaa629)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade700),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xfffaa629), width: 2),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.check, color: Color(0xfffaa629)),
//                   onPressed: checkCouponCode,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             if (isCouponValid)
//               Text(
//                 "Coupon applied! ₹$discountAmount off.",
//                 style: GoogleFonts.blinker(color: Colors.greenAccent, fontWeight: FontWeight.bold),
//               ),
//
//             Text(
//               isCouponValid
//                   ? "Coupon applied!\nYou have to pay ₹${(int.tryParse(widget.designPrice.toString()) ?? 0) - discountAmount} to the following QR code"
//                   : "You have to pay ₹${widget.designPrice} to the following QR code",
//               style: GoogleFonts.blinker(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//
//             const SizedBox(height: 16),
//             Image.asset(
//               'lib/assets/images/FinalPaymentQr.png', // Replace with your QR code asset path or use NetworkImage
//               height: 200,
//               width: 200,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 32),
//             TextField(
//               style: GoogleFonts.blinker(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               controller: transactionIdController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Transaction ID',
//                 labelStyle: GoogleFonts.blinker(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 filled: true,
//                 fillColor: Color(0xff1E1E1E),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Color(0xfffaa629)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade700),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send, color: Color(0xfffaa629)),
//                   onPressed: () {
//                     final txnId = transactionIdController.text.trim();
//                     if (txnId.isEmpty) {
//                       setState(() {
//                         errorMessage = "Please enter Transaction ID before sending.";
//                       });
//                       return;
//                     }
//                     _launchWhatsAppMessage(txnId);
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               style: GoogleFonts.blinker(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               controller: codeController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Payment Code',
//                 labelStyle: GoogleFonts.blinker(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 filled: true,
//                 fillColor: Color(0xff1E1E1E),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Color(0xfffaa629)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade700),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Color(0xfffaa629), width: 2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: verifyCode,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xfffaa629),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//               ),
//               child: Text(
//                 "Verify",
//                 style: GoogleFonts.blinker(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: const Color(0xff121212),
//     );
//   }
// }
