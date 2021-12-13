import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
