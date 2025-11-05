import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Sample product data — replace this with your actual backend data later
  List<Map<String, dynamic>> products = [
    {
      "image": "https://www.munatycooking.com/wp-content/uploads/2024/04/Three-glasses-filled-with-karak-chai.jpg",
      "name": "Tea",
      "price": 12,
      "description": "Chilled coffee with ice cream topping"
    },
    {
      "image": "https://www.indianhealthyrecipes.com/wp-content/uploads/2016/02/veg-burger-recipe-1.jpg",
      "name": "Veg Burger",
      "price": 80,
      "description": "Delicious homemade burger with fries"
    },
    {
      "image": "https://www.indianhealthyrecipes.com/wp-content/uploads/2019/02/paneer-sandwich.jpg",
      "name": "Paneer Sandwich",
      "price": 90,
      "description": "Grilled sandwich with paneer stuffing"
    },
  ];

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product deleted successfully")),
    );
  }

  void editProduct(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit product: ${products[index]["name"]}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        backgroundColor: Colors.blueAccent,
      ),
      body: products.isEmpty
          ? const Center(
        child: Text(
          "No products available",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product["image"],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product["name"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${product["price"].toString()}",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(product["description"]),
                ],
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => editProduct(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduct(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Navigate to Add Product Screen")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
