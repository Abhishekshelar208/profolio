import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GenerateCouponCodePage.dart';


class ShopListPage extends StatefulWidget {
  const ShopListPage({Key? key}) : super(key: key);

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('CouponCodes');
  Set<String> shopNames = {};

  @override
  void initState() {
    super.initState();
    fetchShopNames();
  }

  void fetchShopNames() {
    _dbRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        for (var entry in data.entries) {
          final shopName = entry.value['shopName'];
          if (shopName != null) {
            shopNames.add(shopName);
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("All Shops", style: TextStyle(color: Colors.amber)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateCouponCodePage(),));
      },child: Icon((Icons.add)),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: shopNames.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView(
          children: shopNames.map((shop) {
            return Card(
              color: Colors.grey[300],
              child: ListTile(
                title: Text(shop,style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShopDetailsPage(shopName: shop),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}





class ShopDetailsPage extends StatefulWidget {
  final String shopName;
  const ShopDetailsPage({Key? key, required this.shopName}) : super(key: key);

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('CouponCodes');
  List<Map> shopCoupons = [];

  @override
  void initState() {
    super.initState();
    fetchShopCoupons();
  }

  void fetchShopCoupons() {
    _dbRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        data.forEach((key, value) {
          if (value['shopName'] == widget.shopName) {
            shopCoupons.add({
              'code': key,
              'date': value['date'],
              'time': value['time'],
              'rupeesOff': value['rupeesOff'],
              'location': value['location'],
              'totalUsers': value['totalUsers'] ?? 0,
            });
          }
        });
        setState(() {});
      }
    });
  }

  void _openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.shopName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: shopCoupons.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
        itemCount: shopCoupons.length,
        itemBuilder: (context, index) {
          final coupon = shopCoupons[index];
          final location = coupon['location'];
          return Card(
            color: Colors.white70,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                'Code: ${coupon['code']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ Off: ${coupon['rupeesOff']}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Date: ${coupon['date']}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Time: ${coupon['time']}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Users: ${coupon['totalUsers']}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  if (location != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location: ${location['latitude']}, ${location['longitude']}',
                              style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final lat = double.tryParse(location['latitude'].toString()) ?? 0.0;
                                final lng = double.tryParse(location['longitude'].toString()) ?? 0.0;
                                _openMap(lat, lng);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              child: const Text("Open Maps"),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
