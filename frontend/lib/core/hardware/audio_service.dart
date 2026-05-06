import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSuccess() async {
    // TODO: Cập nhật đường dẫn file asset thực tế khi có
    // await _player.play(AssetSource('sounds/success_beep.mp3'));
    
    // Tạm thời dùng âm thanh hệ thống hoặc in ra log
    print("🔊 [AudioService] Phát âm thanh TÍT (Thành công)");
  }

  Future<void> playError() async {
    // TODO: Cập nhật đường dẫn file asset thực tế khi có
    // await _player.play(AssetSource('sounds/error_buzz.mp3'));
    
    // Tạm thời dùng âm thanh hệ thống hoặc in ra log
    print("🔊 [AudioService] Phát âm thanh BUZZ (Lỗi)");
  }
}
