import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktv/presentation/utility/permission_provider.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_alert_dialog.dart';

const platform = MethodChannel('com.kantayo.oktv/recording');
String outputPath = '';

class RecorderProvider extends ChangeNotifier {
  final PermissionProvider permissionProvider = PermissionProvider();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  void stop() { //Unused yet
    _isRecording = false;
    notifyListeners();
  }

  void start() { //Unused yet
    _isRecording = true;
    notifyListeners();
  }

  Future<void> startRecording(context) async {

    if (await permissionProvider.requestPermissions(context)) {
      try {
        final result = await platform.invokeMethod('startScreenRecording');
        if (result) {
          _isRecording = true;
          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording started')));
        } else {
          _isRecording = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording failed to start')));
        }
      } on PlatformException catch (e) {
        debugPrint("Failed to start recording: '${e.message}'.");
      }
    }
    notifyListeners();
  }

  Future<void> stopRecording(context) async {
    try {
      dynamic result = await platform.invokeMethod('stopScreenRecording');
      outputPath = result.toString();
      _isRecording = false;
      notifyListeners();
      mobileDialogContactDeveloper(
        context,
        'Recorded video saved',
        'You can get your recorded video at:\nInternal storage ➤ Pictures ➤ Oktv',
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to stop recording: '${e.message}'.");
    }
  }


}