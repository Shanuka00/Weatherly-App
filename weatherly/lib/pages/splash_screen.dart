import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weatherly/pages/home_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Delay navigation to home page
    Timer(
      const Duration(seconds: 5), // Delay time
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 81, 112),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/spcloud.gif', width: 220, height: 220), // Gif width and height
            const SizedBox(height: 5),
            const Text(
              'Weatherly', // Text Weatherly
              style: TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}