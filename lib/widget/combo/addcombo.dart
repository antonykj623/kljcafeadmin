import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddComboPage extends StatefulWidget {
  const AddComboPage({super.key});

  @override
  State<AddComboPage> createState() => _AddComboPageState();
}

class _AddComboPageState extends State<AddComboPage> {
  final TextEditingController comboNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();

  File? _selectedImage;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addCombo() {
    final comboName = comboNameController.text.trim();
    final description = descriptionController.text.trim();
    final price = priceController.text.trim();
    final offerPrice = offerPriceController.text.trim();

    if (_selectedImage == null ||
        comboName.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        offerPrice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    // ✅ You can save data to Firebase / API here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Combo '$comboName' added successfully!")),
    );

    // Clear form
    setState(() {
      _selectedImage = null;
      comboNameController.clear();
      descriptionController.clear();
      priceController.clear();
      offerPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Combo Offer"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Image Picker ----------
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: _selectedImage == null
                    ? Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, size: 50, color: Colors.black54),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Combo Name ----------
            TextField(
              controller: comboNameController,
              decoration: const InputDecoration(
                labelText: "Combo Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fastfood),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- Description ----------
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- Price ----------
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- Offer Price ----------
            TextField(
              controller: offerPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Offer Price",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_offer),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Add Button ----------
            Center(
              child: ElevatedButton.icon(
                onPressed: _addCombo,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Add Combo Offer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
