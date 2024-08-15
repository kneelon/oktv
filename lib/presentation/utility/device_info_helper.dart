
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoHelper {

  static Future<bool> isTablet(context) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    bool isTablet = false;

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      isTablet = androidDeviceInfo.systemFeatures.contains('android.hardware.screen.landscape');
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      isTablet = iosDeviceInfo.model.toLowerCase().contains('ipad');
    }

    return isTablet;
  }

  static Future<bool> isFoldableDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String model = androidInfo.model.toLowerCase();
    // List of known foldable devices
    List<String> foldableModels = [
      'sm-f900', // Samsung Galaxy Fold
      'sm-f700', // Samsung Galaxy Z Flip
      'sm-f916', // Samsung Galaxy Z Fold 2
      'sm-f926', // Samsung Galaxy Z Fold 3
      'sm-f711', // Samsung Galaxy Z Flip 3
    ];

    return foldableModels.any((foldableModel) => model.startsWith(foldableModel));
  }
}