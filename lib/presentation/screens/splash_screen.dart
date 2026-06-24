import 'package:audio_pdf_book_flutter/presentation/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/source/local/my_pref.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds — must be in initState, never in build().
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyPref.getText("USERNAME") == "NULL"
              ? const LoginScreen()
              : const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            Image.asset(
              'assets/app_logo.png',
              height: 184,
              width: 184,
              fit: BoxFit.fill,
            ),
            const Positioned(
              bottom: 42,
              child: CupertinoActivityIndicator(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
