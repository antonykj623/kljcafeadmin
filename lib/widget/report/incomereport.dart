import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedBranch;

  final List<String> branches = ['Thrissur', 'Ernakulam', 'Kozhikode', 'Palakkad'];

  // 🔹 Sample income data (You can replace this with backend data)
  final List<Map<String, dynamic>> allIncomes = [
    {"id": 1, "branch": "Thrissur", "date": DateTime(2025, 11, 2), "amount": 2500, "details": "Online Orders"},
    {"id": 2, "branch": "Ernakulam", "date": DateTime(2025, 11, 4), "amount": 1800, "details": "Walk-in Sales"},
    {"id": 3, "branch": "Thrissur", "date": DateTime(2025, 11, 6), "amount": 3100, "details": "Catering Income"},
    {"id": 4, "branch": "Kozhikode", "date": DateTime(2025, 10, 28), "amount": 2200, "details": "App Orders"},
    {"id": 5, "branch": "Palakkad", "date": DateTime(2025, 11, 1), "amount": 1400, "details": "POS Sales"},
  ];

  List<Map<String, dynamic>> filteredIncomes = [];
  double totalIncome = 0;

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
      filteredIncomes = allIncomes
          .where((income) =>
      income['branch'] == selectedBranch &&
          income['date'].isAfter(startDate!.subtract(const Duration(days: 1))) &&
          income['date'].isBefore(endDate!.add(const Duration(days: 1))))
          .toList();

      totalIncome = filteredIncomes.fold(0.0, (sum, item) => sum + item['amount']);
    });
  }

  String _formatDate(DateTime? date) {
    return date == null ? "Select Date" : DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income Report"),
        backgroundColor: Colors.green,
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
                icon: const Icon(Icons.assessment),
                label: const Text("Generate Report"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 🔹 Results List
            if (filteredIncomes.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    // Total Summary
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        "Total Income: ₹${totalIncome.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    // Income List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredIncomes.length,
                        itemBuilder: (context, index) {
                          final income = filteredIncomes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.attach_money, color: Colors.green),
                              title: Text(
                                income['details'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${DateFormat('dd MMM yyyy').format(income['date'])} • ${income['branch']}",
                              ),
                              trailing: Text(
                                "₹${income['amount']}",
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
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    "No income data found for selected branch and dates",
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
