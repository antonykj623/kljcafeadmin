import 'package:flutter/material.dart';

import 'addemployee.dart';

class Employee {
  final String name;
  final String phone;
  final String branch;
  final bool isActive;

  Employee({
    required this.name,
    required this.phone,
    required this.branch,
    required this.isActive,
  });
}

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> employees = [
    Employee(name: "Antony", phone: "9876543210", branch: "Thrissur", isActive: true),
    Employee(name: "John", phone: "9123456789", branch: "Ernakulam", isActive: false),
    Employee(name: "Alan", phone: "9090909090", branch: "Palakkad", isActive: true),
  ];

  void _editEmployee(Employee emp) {
    final TextEditingController nameCtrl = TextEditingController(text: emp.name);
    final TextEditingController phoneCtrl = TextEditingController(text: emp.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
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
                final index = employees.indexOf(emp);
                employees[index] = Employee(
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  branch: emp.branch,
                  isActive: emp.isActive,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Employee updated successfully")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(Employee emp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Employee"),
        content: Text("Are you sure you want to delete ${emp.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                employees.remove(emp);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Employee deleted")),
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
      appBar: AppBar(title: const Text("Employee List")),
      body: employees.isEmpty
          ? const Center(child: Text("No employees added yet"))
          : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: emp.isActive ? Colors.green : Colors.red,
                child: Text(emp.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(emp.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone: ${emp.phone}"),
                  Text("Branch: ${emp.branch}"),
                  Text(emp.isActive ? "Status: Active" : "Status: Inactive"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editEmployee(emp),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEmployee(emp),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddEmployeeScreen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Navigate to Add Employee Page")),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEmployeeScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
