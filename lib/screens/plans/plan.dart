// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_label, camel_case_types, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: MediaQuery.of(context).platformBrightness,
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
  'student': {
    'plan1': {
      'Food': 20.0,
      'Transportation': 25.0,
      'Utilities': 10.0,
      'Personal Spending': 25.0,
      'Recreation & Entertainment': 10.0,
      'Saving': 10.0,
    },
    'plan2': {
      'Food': 10.0,
      'Transportation': 30.0,
      'Utilities': 15.0,
      'Personal Spending': 27.0,
      'Recreation & Entertainment': 5.0,
      'Saving': 13.0,
    },
  },
  'expatriate': {
    'plan1': {
      'Food': 22.0,
      'Transportation': 20.0,
      'Utilities': 20.0,
      'Personal Spending': 18.0,
      'Recreation & Entertainment': 8.0,
      'Saving': 12.0,
    },
    'plan2': {
      'Food': 25.0,
      'Transportation': 15.0,
      'Utilities': 30.0,
      'Personal Spending': 15.0,
      'Recreation & Entertainment': 7.0,
      'Saving': 8.0,
    },
  },
  'graduate': {
    'plan1': {
      'Food': 10.0,
      'Transportation': 50.0,
      'Utilities': 15.0,
      'Personal Spending': 15.0,
      'Recreation & Entertainment': 5.0,
      'Saving': 5.0,
    },
  },
};

  late String selectedCategory = 'student';
  late String selectedPlan = 'plan1';
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
    selectedCategory = prefs.getString('selectedCategory') ?? 'student';
    selectedPlan = prefs.getString('selectedPlan') ?? 'plan1';
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
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Choose your category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategorySelectionTile(
                  category: 'student',
                  isSelected: selectedCategory == 'student',
                  onTap: onCategorySelected,
                ),
                SizedBox(width: 20),
                CategorySelectionTile(
                  category: 'expatriate',
                  isSelected: selectedCategory == 'expatriate',
                  onTap: onCategorySelected,
                ),
                SizedBox(width: 20),
                CategorySelectionTile(
                  category: 'graduate',
                  isSelected: selectedCategory == 'graduate',
                  onTap: onCategorySelected,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Choose a plan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
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
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue : Colors.grey[300],
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 18,
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
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue : Colors.grey[300],
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              plan,
              style: TextStyle(
                fontSize: 18,
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

  @override
  Widget build(BuildContext context) {
    
    // You can use the data from `selectedCategory`, `selectedPlan`, `income`, and `planDetails`
    // to display the information in a visually appealing way.
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Selected Plan: $selectedPlan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Monthly Income: $income',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Plan Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: planDetails.length,
                itemBuilder: (context, index) {
                  final category = planDetails.keys.elementAt(index);
                  final percentage = planDetails.values.elementAt(index);
                  final allocation = (income * (percentage / 100)).toStringAsFixed(2);

                  return Text('$category: $allocation');
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // to be used to fill in the plan numbers in another file.
                // You can use the data from `selectedCategory`, `selectedPlan`, `income`, and `planDetails`.
                // You may save this data in a desired format (e.g., JSON) to be used in another file or screen.
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
