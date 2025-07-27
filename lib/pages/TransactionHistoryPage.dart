import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final DatabaseReference _paymentRef =
  FirebaseDatabase.instance.ref("PaymentTransactions");

  List<Map<String, dynamic>> _userTransactions = [];
  bool _isLoading = true;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userEmail = user.email;
    final snapshot = await _paymentRef.get();

    List<Map<String, dynamic>> tempList = [];

    if (snapshot.exists) {
      final allTransactions = Map<String, dynamic>.from(snapshot.value as Map);
      allTransactions.forEach((key, value) {
        final data = Map<String, dynamic>.from(value);
        if (data['email'] == _userEmail) {
          tempList.add(data);
        }
      });
    }

    setState(() {
      _userTransactions = tempList.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _generatePdf(Map<String, dynamic> txn) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Payment Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Transaction ID: ${txn['transactionId']}'),
              pw.Text('Date: ${txn['date']}'),
              pw.Text('Time: ${txn['time']}'),
              pw.Text('Email: ${txn['email']}'),
              pw.Text('Coupon Code: ${txn['couponCode']}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text('Final Amount Paid: ₹${txn['finalAmount']}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Thank you for your payment!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Transactions',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userTransactions.isEmpty
          ? const Center(child: Text("No transactions yet."))
          : ListView.builder(
        itemCount: _userTransactions.length,
        itemBuilder: (context, index) {
          final txn = _userTransactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.payment, color: Colors.purple),
                    title: Text(
                      "₹${txn['finalAmount']} - ${txn['couponCode'] ?? 'N/A'}",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Txn ID: ${txn['transactionId']}\n${txn['date']} at ${txn['time']}",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _generatePdf(txn),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Bill"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
