import 'dart:convert';
import 'dart:io';
import 'package:app_install_date/app_install_date_imp.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../screens/loginpage/login_page.dart';

class SplashsScreenProvider with ChangeNotifier {
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

  String get appInstallDate => _appInstallDate;
  PackageInfo get packageInfo => _packageInfo;
  Map<String, dynamic> get deviceData => _deviceData;

  SplashProvider() {
    initPlatformState();
    _initPackageInfo();
    _initPlatformState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
    notifyListeners();
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

    _appInstallDate = installDate;
    notifyListeners();
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
    _deviceData = deviceData;
    notifyListeners();
  }

  Future<void> sendDeviceInfo(BuildContext context) async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      var ipData = await ipAddress.getIpAddress();
      final responseBody = jsonEncode(<String, dynamic>{
        'deviceType': Platform.isAndroid ? 'android' : 'ios',
        'deviceId': _deviceData['id'] ?? 'Unknown',
        'deviceName': _deviceData['model'] ?? 'Unknown',
        'deviceOSVersion': _deviceData['version.release'] ?? 'Unknown',
        'deviceIPAddress': ipData.toString(),
        'lat': 9.9312,
        'long': 76.2673,
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
        final responseData = jsonDecode(response.body);
        final deviceId = responseData['data']['deviceId'] ?? 'Unknown';
        _navigateToLoginPage(context, deviceId);
      } else {
        debugPrint('Failed to send device info');
      }
    } catch (e) {
      debugPrint('Error occurred while sending device info: $e');
    }
  }

  void _navigateToLoginPage(BuildContext context, String deviceId) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(deviceid: deviceId),
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
}
