import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommissionReportScreen extends StatefulWidget {
  const CommissionReportScreen({super.key});

  @override
  State<CommissionReportScreen> createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedBranch;

  final List<String> branches = [
    'Thrissur',
    'Ernakulam',
    'Kozhikode',
    'Palakkad'
  ];

  // 🔹 Dummy data (replace with backend data)
  final List<Map<String, dynamic>> allCommissions = [
    {
      "customer": "Anand",
      "branch": "Thrissur",
      "date": DateTime(2025, 11, 2),
      "commission": 120.0
    },
    {
      "customer": "Divya",
      "branch": "Ernakulam",
      "date": DateTime(2025, 11, 3),
      "commission": 200.0
    },
    {
      "customer": "Anand",
      "branch": "Thrissur",
      "date": DateTime(2025, 11, 4),
      "commission": 150.0
    },
    {
      "customer": "Manu",
      "branch": "Kozhikode",
      "date": DateTime(2025, 11, 5),
      "commission": 300.0
    },
    {
      "customer": "Divya",
      "branch": "Ernakulam",
      "date": DateTime(2025, 11, 6),
      "commission": 180.0
    },
  ];

  List<Map<String, dynamic>> filteredData = [];
  double totalCommission = 0.0;

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

  String _formatDate(DateTime? date) {
    return date == null ? "Select Date" : DateFormat('dd MMM yyyy').format(date);
  }

  void _generateReport() {
    if (selectedBranch == null || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select branch and date range")),
      );
      return;
    }

    setState(() {
      // Filter by branch and date range
      final results = allCommissions
          .where((entry) =>
      entry['branch'] == selectedBranch &&
          entry['date'].isAfter(startDate!.subtract(const Duration(days: 1))) &&
          entry['date'].isBefore(endDate!.add(const Duration(days: 1))))
          .toList();

      // Group by customer and sum commissions
      final Map<String, double> grouped = {};
      for (var entry in results) {
        final name = entry['customer'];
        grouped[name] = (grouped[name] ?? 0) + entry['commission'];
      }

      // Convert map to list
      filteredData = grouped.entries
          .map((e) => {"customer": e.key, "commission": e.value})
          .toList();

      totalCommission =
          filteredData.fold(0.0, (sum, item) => sum + item['commission']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commission Report"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Branch Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Branch",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedBranch,
              items: branches
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (value) => setState(() => selectedBranch = value),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // 🔹 Generate Button
            ElevatedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.analytics_outlined),
              label: const Text("Generate Report"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Results
            if (filteredData.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Text(
                        "Total Commission: ₹${totalCommission.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(Icons.person_outline,
                                  color: Colors.deepPurple),
                              title: Text(
                                item['customer'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                "₹${item['commission'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
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
                    "No commission data for selected branch and date range",
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
