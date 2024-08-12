import 'dart:convert';
import 'package:deals_dray_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _buttonEnable = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      _buttonEnable =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  Future<void> _sendRegisterData() async {
    var url =
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": "muhammedrafnasvk@gmail.com",
        "password": "1234Rafnas",
        "referralCode": 12345678,
        "userId": "62a833766ec5dafd6780fc85"
      }),
    );

    try {
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Response : ${response.body}')),
        );
        print('Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
        print('Response: ${response.body}');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      print('Exception : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/dealsdray_logo.png',
                  opacity: const AlwaysStoppedAnimation(0.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Let\'s Begin!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please enter your credentials to proceed',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Your Email',
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Create Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isPasswordVisible,
                            ),
                            TextFormField(
                              controller: referralController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Referral Code (optional)',
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: _buttonEnable
                                ? () {
                                    _sendRegisterData();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(50, 50),
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color:
                                  _buttonEnable ? Colors.white : Colors.black,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
