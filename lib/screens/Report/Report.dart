// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  final Map<String, double> chosenPlan = {
    'Food': 130.0,
    'Transportation': 390.0,
    'Utilities': 195.0,
    'Personal Spending': 351.0,
    'Recreation & Entertainment': 65.0,
    'Saving': 169.0,
  };

  final Map<String, double> actualSpending = {
    'Food': 250.0,
    'Transportation': 215.0,
    'Utilities': 210.0,
    'Personal Spending': 470.0,
    'Recreation & Entertainment': 100.0,
    'Saving': 50.0,
  };

  Map<String, double> generateNewPlan() {
    Map<String, double> newPlan = {};

    chosenPlan.forEach((category, budget) {
      final newBudget = budget * 0.9; // Adjust the percentage as per your requirements
      newPlan[category] = newBudget > 0 ? newBudget : 0;
    });

    return newPlan;
  }

  List<ChartItem> generateChartSeries() {
    final chosenData = chosenPlan.entries.map((entry) => ChartItem(entry.key, entry.value)).toList();
    final actualData = actualSpending.entries.map((entry) => ChartItem(entry.key, entry.value)).toList();

    return [
      ...chosenData,
      ...actualData,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Expense Tracker'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Expense Analysis:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Category', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Budget', style: TextStyle(color: Colors.blue))),
                      DataColumn(label: Text('Spending', style: TextStyle(color: Colors.green))),
                      DataColumn(label: Text('Difference', style: TextStyle(color: Colors.red))),
                    ],
                    rows: chosenPlan.entries
                        .map(
                          (entry) {
                            final category = entry.key;
                            final budget = entry.value;
                            final spending = actualSpending[category];
                            final difference = (budget - (spending ?? 0));

                            return DataRow(
                              cells: [
                                DataCell(Text(category)),
                                DataCell(Text(
                                  '\$${budget.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )),
                                DataCell(Text(
                                  '\$${(spending ?? 0).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:Colors.green,
                                  ),
                                )),
                                DataCell(Text(
                                  '\$${difference.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: difference < 0 ? Colors.red : Colors.white,
                                  ),
                                )),
                              ],
                            );
                          },
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Comparison:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...chosenPlan.entries.map((entry) {
                        final category = entry.key;
                        final budget = entry.value;
                        final spending = actualSpending[category];
                        final difference = (budget - (spending ?? 0));

                        return Padding(padding: EdgeInsets.only(right: 16.0),
                        child: BarChartItem(chosenPlan, category, budget, spending!, difference));
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Suggestion Plan:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('New Budget')),
                      ],
                      rows: generateNewPlan().entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text(entry.key)),
                            DataCell(Text('\$${entry.value.toStringAsFixed(2)}')),
                            ],
                            ),
                            )
                            .toList(),
                            ),
                            )
                            ],
                            ),
                            ),
                            ),
                            ),
                            );
                            }
                            }

class ChartItem {
  final String label;
  final double value;

  ChartItem(this.label, this.value);
}

class BarChartItem extends StatelessWidget {
  final Map<String, double> chosenPlan;
  final String category;
  final double budget;
  final double spending;
  final double difference;

  BarChartItem(this.chosenPlan, this.category, this.budget, this.spending, this.difference);

  @override
  Widget build(BuildContext context) {
    final double maxBarHeight = 150.0;
    final double barHeight = budget * maxBarHeight / chosenPlan.values.reduce((a, b) => a + b);

    return Column(
      children: [
        Text(category),
        SizedBox(height: 8.0),
        Container(
          width: 60.0,
          height: maxBarHeight,
          color: Colors.grey[300],
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 60.0,
                  height: barHeight,
                  color:difference < 0 ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Budget: \$${budget.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.blue),
        ),
        SizedBox(height: 4.0),
        Text(
          'Spending: \$${(spending).toStringAsFixed(2)}',
          style: TextStyle(color: Colors.green),
        ),
        SizedBox(height: 4.0),
        Text(
          'Difference: \$${difference.toStringAsFixed(2)}',
          style: TextStyle(color: difference < 0 ? Colors.red : Colors.white,
          ),
        ),
      ],
    );
  }
}
