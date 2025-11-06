import 'package:flutter/material.dart';

import 'addcombo.dart';

class ComboListPage extends StatefulWidget {
  const ComboListPage({super.key});

  @override
  State<ComboListPage> createState() => _ComboListPageState();
}

class _ComboListPageState extends State<ComboListPage> {
  // Temporary sample combo data
  List<Map<String, dynamic>> comboList = [
    {
      "name": "Burger + Fries Combo",
      "description": "Delicious burger with crispy fries",
      "price": 180.0,
      "offerPrice": 150.0,
      "image": "https://i.imgur.com/1bX5QH6.jpg"
    },
    {
      "name": "Pizza + Coke Combo",
      "description": "Cheesy pizza with refreshing coke",
      "price": 250.0,
      "offerPrice": 210.0,
      "image": "https://i.imgur.com/0A2Q8qE.jpg"
    },
  ];

  void _editCombo(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit feature for '${comboList[index]['name']}'")),
    );
  }

  void _deleteCombo(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Combo"),
        content: Text("Are you sure you want to delete '${comboList[index]['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                comboList.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Combo deleted")),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Combo Offers"),
        backgroundColor: Colors.blueAccent,
      ),
      body: comboList.isEmpty
          ? const Center(
        child: Text(
          "No combo offers found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: comboList.length,
        itemBuilder: (context, index) {
          final combo = comboList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  combo['image'],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                combo['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(combo['description']),
                  const SizedBox(height: 4),
                  Text(
                    "₹${combo['offerPrice']} (Offer) / ₹${combo['price']}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editCombo(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCombo(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Combo Page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Navigate to Add Combo Page")),
          );


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddComboPage(),
            ),
          );




        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
