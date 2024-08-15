
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;

class CustomVoiceToText {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String textResult = constants.empty;
  int _stop = 0;
  final List<VoidCallback> _listeners = [];

  CustomVoiceToText({int? stopFor}) {
    _stop = stopFor ?? 4;
  }

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void startListening() {
    textResult = constants.empty;
    _speechToText.listen(
      onResult: _onSpeechResult,
      pauseFor: Duration(seconds: _stop),
      onSoundLevelChange: _onSoundLevelChange,
    ).then((_) {
      notifyListeners();
    }).catchError((error) {
      debugPrint('Error starting to listen: $error');
    });
    Future.delayed(Duration(seconds: _stop + 1), _status);
  }

  void stop() async {
    await _speechToText.stop();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    textResult = result.recognizedWords;
    if (isNotListening) {
      stop();
    }
  }

  void _onSoundLevelChange(double level) {
    // Handle sound level changes if needed
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void _status() {
    if (_speechToText.lastStatus == "done" && textResult.isEmpty) {
      stop();
    }
  }

  bool get speechEnabled => _speechEnabled;

  bool get isListening => _speechToText.isListening;

  bool get isNotListening => !_speechToText.isListening;

  String get speechResult => textResult;
}
