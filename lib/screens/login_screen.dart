import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // const SizedBox(height: 50,),
            Image.asset('assets/dealsdray_logo.png', opacity: const AlwaysStoppedAnimation(0.5),),
            // const SizedBox(height: 50,),
            Container(
              // color: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
              child: const Text('Phone', style: 
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}