// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_label, camel_case_types, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(plan ());
}

class plan extends StatelessWidget {
  const plan ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Planner',
      theme: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: BudgetPlannerScreen(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

class BudgetPlannerScreen extends StatefulWidget {
  @override
  _BudgetPlannerScreenState createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final TextEditingController _incomeController = TextEditingController();

  final Map<String, Map<String, Map<String, double>>> plans = {
  'Student': {
    'Budget-Friendly': {
      'Food': 20.0,
      'Transportation': 25.0,
      'Utilities': 10.0,
      'Personal Spending': 25.0,
      'Recreation & Entertainment': 10.0,
      'Saving': 10.0,
    },
    'Balanced Lifestyle': {
      'Food': 10.0,
      'Transportation': 30.0,
      'Utilities': 15.0,
      'Personal Spending': 27.0,
      'Recreation & Entertainment': 5.0,
      'Saving': 13.0,
    },
  },
  'Expatriate': {
    'Comfortable Living': {
      'Food': 22.0,
      'Transportation': 20.0,
      'Utilities': 20.0,
      'Personal Spending': 18.0,
      'Recreation & Entertainment': 8.0,
      'Saving': 12.0,
    },
    'Cost-Effective': {
      'Food': 25.0,
      'Transportation': 15.0,
      'Utilities': 30.0,
      'Personal Spending': 15.0,
      'Recreation & Entertainment': 7.0,
      'Saving': 8.0,
    },
  },
  'Graduate': {
    'Independent Living': {
      'Food': 10.0,
      'Transportation': 50.0,
      'Utilities': 15.0,
      'Personal Spending': 15.0,
      'Recreation & Entertainment': 5.0,
      'Saving': 5.0,
    },
    'Pocket-friendly': {
      'Food': 10.0,
      'Transportation': 50.0,
      'Utilities': 13.0,
      'Personal Spending': 7.0,
      'Recreation & Entertainment': 10.0,
      'Saving': 10.0,
    },
  },
};

  late String selectedCategory = 'Student';
  late String selectedPlan = 'Budget-Friendly';
  double? income;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategory = prefs.getString('selectedCategory') ?? 'Student';
    selectedPlan = prefs.getString('selectedPlan') ?? 'Budget-Friendly';
    income = prefs.getDouble('income');
    if (income != null) {
      _incomeController.text = income!.toString();
    }
    setState(() {});
  }

  void _saveSelectedCategory(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCategory', category);
  }

  void _saveSelectedPlan(String plan) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPlan', plan);
  }

  Future<void> _saveIncome(double income) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('income', income);
  }

  void onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category!;
    });
    _saveSelectedCategory(selectedCategory);
  }

  void onPlanSelected(String? plan) {
    setState(() {
      selectedPlan = plan!;
    });
    _saveSelectedPlan(selectedPlan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
          ),
        title: Text('Budget Planner'),
      ),
      body: Theme(
      data: Theme.of(context),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter your monthly income:',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 7),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 14),
            Text(
              'Choose your category:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategorySelectionTile(
                  category: 'Student',
                  isSelected: selectedCategory == 'Student',
                  onTap: onCategorySelected,
                ),
                SizedBox(width: 14),
                CategorySelectionTile(
                  category: 'Expatriate',
                  isSelected: selectedCategory == 'Expatriate',
                  onTap: onCategorySelected,
                ),
                SizedBox(width: 14),
                CategorySelectionTile(
                  category: 'Graduate',
                  isSelected: selectedCategory == 'Graduate',
                  onTap: onCategorySelected,
                ),
              ],
            ),
            SizedBox(height: 14),
            Text(
              'Choose a plan:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            Expanded(
              child: ListView(
                children: (plans[selectedCategory]?.keys ?? []).map((plan) {
                  return PlanSelectionTile(
                    plan: plan,
                    isSelected: selectedPlan == plan,
                    onTap: onPlanSelected,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () async {
                final double? enteredIncome = double.tryParse(_incomeController.text);

                if (enteredIncome != null) {
                  income = enteredIncome;
                  await _saveIncome(income!);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Suggested Plan'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: (plans[selectedCategory]?[selectedPlan]?.entries ?? []).map((entry) {
                            final category = entry.key;
                            final percentage = entry.value;
                            final allocation = (income! * (percentage / 100)).toStringAsFixed(2);
                            return Text('$category: $allocation');
                          }).toList(),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Show the decorated plan details screen here
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlanDetailsScreen(
                                    selectedCategory: selectedCategory,
                                    selectedPlan: selectedPlan,
                                    income: income!,
                                    planDetails: plans[selectedCategory]![selectedPlan]!,
                                  ),
                                ),
                              );
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Invalid Input'),
                        content: Text('Please enter a valid monthly income.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
      )
    );
  }
}

class CategorySelectionTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final void Function(String?) onTap;

  CategorySelectionTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(category),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        margin: EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? Colors.blue : Colors.grey[300],
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
              ),
          ],
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class PlanSelectionTile extends StatelessWidget {
  final String plan;
  final bool isSelected;
  final void Function(String?) onTap;

  PlanSelectionTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(plan),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        margin: EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? Colors.blue : Colors.grey[300],
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              plan,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class PlanDetailsScreen extends StatelessWidget {
  final String selectedCategory;
  final String selectedPlan;
  final double income;
  final Map<String, double> planDetails;

  PlanDetailsScreen({
    required this.selectedCategory,
    required this.selectedPlan,
    required this.income,
    required this.planDetails,
  });

  final Map<String, IconData> categoryIcons ={
    'Food': Icons.restaurant,
    'Transportation': Icons.emoji_transportation_outlined,
    'Utilities': Icons.category,
    'Personal Spending': Icons.house,
    'Recreation & Entertainment': Icons.tv,
    'Saving': Icons.attach_money
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Category: $selectedCategory',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Selected Plan: $selectedPlan',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Monthly Income: $income',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Plan Details:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: planDetails.entries.map((entry) {
                    final category = entry.key;
                    final percentage = entry.value;
                    final allocation = (income * (percentage / 100)).toStringAsFixed(2);
                    final icon = categoryIcons[category];

                    return ListTile(
                      leading: Icon(icon ?? Icons.category),
                      title: Text(
                        '$category: $allocation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save plan logic
                Navigator.pop(context);
              },
              child: Text('Save Plan'),
            ),
          ],
        ),
      ),
    );
  }
}

