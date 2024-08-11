import 'dart:async';
import 'dart:convert';
import 'package:deals_dray_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final defaultPinTheme = PinTheme(
    height: 68,
    width: 64,
    textStyle: const TextStyle(fontSize: 22, color: Colors.black),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey)
    ),
  );

  late Timer _timer;
  int _start = 120;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 10;
      _canResendOtp = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
          _canResendOtp = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _resendOtp() {
    _startTimer();
  }

  Future<void> _sendOTPData() async {
    var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "otp":"9879",
        "deviceId":"62b43472c84bb6dac82e0504",
        "userId":"62b43547c84bb6dac82e0525"
      }),
    );

    try {
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const RegisterScreen())
        );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Image.asset('assets/otp.png', fit: BoxFit.cover,)
                  ),
                ),
                const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('OTP Verfication', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32), ),
                ),
                const SizedBox(height: 10,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('We have sent unique OTP number to your mobile number +91-1234567890', style: TextStyle(color: Colors.grey),),
                ),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    Pinput(
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(border: Border.all(color: Colors.black)),
                      onCompleted: (value) {
                        debugPrint(value);
                        // _sendOTPData(); API NOT WORKING
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const RegisterScreen())
                        );
                      },
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _canResendOtp
                              ? "0 second(s)"
                              : "$_start second(s)",
                          style: TextStyle(
                            color: _canResendOtp ? Colors.grey : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: _canResendOtp ? _resendOtp : null,
                          child: Text("SEND AGAIN", 
                            style: TextStyle(
                              color: _canResendOtp ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}