import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test/provider/auth_service_provider.dart';
import 'package:machine_test/screens/loginpage/otp_verification.dart';
import 'package:machine_test/widgets/custom_toast_messages.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String deviceid;

  const LoginPage({
    super.key,
    required this.deviceid,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _phoneController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/download.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 40,
                  width: 240,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Phone'),
                      Tab(text: 'Email'),
                    ],
                    indicator: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPhoneTab(),
                    _buildEmailTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Glad to See You!",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please provide your phone number',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20),
          TextField(
            focusNode: _focusNode,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Phone',

              // Add additional styling if needed
            ),
          ),
          const SizedBox(height: 20),
          Consumer<AuthServiceProvider>(
            builder: (context, authProvider, child) {
              return Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: authProvider.isLoading ? Center(child: CircularProgressIndicator(color: Colors.red,)):ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    // Check if the phone number field is empty
                    if (_phoneController.text.isEmpty) {
                      customErrorToast(
                          context, 'Please enter your phone number');
                      return;
                    }

                    // Validate phone number format (example regex for Indian phone numbers)
                    final phoneNumberRegex = RegExp(r'^[6-9]\d{9}$');
                    if (!phoneNumberRegex.hasMatch(_phoneController.text)) {
                      customErrorToast(
                          context, "Please enter a valid phone number");
                      return;
                    }

                    customRandomToast(context, "Sending OTP...");



                    try {
                      await authProvider.sendOtpRequest(
                        phoneController: _phoneController,
                        deviceID: widget.deviceid,
                        context: context,
                      );

                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => OTPVerificationScreen(
                            userId: authProvider.userID,
                            deviceId: widget.deviceid,
                            mobileNumber: _phoneController.text,
                          ),
                        ),
                      );
                    } catch (e) {
                      customErrorToast(
                          context, "Failed to send OTP. Please try again.");
                    }
                  },
                  child: const Text(
                    'Send Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Glad to See You!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please provide your email address',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Email',
                // Add additional styling if needed
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Implement email tab functionality if needed
                },
                child: const Text(
                  'Send Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
