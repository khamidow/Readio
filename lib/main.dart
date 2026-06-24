import 'package:audio_pdf_book_flutter/presentation/screens/audio_screen.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/main_screen.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/splash_screen.dart';
import 'package:audio_pdf_book_flutter/services/audio_player_service.dart';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/source/local/my_pref.dart';
import 'data/source/remote/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rzgojtuaapmzawiemqtf.supabase.co',
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6Z29qdHVhYXBtemF3aWVtcXRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyMzk5NzAsImV4cCI6MjA5NjgxNTk3MH0.H60oc1uLMa-h42jYZbCOAjcPNT4GkESGFrB0NAM1svk",
  );

  await Firebase.initializeApp();
  final authRepository = AuthRepository();
  await authRepository.initialize();
  MyPref.init();
  await initAudioService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashScreen(),
    );
  }
}
