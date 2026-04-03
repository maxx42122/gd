import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

enum VoicePermissionStatus { granted, denied, permanentlyDenied }

class VoiceService {
  static VoiceService? _instance;
  static VoiceService get instance => _instance ??= VoiceService._();
  VoiceService._();

  final _speech = stt.SpeechToText();
  bool _initialized = false;

  void Function(String)? _onPartial;
  void Function(String)? _onFinal;
  void Function(String)? _onError;
  void Function()? _onDone;

  bool get isListening => _speech.isListening;

  // ── Permission ─────────────────────────────────────────────────────────────

  Future<VoicePermissionStatus> requestPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return VoicePermissionStatus.granted;
    if (status.isPermanentlyDenied) {
      return VoicePermissionStatus.permanentlyDenied;
    }
    return VoicePermissionStatus.denied;
  }

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<bool> _init() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize(
      onError: (SpeechRecognitionError e) {
        _onError?.call(e.errorMsg);
        _onDone?.call();
      },
      onStatus: (String status) {
        if (status == 'done' || status == 'notListening') {
          _onDone?.call();
        }
      },
    );
    return _initialized;
  }

  // ── Start listening ────────────────────────────────────────────────────────

  Future<VoiceStartResult> startListening({
    required void Function(String) onPartial,
    required void Function(String) onFinal,
    void Function(String)? onError,
    void Function()? onDone,
  }) async {
    // 1. Check / request microphone permission explicitly
    final permStatus = await requestPermission();
    if (permStatus == VoicePermissionStatus.permanentlyDenied) {
      return VoiceStartResult.permanentlyDenied;
    }
    if (permStatus == VoicePermissionStatus.denied) {
      return VoiceStartResult.denied;
    }

    // 2. Initialise speech engine
    if (!await _init()) {
      return VoiceStartResult.unavailable;
    }
    if (!_speech.isAvailable) {
      return VoiceStartResult.unavailable;
    }

    _onPartial = onPartial;
    _onFinal = onFinal;
    _onError = onError;
    _onDone = onDone;

    // 3. Start listening
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          _onFinal?.call(result.recognizedWords);
          _onDone?.call();
        } else {
          _onPartial?.call(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );

    return VoiceStartResult.started;
  }

  Future<void> stop() async {
    await _speech.stop();
    _onDone?.call();
    _clear();
  }

  Future<void> cancel() async {
    await _speech.cancel();
    _clear();
  }

  void _clear() {
    _onPartial = null;
    _onFinal = null;
    _onError = null;
    _onDone = null;
  }
}

enum VoiceStartResult { started, denied, permanentlyDenied, unavailable }
