import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test/screens/entrypoint/entry_point.dart';
import 'package:machine_test/widgets/custom_toast_messages.dart';

import '../screens/registrationpage/registration.dart';

class AuthServiceProvider with ChangeNotifier {

  String _userID = '';
  String get userID => _userID;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendOtpRequest(
      {required TextEditingController phoneController,
      required String deviceID,
      required BuildContext context}) async {
    final mobileNumber = phoneController.text;
    final deviceId = deviceID;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobileNumber': mobileNumber,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200) {
        print("Response Body For Login:${response.body}");
        final responseData = jsonDecode(response.body);

        _userID = responseData['data']['userId'] ?? 'UnKnown';
        print('OTP request successful: ${responseData}');
        _isLoading = false;
        notifyListeners();
      } else {
        String errorMessage = 'Failed to send OTP request';
        throw Exception(errorMessage);

      }
    } catch (e) {
      throw Exception('Error occurred while sending OTP request: $e');
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required String deviceID,
    required String userID,
    required BuildContext context,
  }) async {
    final String postData = jsonEncode(<String, String>{
      'otp': otp,
      'deviceId': deviceID,
      'userId': userID,
    });

    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: postData,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('OTP Response body :${response.statusCode}${response.body}');

        if (responseData['status'] == 3 && responseData['data']['message'] == 'Invalid OTP') {
          customErrorToast(context, "Invalid OTP");
        } else {
          print('OTP verification successful: ${response.body}');

          // Check registration status and navigate accordingly
          if (responseData['data']['registration_status'] == 'Incomplete') {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => RegistrationPage(userId: userID),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => EntryPoint(),
              ),
            );
          }
        }
      } else {
        // Failed to verify OTP
        print('Failed to verify OTP');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verification failed')),
        );
      }
    } catch (e) {
      print('Error occurred while verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> userRegistration(
  {
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController referalCodeController,
    required String userID,
    required BuildContext context,
}
      ) async {
    final email = emailController.text;
    final password = passwordController.text;
    final referralCode = referalCodeController.text;



    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'referralCode': referralCode,
          'userId': userID,
        }),
      );

      if (response.statusCode == 200) {
        // Registration successful
        print('Registration successful: ${response.body}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EntryPoint(),
          ),
        );
      } else {
        // Registration failed
        print('Failed to register');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    } catch (e) {
      print('Error occurred during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred during registration')),
      );
    }
  }

}
