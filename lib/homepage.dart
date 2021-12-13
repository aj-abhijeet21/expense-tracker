import 'dart:async';

import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/widgets/loading_circle.dart';
import 'package:expense_tracker/widgets/plus_button.dart';
import 'package:expense_tracker/widgets/top_card.dart';
import 'package:expense_tracker/widgets/transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textControllerAMOUNT = TextEditingController();
  final _textControllerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _enterTransaction() {
    GoogleSheetsApi.insert(
        _textControllerITEM.text, _textControllerAMOUNT.text, _isIncome);
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              elevation: 2.0,
              title: Text('N E W  T R A N S A C T I O N'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Expense',
                        ),
                        Switch(
                          value: _isIncome,
                          onChanged: (newValue) {
                            setState(() {
                              _isIncome = newValue;
                            });
                          },
                        ),
                        Text('Income'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?'),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter an amount';
                                }
                                return null;
                              },
                              controller: _textControllerAMOUNT,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?,'),
                            controller: _textControllerITEM,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: Colors.grey[600],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MaterialButton(
                              color: Colors.grey[600],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  'Enter',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _enterTransaction();
                                  Navigator.of(context).pop();
                                }
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  bool timerStarted = false;

  void startLoading() {
    timerStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerStarted == false) {
      startLoading();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TopNeuCard(
                balance: '₹' +
                    (GoogleSheetsApi.calculateIncome() -
                            GoogleSheetsApi.calculateExpense())
                        .toString(),
                expense: '₹' + GoogleSheetsApi.calculateExpense().toString(),
                income: '₹' + GoogleSheetsApi.calculateIncome().toString(),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: GoogleSheetsApi.loading == true
                              ? LoadingCircle()
                              : ListView.builder(
                                  itemCount: GoogleSheetsApi
                                      .currentTransactions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: MyTransaction(
                                          transactionName: GoogleSheetsApi
                                              .currentTransactions[index][0],
                                          money: GoogleSheetsApi
                                              .currentTransactions[index][1],
                                          expenseOrIncome: GoogleSheetsApi
                                              .currentTransactions[index][2]),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PlusButton(
                function: _newTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
