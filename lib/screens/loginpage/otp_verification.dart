import 'dart:async'; // Import for Timer
import 'dart:convert'; // Import for JSON encoding

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:machine_test/provider/auth_service_provider.dart';
import 'package:machine_test/screens/registrationpage/registration.dart';
import 'package:machine_test/widgets/custom_toast_messages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

// import 'package:machine_test/register_page.dart'; // Assuming this is your register page

class OTPVerificationScreen extends StatefulWidget {
  final String userId;
  final String deviceId;
  final String mobileNumber;

  const OTPVerificationScreen({
    super.key,
    required this.userId,
    required this.deviceId,
    required this.mobileNumber,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _start = 60; // Countdown start time in seconds
  String _otp = '';
  bool _isResending = false; // Flag to handle resend state

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get _timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobileNumber': widget.mobileNumber,
          'deviceId': widget.deviceId,
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Successfully resent OTP
        print('OTP resend successful: ${response.body}');
        setState(() {
          _start = 60; // Reset timer
          _startTimer(); // Restart timer
          _isResending = false;
        });
      } else {
        // Failed to resend OTP
        print('Failed to resend OTP');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to resend OTP')),
        );
        setState(() {
          _isResending = false;
        });
      }
    } catch (e) {
      print('Error occurred while resending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while resending OTP')),
      );
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Image.asset('assets/icons/otp.png'),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text(
              "OTP Verification",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text(
              "We have sent a unique OTP number to your mobile +91-${widget.mobileNumber}",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(9),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveColor: Colors.grey,
                activeColor: Colors.green,
                selectedColor: Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  _otp = value;
                });
                // Automatically verify OTP when it is filled
                if (value.length == 4) {
                  final authProvider = Provider.of<AuthServiceProvider>(
                      context,
                      listen: false);
                  try {
                    authProvider.verifyOtp(
                        otp: value,
                        deviceID: widget.deviceId,
                        userID: authProvider.userID,
                        context: context);
                  } catch (e) {
                    customErrorToast(context, e.toString());
                  }
                }
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideCountdown(
                    duration: Duration(seconds: 120),
                    slideDirection: SlideDirection.down,
                    separatorType: SeparatorType.symbol,
                    suffixIcon: Icon(
                      Icons.timer,
                      color: Colors.grey,
                    ),
                    separator: ':',
                    decoration: BoxDecoration(color: Colors.transparent),
                    style: TextStyle(
                        fontSize: 15.sp)), // Display the countdown timer
                InkWell(
                  onTap: () {
                    if (_start == 0 && !_isResending) {
                      _resendOtp();
                    }
                  },
                  child: Text(
                    _isResending ? 'Resending...' : 'SEND AGAIN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
