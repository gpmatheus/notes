
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/config/dependencies.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/ui/home/home_viewmodel.dart';
import 'package:notes/ui/home/widgets/home.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme
            .fromSeed(seedColor: Colors.orange.shade900)
            .copyWith(secondary: Colors.green.shade50),
        useMaterial3: true,
      ),
      home: Home(
        homeViewModel: HomeViewmodel(
          maintainNotes: context.read(),
          userRepository: context.read(),
        ),
      ),
    );
  }
}
