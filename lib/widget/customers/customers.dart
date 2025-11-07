import 'package:flutter/material.dart';
import 'package:kljcafe_admin/widget/customers/passbook.dart';
// ⬅️ import the new file

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedBranch;

  final List<String> branches = [
    'Thrissur',
    'Ernakulam',
    'Kozhikode',
    'Palakkad'
  ];

  List<Map<String, dynamic>> customers = [
    {"name": "Anand", "branch": "Thrissur", "status": true},
    {"name": "Divya", "branch": "Ernakulam", "status": false},
    {"name": "Manu", "branch": "Kozhikode", "status": true},
    {"name": "Anjali", "branch": "Thrissur", "status": true},
  ];

  List<Map<String, dynamic>> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    filteredCustomers = List.from(customers);
  }

  void _filterCustomers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = customers.where((cust) {
        final nameMatch = cust['name'].toLowerCase().contains(query);
        final branchMatch = selectedBranch == null ||
            selectedBranch == "All" ||
            cust['branch'] == selectedBranch;
        return nameMatch && branchMatch;
      }).toList();
    });
  }

  void _toggleStatus(int index, bool newStatus) {
    setState(() {
      filteredCustomers[index]['status'] = newStatus;
      final name = filteredCustomers[index]['name'];
      final originalIndex =
      customers.indexWhere((element) => element['name'] == name);
      if (originalIndex != -1) {
        customers[originalIndex]['status'] = newStatus;
      }
    });
  }

  void _openPassbook(Map<String, dynamic> customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassbookScreen(
          customerName: customer['name'],
          branch: customer['branch'],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          customer['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Branch: ${customer['branch']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.book, color: Colors.blueAccent),
              tooltip: "View Passbook",
              onPressed: () => _openPassbook(customer),
            ),
            Switch(
              value: customer['status'],
              onChanged: (value) => _toggleStatus(index, value),
              activeColor: Colors.green,
              inactiveThumbColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer List"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (_) => _filterCustomers(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedBranch,
              hint: const Text("Select Branch"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: [
                const DropdownMenuItem(value: "All", child: Text("All Branches")),
                ...branches.map((b) => DropdownMenuItem(value: b, child: Text(b))),
              ],
              onChanged: (value) {
                setState(() => selectedBranch = value);
                _filterCustomers();
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: filteredCustomers.isEmpty
                  ? const Center(child: Text("No customers found"))
                  : ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) =>
                    _buildCustomerCard(filteredCustomers[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
