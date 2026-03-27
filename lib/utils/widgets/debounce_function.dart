import 'dart:async';
import 'dart:ui';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({required this.delay});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}