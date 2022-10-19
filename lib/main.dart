import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/full_screen.dart';
import 'package:ltuc/screens/admin.dart';
import 'package:ltuc/screens/home.dart';
import 'package:ltuc/screens/register_screen.dart';
import 'package:ltuc/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
    // initialRoute: '/home',
    // routes: {
    //   '/splash': (context) => const SplashScreen(),
    //   '/register': (context) => const RegesterScreen(),
    //   '/home': (context) => const HomeScreen(),
    //   '/admin': (context) => const AdminScreen(),
    //   '/fullScreen': (context) => const FullScreen()
    // },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScreen();
  }
}
