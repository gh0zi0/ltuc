import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  check() async {
    String auth;
    auth = FirebaseAuth.instance.currentUser?.uid ?? '';
    await Future.delayed(const Duration(milliseconds: 1000));
    if (auth != '') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/register', (route) => false);
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('lottie/splash.json',
            height: 250, width: 250, repeat: false),
      ),
    );
  }
}
