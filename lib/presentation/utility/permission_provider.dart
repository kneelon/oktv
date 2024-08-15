import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  //bool _isRecording = false;
  bool _isMicPermissionGranted = false;
  bool _isStoragePermissionGranted = false;

  //bool get isRecording => _isRecording;
  bool get isMicGranted => _isMicPermissionGranted;
  bool get isStorageGranted => _isStoragePermissionGranted;

  // void toggle() {
  //   _isFullWidth = !_isFullWidth;
  //   notifyListeners();
  // }



  Future<bool> requestPermissions(context) async {
    if (await Permission.microphone.request().isGranted &&
        await _requestStoragePermission(context)) {
      _isMicPermissionGranted = true;
      notifyListeners();
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission not allowed, go to settings')));
    _isMicPermissionGranted = false;
    notifyListeners();
    return false;
  }

  Future<bool> _requestStoragePermission(context) async {
    if (Platform.isAndroid) {
      if (await _isAndroid11OrAbove()) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          _isStoragePermissionGranted = true;
          notifyListeners();
          return true;
        } else {
          openAppSettings();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please grant storage permission in settings')));
          _isStoragePermissionGranted = false;
          notifyListeners();
          return false;
        }
      } else {
        if (await Permission.storage.request().isGranted) {
          _isStoragePermissionGranted = true;
          notifyListeners();
          return true;
        } else {
          openAppSettings();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please grant storage permission in settings')));
          _isStoragePermissionGranted = false;
          notifyListeners();
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> _isAndroid11OrAbove() async {
    return (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 30;
  }
}