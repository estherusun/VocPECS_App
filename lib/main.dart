import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/album_library_screen.dart';
import 'screens/splash_screen.dart'; // Ensure this is imported
import 'screens/intro_screen.dart'; // Ensure this is imported
import 'providers/pecs_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PecsProvider(),
      child: const PolaPecsApp(),
    ),
  );
}

class PolaPecsApp extends StatelessWidget {
  const PolaPecsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolaPECS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1E6D2),
      ),
      // START THE APP AT THE SPLASH SCREEN
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/scanner': (context) => const ScannerScreen(),
        '/kanban': (context) => const KanbanScreen(),
        '/album_library': (context) => const AlbumLibraryScreen(),
        '/intro': (context) => const IntroScreen(),
      },
    );
  }
}