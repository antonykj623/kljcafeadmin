import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPosterScreen extends StatefulWidget {
  const AddPosterScreen({super.key});

  @override
  State<AddPosterScreen> createState() => _AddPosterScreenState();
}

class _AddPosterScreenState extends State<AddPosterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  File? _posterImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _posterImage = File(pickedFile.path);
      });
    }
  }

  void _addPoster() {
    if (_formKey.currentState!.validate()) {
      if (_posterImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a poster image")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Poster Added:\nName: ${_nameController.text}\nDescription: ${_descController.text}",
          ),
        ),
      );

      // TODO: Save to backend or local database here

      // Reset form
      setState(() {
        _nameController.clear();
        _descController.clear();
        _posterImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Poster")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Poster Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter a poster name" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 16),

              // Image Picker
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text("Select Image"),
                  ),
                  const SizedBox(width: 16),
                  if (_posterImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _posterImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Add Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addPoster,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Poster"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
