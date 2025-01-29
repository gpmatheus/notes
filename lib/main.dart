import 'package:flutter/material.dart';
import 'package:notes/config/init.dart';
import 'package:notes/presentation/views/home.dart';

void main() async {
  await Init().configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notes.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade100),
        useMaterial3: true,
      ),
      home: Home()
    );
  }
}
