import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../patternlock/customaternlock.dart';
 // Import the pattern lock widget

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _photo;
  File? _idDocument;
  String? _branch;
  bool _isActive = true;
  String? _pattern;

  final List<String> branches = ["Thrissur", "Ernakulam", "Palakkad", "Kochi"];

  final picker = ImagePicker();

  Future<void> _pickImage(bool isPhoto) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photo = File(pickedFile.path);
        } else {
          _idDocument = File(pickedFile.path);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_pattern == null || _pattern!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please set a pattern lock")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Employee Added:\nName: ${_nameController.text}\nPhone: ${_phoneController.text}\nBranch: $_branch\nPattern: $_pattern",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Employee")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter name" : null,
              ),
              const SizedBox(height: 12),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) =>
                value!.isEmpty ? "Please enter address" : null,
              ),
              const SizedBox(height: 12),

              // Phone number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Please enter phone number" : null,
              ),
              const SizedBox(height: 20),

              // Photo upload
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(true),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text("Upload Photo"),
                  ),
                  const SizedBox(width: 10),
                  if (_photo != null)
                    Image.file(_photo!, width: 60, height: 60, fit: BoxFit.cover),
                ],
              ),
              const SizedBox(height: 12),

              // ID document upload
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(false),
                    icon: const Icon(Icons.file_present),
                    label: const Text("Upload ID Document"),
                  ),
                  const SizedBox(width: 10),
                  if (_idDocument != null)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // Branch selection
              DropdownButtonFormField<String>(
                value: _branch,
                items: branches
                    .map((b) =>
                    DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (value) => setState(() => _branch = value),
                decoration: const InputDecoration(labelText: "Select Branch"),
                validator: (value) =>
                value == null ? "Please select branch" : null,
              ),
              const SizedBox(height: 20),

              // Status switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pattern lock section
              const Text("Set Pattern Lock",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomPatternLock(
                    onPatternCompleted: (p) {
                      setState(() => _pattern = p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pattern Set: $p")),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Add Employee button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Employee"),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
