import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedBranch;

  final List<String> branches = ['Thrissur', 'Ernakulam', 'Kozhikode', 'Palakkad'];

  // 🔹 Sample expense data (you can replace this with real data from backend)
  final List<Map<String, dynamic>> allExpenses = [
    {"id": 1, "branch": "Thrissur", "date": DateTime(2025, 11, 2), "amount": 700, "details": "Electricity Bill"},
    {"id": 2, "branch": "Ernakulam", "date": DateTime(2025, 11, 4), "amount": 1200, "details": "Raw Materials"},
    {"id": 3, "branch": "Thrissur", "date": DateTime(2025, 11, 6), "amount": 500, "details": "Internet Bill"},
    {"id": 4, "branch": "Kozhikode", "date": DateTime(2025, 10, 29), "amount": 1500, "details": "Maintenance"},
    {"id": 5, "branch": "Palakkad", "date": DateTime(2025, 11, 1), "amount": 900, "details": "Employee Snacks"},
  ];

  List<Map<String, dynamic>> filteredExpenses = [];
  double totalExpense = 0;

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
      filteredExpenses = allExpenses
          .where((exp) =>
      exp['branch'] == selectedBranch &&
          exp['date'].isAfter(startDate!.subtract(const Duration(days: 1))) &&
          exp['date'].isBefore(endDate!.add(const Duration(days: 1))))
          .toList();

      totalExpense = filteredExpenses.fold(0.0, (sum, item) => sum + item['amount']);
    });
  }

  String _formatDate(DateTime? date) {
    return date == null ? "Select Date" : DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Report"),
        backgroundColor: Colors.redAccent,
      ),
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
              onChanged: (value) => setState(() => selectedBranch = value),
            ),
            const SizedBox(height: 20),

            // 🔹 Date Range
            Row(
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

            // 🔹 Generate Report Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.analytics_outlined),
                label: const Text("Generate Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 🔹 Expense Report
            if (filteredExpenses.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    // Total Summary
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        "Total Expense: ₹${totalExpense.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),

                    // Expense List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final exp = filteredExpenses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.money_off, color: Colors.redAccent),
                              title: Text(
                                exp['details'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${DateFormat('dd MMM yyyy').format(exp['date'])} • ${exp['branch']}",
                              ),
                              trailing: Text(
                                "₹${exp['amount']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    "No expense data found for selected branch and dates",
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
