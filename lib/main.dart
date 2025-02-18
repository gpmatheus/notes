
import 'package:flutter/material.dart';
import 'package:notes/config/dependencies.dart';
import 'package:notes/ui/home/home_viewmodel.dart';
import 'package:notes/ui/home/widgets/home.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'notes .',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade100),
        useMaterial3: true,
      ),
      home: Home(
        homeViewModel: HomeViewmodel(
          maintainNotes: context.read(),
        ),
      )
    );
  }
}
