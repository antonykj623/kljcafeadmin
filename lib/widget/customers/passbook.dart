import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PassbookScreen extends StatefulWidget {
  final String customerName;
  final String branch;

  const PassbookScreen({
    super.key,
    required this.customerName,
    required this.branch,
  });

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  final List<Map<String, dynamic>> transactions = [
    {
      "date": DateTime(2025, 11, 1),
      "type": "Income",
      "amount": 500.0,
      "desc": "Deposit"
    },
    {
      "date": DateTime(2025, 11, 2),
      "type": "Expense",
      "amount": 200.0,
      "desc": "Purchase"
    },
    {
      "date": DateTime(2025, 11, 3),
      "type": "Income",
      "amount": 350.0,
      "desc": "Referral Bonus"
    },
    {
      "date": DateTime(2025, 11, 4),
      "type": "Expense",
      "amount": 150.0,
      "desc": "Cafe Bill"
    },
  ];

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    totalIncome = transactions
        .where((t) => t['type'] == 'Income')
        .fold(0.0, (sum, t) => sum + t['amount']);
    totalExpense = transactions
        .where((t) => t['type'] == 'Expense')
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  @override
  Widget build(BuildContext context) {
    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.customerName}'s Passbook"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                children: [
                  Text(
                    "Branch: ${widget.branch}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Total Income: ₹${totalIncome.toStringAsFixed(2)}",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total Expense: ₹${totalExpense.toStringAsFixed(2)}",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    "Balance: ₹${balance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: balance >= 0 ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        t['type'] == 'Income'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: t['type'] == 'Income'
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                      title: Text(t['desc']),
                      subtitle: Text(
                          DateFormat('dd MMM yyyy').format(t['date'] as DateTime)),
                      trailing: Text(
                        "₹${t['amount'].toStringAsFixed(2)}",
                        style: TextStyle(
                          color: t['type'] == 'Income'
                              ? Colors.green
                              : Colors.redAccent,
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
      ),
    );
  }
}
