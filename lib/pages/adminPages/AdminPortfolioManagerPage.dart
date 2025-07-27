import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPortfolioManagerPage extends StatefulWidget {
  const AdminPortfolioManagerPage({super.key});

  @override
  State<AdminPortfolioManagerPage> createState() =>
      _AdminPortfolioManagerPageState();
}

class _AdminPortfolioManagerPageState
    extends State<AdminPortfolioManagerPage> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('PortfolioDetails');

  Map<String, Map> portfolioData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPortfolioData();
  }

  Future<void> fetchPortfolioData() async {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          portfolioData = data.map((key, value) =>
              MapEntry(key, Map<String, dynamic>.from(value)));
          isLoading = false;
        });
      } else {
        setState(() {
          portfolioData = {};
          isLoading = false;
        });
      }
    });
  }

  Future<void> updatePortfolio(String key, Map updatedData) async {
    await _dbRef.child(key).update(updatedData.cast<String, Object?>());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Portfolio updated successfully!")),
    );
  }

  Future<void> deletePortfolio(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content:
        const Text("Are you sure you want to delete this portfolio?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbRef.child(key).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Portfolio deleted successfully!")),
      );
    }
  }

  void showEditDialog(String key, Map data) {
    final nameController =
    TextEditingController(text: data['PortfolioName']);
    final priceController =
    TextEditingController(text: data['PortfolioPrice']);
    final urlController =
    TextEditingController(text: data['PortfolioUrl']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Portfolio"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price')),
              TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedData = {
                'PortfolioName': nameController.text,
                'PortfolioPrice': priceController.text,
                'PortfolioUrl': urlController.text,
              };
              updatePortfolio(key, updatedData);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void showAddDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Portfolio"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price')),
              TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newEntry = {
                'PortfolioName': nameController.text,
                'PortfolioPrice': priceController.text,
                'PortfolioUrl': urlController.text,
              };
              _dbRef.push().set(newEntry);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Portfolio added successfully!")),
              );
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Admin Portfolio Manager"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: showAddDialog,
            icon: const Icon(Icons.add),
            tooltip: "Add New Design",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : portfolioData.isEmpty
          ? const Center(child: Text("No portfolio data found."))
          : ListView.builder(
        itemCount: portfolioData.length,
        itemBuilder: (context, index) {
          String key = portfolioData.keys.elementAt(index);
          Map data = portfolioData[key]!;

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                data['PortfolioName'] ?? 'Unnamed',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price: ₹${data['PortfolioPrice']}"),
                    Text(
                      "URL: ${data['PortfolioUrl']}",
                      style: const TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () => showEditDialog(key, data),
                  ),
                  IconButton(
                    icon:
                    const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletePortfolio(key),
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
