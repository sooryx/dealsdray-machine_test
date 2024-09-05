import 'dart:convert';
import 'dart:io';
import 'package:app_install_date/app_install_date_imp.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test/screens/loginpage/login_page.dart';
// import 'package:machine_test/screens/registrationpage/registration.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appInstallDate = 'Unknown';
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initPackageInfo();
    _initPlatformState();
    _sendDeviceInfo(); // Send device info after initialization
    // _navigateToLoginPage(deviceId);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _initPlatformState() async {
    late String installDate;
    try {
      final DateTime date = await AppInstallDate().installDate;
      installDate = date.toString();
    } catch (e, st) {
      debugPrint('Failed to load install date due to $e\n$st');
      installDate = 'Failed to load install date';
    }

    if (!mounted) return;

    setState(() {
      _appInstallDate = installDate;
    });
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'error': 'failed to get platform version'};
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Future<void> _sendDeviceInfo() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      var ipData = await ipAddress.getIpAddress();
      final responseBody = jsonEncode(<String, dynamic>{
        'deviceType': Platform.isAndroid ? 'android' : 'ios',
        'deviceId': _deviceData['id'] ?? 'Unknown',
        'deviceName': _deviceData['model'] ?? 'Unknown',
        'deviceOSVersion': _deviceData['version.release'] ?? 'Unknown',
        'deviceIPAddress': ipData.toString(),
        'lat': 9.9312, // Example latitude
        'long': 76.2673, // Example longitude
        'buyer_gcmid': '',
        'buyer_pemid': '',
        'app': {
          'version': _packageInfo.version,
          'installTimeStamp': _appInstallDate,
          'uninstallTimeStamp': '',
          'downloadTimeStamp': '',
        }
      });

      final response = await http.post(
          Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: responseBody);

      if (response.statusCode == 200) {
        // Successfully sent
         final responseData = jsonDecode(response.body);
         final deviceId = responseData['data']['deviceId'] ?? 'Unknown';
          _navigateToLoginPage(deviceId);
        print('resonse body :$responseBody');
        print(response.body);
        print('Device info sent successfully');
      } else {
        // Failed to send
        print('Failed to send device info');
      }
    } catch (e) {
      print('Error occurred while sending device info: $e');
    }
  }

  void _navigateToLoginPage(String deviceId) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  LoginPage(deviceid: deviceId,),
      ),
    );
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/download.jpeg',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            spinkit()
          ],
        ),
      ),
    );
  }

  Widget spinkit() {
    return const SpinKitFadingCircle(
      color: Colors.red,
      duration: Duration(milliseconds: 1200),
      size: 50.0,
    );
  }
}
