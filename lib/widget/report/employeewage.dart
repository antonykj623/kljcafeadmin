import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeWageReportScreen extends StatefulWidget {
  const EmployeeWageReportScreen({super.key});

  @override
  State<EmployeeWageReportScreen> createState() => _EmployeeWageReportScreenState();
}

class _EmployeeWageReportScreenState extends State<EmployeeWageReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedBranch;

  final List<String> branches = ['Thrissur', 'Ernakulam', 'Kozhikode', 'Palakkad'];

  final List<Map<String, dynamic>> allWages = [
    {"name": "Antony", "date": DateTime(2025, 11, 2), "amount": 1200, "branch": "Thrissur"},
    {"name": "John", "date": DateTime(2025, 11, 4), "amount": 800, "branch": "Ernakulam"},
    {"name": "Alan", "date": DateTime(2025, 11, 6), "amount": 950, "branch": "Thrissur"},
    {"name": "Sara", "date": DateTime(2025, 10, 28), "amount": 1000, "branch": "Kozhikode"},
  ];

  List<Map<String, dynamic>> filteredWages = [];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _generateReport() {
    if (selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a branch")),
      );
      return;
    }

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both start and end dates")),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date must be after start date")),
      );
      return;
    }

    setState(() {
      filteredWages = allWages
          .where((w) =>
      w['branch'] == selectedBranch &&
          w['date'].isAfter(startDate!.subtract(const Duration(days: 1))) &&
          w['date'].isBefore(endDate!.add(const Duration(days: 1))))
          .toList();
    });
  }

  String _formatDate(DateTime? date) {
    return date == null ? "Select Date" : DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Wage Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Branch Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Branch",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedBranch,
              items: branches.map((branch) {
                return DropdownMenuItem(value: branch, child: Text(branch));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedBranch = value);
              },
            ),
            const SizedBox(height: 20),

            // 🔹 Date Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text("From: ${_formatDate(startDate)}"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_month),
                    label: Text("To: ${_formatDate(endDate)}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Generate Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.analytics),
                label: const Text("Generate Report"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 🔹 Report List
            if (filteredWages.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredWages.length,
                  itemBuilder: (context, index) {
                    final w = filteredWages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(w['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${DateFormat('dd MMM yyyy').format(w['date'])} • ${w['branch']}"),
                        trailing: Text(
                          "₹${w['amount']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    "No wage data found for selected branch and dates",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
