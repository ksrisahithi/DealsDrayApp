import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneController = TextEditingController();
  bool _buttonDisable = false;

  String? _validatePhoneNumber(String? value) {
    final phoneExp = RegExp(r'^\d{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!phoneExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      _buttonDisable = phoneController.text.isNotEmpty;
    });
  }

  Future<void> _sendPhoneData() async {
    var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "mobileNumber": "9011470243",
        // "mobileNumber":phoneController.text,
        "deviceId": "62b341aeb0ab5ebe28a758a3",
      }),
    );

    try {
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => OtpScreen(
                  phoneNumber: phoneController.text,
                )));
      } else {
        print('Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Exception : $e');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/dealsdray_logo.png',
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.red),
                child: const Text(
                  'Phone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Glad to see you!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Please provide your number',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          validator: _validatePhoneNumber,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _buttonDisable
                              ? () {
                                  _sendPhoneData();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'SEND CODE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
