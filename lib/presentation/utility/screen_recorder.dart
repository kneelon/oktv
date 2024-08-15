
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktv/presentation/utility/permission_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//
// const platform = MethodChannel('com.kantayo.oktv/recording');
// String outputPath = '';
//
// PermissionProvider permissionProvider = PermissionProvider();
//
// Future<void> startRecording(context) async {
//
//   if (await permissionProvider.requestPermissions(context)) {
//     try {
//       final result = await platform.invokeMethod('startScreenRecording');
//       if (result) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording started')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording failed to start')));
//       }
//     } on PlatformException catch (e) {
//       debugPrint("Failed to start recording: '${e.message}'.");
//     }
//   }
// }
//
// Future<void> stopRecording(context) async {
//   try {
//     dynamic result = await platform.invokeMethod('stopScreenRecording');
//     outputPath = result.toString();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recording saved to: $result')));
//     debugPrint('>>> OUTPUT $outputPath');
//
//   } on PlatformException catch (e) {
//     debugPrint("Failed to stop recording: '${e.message}'.");
//   }
// }

// Future<bool> requestPermissions(context) async {
//   if (await Permission.microphone.request().isGranted &&
//       await _requestStoragePermission(context)) {
//     return true;
//   }
//   ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Permission not allowed, go to settings')));
//   return false;
// }
//
// Future<bool> _requestStoragePermission(context) async {
//   if (Platform.isAndroid) {
//     if (await _isAndroid11OrAbove()) {
//       if (await Permission.manageExternalStorage.request().isGranted) {
//         return true;
//       } else {
//         openAppSettings();
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Please grant storage permission in settings')));
//         return false;
//       }
//     } else {
//       if (await Permission.storage.request().isGranted) {
//         return true;
//       } else {
//         openAppSettings();
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Please grant storage permission in settings')));
//         return false;
//       }
//     }
//   }
//   return false;
// }
//
// Future<bool> _isAndroid11OrAbove() async {
//   return (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 30;
// }