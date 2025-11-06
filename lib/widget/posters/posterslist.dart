import 'dart:io';
import 'package:flutter/material.dart';

import 'addposters.dart'; // import your AddPosterScreen

class Poster {
  final String name;
  final String description;
  final File? image;

  Poster({required this.name, required this.description, this.image});
}

class PosterListScreen extends StatefulWidget {
  const PosterListScreen({super.key});

  @override
  State<PosterListScreen> createState() => _PosterListScreenState();
}

class _PosterListScreenState extends State<PosterListScreen> {
  List<Poster> posters = [
    Poster(
      name: "Summer Offer",
      description: "Get up to 50% off on all items this summer!",
      image: null,
    ),
    Poster(
      name: "New Arrivals",
      description: "Check out our latest collection available now.",
      image: null,
    ),
  ];

  void _editPoster(Poster poster) {
    final TextEditingController nameCtrl = TextEditingController(text: poster.name);
    final TextEditingController descCtrl = TextEditingController(text: poster.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Poster"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Poster Name"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = posters.indexOf(poster);
                posters[index] = Poster(
                  name: nameCtrl.text,
                  description: descCtrl.text,
                  image: poster.image,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Poster updated successfully")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deletePoster(Poster poster) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Poster"),
        content: Text("Are you sure you want to delete '${poster.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                posters.remove(poster);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Poster deleted")),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddPoster() async {
    final newPoster = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPosterScreen()),
    );

    if (newPoster != null && newPoster is Poster) {
      setState(() {
        posters.add(newPoster);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Poster List")),
      body: posters.isEmpty
          ? const Center(
        child: Text(
          "No posters available.\nClick + to add a new one.",
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: posters.length,
        itemBuilder: (context, index) {
          final poster = posters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: poster.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  poster.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
                  : const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.image, color: Colors.white),
              ),
              title: Text(
                poster.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                poster.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editPoster(poster),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePoster(poster),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPoster,
        child: const Icon(Icons.add),
      ),
    );
  }
}
