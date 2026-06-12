import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds, then go to Profile Screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF1E6D2), // Calm Cream Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // YOUR APP ICON
            Image(
              image: AssetImage("assets/images/app_icon.png"),
              width: 180, // Adjust size as needed
              height: 180,
            ),
            SizedBox(height: 20),
            //APP NAME
            
          ],
        ),
      ),
    );
  }
}