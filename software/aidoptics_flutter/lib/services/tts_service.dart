import 'package:flutter_tts/flutter_tts.dart';

import '../app/app.logger.dart';

class TTSService {
  final log = getLogger('TTS_Service');

  FlutterTts _flutterTts = FlutterTts();
  // TtsState _ttsState = TtsState.stopped;
  // TtsState get ttsState => _ttsState;

  Future speak(String text) async {
    var result = await _flutterTts.speak(text);
    if (result == 1) {
      // _ttsState = TtsState.playing;
      // notifyListeners();
    }
  }
//
// Future stop() async {
//   var result = await flutterTts.stop();
//   if (result == 1) {
//     _ttsState = TtsState.stopped;
//     notifyListeners();
//   }
// }
}
