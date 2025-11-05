import 'package:flutter/material.dart';
import 'package:kljcafe_admin/widget/product/productlis.dart';

import 'product/addproduct.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Define your dashboard sections
  final List<String> sections = [
    "Products",
    "Combos",
    "Wallet Offers",
    "Referral Offers",
    "Posters",
    "Reports",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Container(),
        title:  Text("Admin Dashboard",style: TextStyle(fontSize: 18),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          // ---------- Sidebar Menu ----------
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_offer_outlined),
                selectedIcon: Icon(Icons.local_offer),
                label: Text('Combos'),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.person_outline_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('Employees'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('Wallet Offers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.share_outlined),
                selectedIcon: Icon(Icons.share),
                label: Text('Referral'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.image_outlined),
                selectedIcon: Icon(Icons.image),
                label: Text('Posters'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Reports'),
              ),
            ],
          ),

          // ---------- Main Dashboard Area ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Dynamic Section Builder ----------
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildProductsSection();
      case 1:
        return _buildCombosSection();
      case 2:
        return _buildEmployeesSection();
      case 3:
        return _buildWalletOfferSection();
      case 4:
        return _buildReferralOfferSection();
      case 5:
        return _buildPostersSection();
      case 6:
        return _buildReportsSection();
      default:
        return const Center(child: Text("Select an option"));
    }
  }

  // ---------- Products Section ----------
  Widget _buildProductsSection() {
    return _sectionTemplate(
      title: "Products",
      buttons: [
        _actionButton("Add Product"),
        _actionButton("Product List"),
      ],
    );
  }

  // ---------- Combos Section ----------
  Widget _buildCombosSection() {
    return _sectionTemplate(
      title: "Combos",
      buttons: [
        _actionButton("Add Combo"),
        _actionButton("Edit Combo"),
        _actionButton("Delete Combo"),
        _actionButton("Combo List"),
      ],
    );
  }

  Widget _buildEmployeesSection() {
    return _sectionTemplate(
      title: "Employees",
      buttons: [
        _actionButton("Add Employee"),
        _actionButton("Employee List"),

      ],
    );
  }

  // ---------- Wallet Offer Section ----------
  Widget _buildWalletOfferSection() {
    return _sectionTemplate(
      title: "Wallet Offers",
      buttons: [
        _actionButton("Add Wallet Offer"),
        _actionButton("Edit Wallet Offer"),
      ],
    );
  }

  // ---------- Referral Offer Section ----------
  Widget _buildReferralOfferSection() {
    return _sectionTemplate(
      title: "Referral Offers",
      buttons: [
        _actionButton("Add Referral Offer"),
        _actionButton("Edit Referral Offer"),
      ],
    );
  }

  // ---------- Posters Section ----------
  Widget _buildPostersSection() {
    return _sectionTemplate(
      title: "Posters",
      buttons: [
        _actionButton("Add Poster"),
        _actionButton("Poster List"),
      ],
    );
  }

  // ---------- Reports Section ----------
  Widget _buildReportsSection() {
    return _sectionTemplate(
      title: "Reports",
      buttons: [
        _actionButton("Income Report"),
        _actionButton("Expense Report"),
        _actionButton("Wage Report"),
      ],
    );
  }

  // ---------- Helper Widgets ----------
  Widget _sectionTemplate({required String title, required List<Widget> buttons}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: buttons,
        ),
      ],
    );
  }

  Widget _actionButton(String label) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label clicked')),
        );

        if(label.compareTo("Add Product")==0)
          {


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddProductPage(),
              ),
            );
          }
        else if(label.compareTo("Product List")==0)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListPage(),
              ),
            );
          }



       else if(label.compareTo("Add Referral Offer")==0)
          {

            showReferralDialog(context);


          }
        else if(label.compareTo("Edit Referral Offer")==0)
          {

            showReferralDialog(context);
          }
        else if(label.compareTo("Add Wallet Offer")==0)
          {
            showWalletOfferDialog(context);
          }
        else if(label.compareTo("Edit Wallet Offer")==0)
        {
          showWalletOfferDialog(context);
        }



      },
      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }



  void showReferralDialog(BuildContext context) {
    final TextEditingController firstPersonController = TextEditingController();
    final TextEditingController secondPersonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Referral Percentage Setup",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstPersonController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "1st Person Referral %",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: secondPersonController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "2nd Person Referral %",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
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
                String first = firstPersonController.text;
                String second = secondPersonController.text;

                // Validation (optional)
                if (first.isEmpty || second.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter both percentages")),
                  );
                  return;
                }

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Referral saved: 1st = $first%, 2nd = $second%")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }





  void showWalletOfferDialog(BuildContext context) {
    final TextEditingController walletPercentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Wallet Offer Setup",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: walletPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Wallet Offer Percentage",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  suffixText: "%",
                ),
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
                String percent = walletPercentController.text.trim();

                if (percent.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter wallet offer percentage")),
                  );
                  return;
                }

                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Wallet offer set to $percent%")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }


}
