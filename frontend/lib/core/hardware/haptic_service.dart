import 'package:vibration/vibration.dart';

class HapticService {
  Future<void> vibrateSuccess() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 100);
    }
  }

  Future<void> vibrateError() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      // Rung mạnh 2 nhịp: rung 500ms, nghỉ 200ms, rung 500ms
      Vibration.vibrate(pattern: [0, 500, 200, 500]);
    }
  }
}
