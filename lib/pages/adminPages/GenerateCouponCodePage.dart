import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class GenerateCouponCodePage extends StatefulWidget {
  const GenerateCouponCodePage({super.key});

  @override
  State<GenerateCouponCodePage> createState() => _GenerateCouponCodePageState();
}

class _GenerateCouponCodePageState extends State<GenerateCouponCodePage> {
  final DatabaseReference couponRef = FirebaseDatabase.instance.ref('CouponCodes');
  List<String> generatedCodes = [];


  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController rupeesOffController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  double? latitude;
  double? longitude;
  bool _isLoadingLocation = false;


  @override
  void initState() {
    super.initState();
    fetchGeneratedCodes();
  }

  Future<void> fetchGeneratedCodes() async {
    final snapshot = await couponRef.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        generatedCodes = data.keys.toList().reversed.toList();
      });
    }
  }

  String generateCouponCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(5, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> createAndStoreCouponCode() async {
    if (shopNameController.text.isEmpty ||
        rupeesOffController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and capture location.")),
      );
      return;
    }

    String newCode = generateCouponCode();
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
    String formattedTime = selectedTime!.format(context);

    await couponRef.child(newCode).set({
      'shopName': shopNameController.text.trim(),
      'date': formattedDate,
      'time': formattedTime,
      'rupeesOff': rupeesOffController.text.trim(),
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'totalUsers': 0,
    });

    setState(() {
      generatedCodes.insert(0, newCode);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Coupon $newCode created.")),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location captured successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0eae5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Shop Coupon Codes",
                style: GoogleFonts.blinker(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    TextField(

                      controller: shopNameController,
                      style: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Shop Name',
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
                    const SizedBox(height: 12),
                    TextField(
                      controller: rupeesOffController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.blinker(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Rupees Off (Discount)',
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickDate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              selectedDate == null
                                  ? 'Select Date'
                                  : DateFormat('dd-MM-yyyy').format(selectedDate!),
                              style: GoogleFonts.blinker(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickTime,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              selectedTime == null
                                  ? 'Select Time'
                                  : selectedTime!.format(context),
                              style: GoogleFonts.blinker(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],

                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoadingLocation = true;
                        });
                        await getCurrentLocation();
                        setState(() {
                          _isLoadingLocation = false;
                        });
                      },
                      child: Text("Get Location",
                          style: GoogleFonts.blinker(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),

                    SizedBox(height: 10),

                    if (_isLoadingLocation)
                      const CircularProgressIndicator(color: Colors.white)
                    else if (latitude != null && longitude != null)
                      Text(
                        '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: createAndStoreCouponCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Generate Coupon Code",
                        style: GoogleFonts.blinker(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Generated Codes",
                      style: GoogleFonts.blinker(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: generatedCodes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: const Icon(Icons.discount, color: Colors.black54),
                            title: Text(
                              generatedCodes[index],
                              style: GoogleFonts.blinker(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
