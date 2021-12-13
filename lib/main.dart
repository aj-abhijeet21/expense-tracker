import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  GoogleSheetsApi().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
