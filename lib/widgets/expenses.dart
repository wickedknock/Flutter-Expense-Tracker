import 'package:expense_tracker/db/database_helper.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  double total = 0;
  DateTime? currentDate;
  // final List<Expense> _registeredExpenses = [
  //   Expense(
  //       title: "chips",
  //       category: Category.food,
  //       amount: 24,
  //       date: DateTime.now()),
  //   Expense(
  //       title: "cake",
  //       category: Category.food,
  //       amount: 24,
  //       date: DateTime.now().add(const Duration(days: 1)))
  // ];

  List<Expense> _registeredExpenses = [];

  void totalValue() {
    if (_registeredExpenses.isEmpty) {
      total = 0;
    } else {
      var value = _registeredExpenses
          .map(
            (e) => e.amount,
          )
          .reduce((value, element) => value + element);
      total = value;
    }
  }

  addExpense(Expense expense) async {
    print('adding expense : ${expense.title}');
    await DatabaseHelper.insertExpense(expense);
    setState(() {
      _registeredExpenses.add(expense);
      totalValue();
    });
  }

  void removeExpense(Expense expense) async {
    await DatabaseHelper.deleteExpense(expense);
    final indexValue = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      total -= expense.amount;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () async {
            await DatabaseHelper.insertExpense(expense);
            setState(() {
              _registeredExpenses.insert(indexValue, expense);
            });
          },
        ),
      ),
    );
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 50, now.month, now.day);
    final last = DateTime(now.year + 50, now.month, now.day);
    final pickedValue = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: first,
      lastDate: last,
    );
    setState(() {
      currentDate = pickedValue;
    });
  }

  void openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(addExpense: addExpense));
  }

  void initializeData() async {
    _registeredExpenses = await DatabaseHelper.retrieveExpenses();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    totalValue();
    Widget mainContent = const Center(
      child: Text('No Expenses Found'),
    );
    List<Expense> myExpenses = _registeredExpenses;
    if (myExpenses.isNotEmpty) {
      if (currentDate != null) {
        myExpenses = _registeredExpenses.where((e) {
          return e.date.day == currentDate!.day;
        }).toList();
        mainContent =
            ExpensesList(list: myExpenses, onRemoveExpense: removeExpense);
      } else {
        mainContent =
            ExpensesList(list: myExpenses, onRemoveExpense: removeExpense);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Expenses"),
        actions: [
          IconButton(
            onPressed: openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: myExpenses),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _presentDatePicker,
                        child: const Text("Select Date"),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentDate = null;
                          });
                        },
                        child: const Text("Clear Date"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.difference,
                        color: Colors.amber,
                        border: Border.all(color: Colors.amber, width: 2.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total : $total",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ],
                    ))
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: myExpenses)),
                // Container(
                //   margin:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //   child: Row(
                //     children: [
                //       ElevatedButton(
                //         onPressed: _presentDatePicker,
                //         child: const Text("Select Date"),
                //       ),
                //       const Spacer(
                //         flex: 2,
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           setState(() {
                //             currentDate = null;
                //           });
                //         },
                //         child: const Text("Clear Date"),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: mainContent,
                ),
                // Container(
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         backgroundBlendMode: BlendMode.difference,
                //         color: Colors.amber,
                //         border: Border.all(color: Colors.amber, width: 2.0)),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           "Total : $total",
                //           style: const TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //               fontSize: 20),
                //         ),
                //       ],
                //     ))
              ],
            ),
    );
  }
}
