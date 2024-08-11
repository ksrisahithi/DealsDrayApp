import 'package:deals_dray_app/screens/home_screen.dart';
import 'package:deals_dray_app/screens/login_screen.dart';
import 'package:deals_dray_app/screens/otp_screen.dart';
import 'package:deals_dray_app/screens/register_screen.dart';
import 'package:deals_dray_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Deals Dray',
      home: HomeScreen()
    );
  }
}

