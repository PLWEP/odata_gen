import 'dart:async';
import 'dart:io';

class ConsoleSpinner {
  final String message;
  final String finalMessage;
  final List<String> sequences;
  final Duration interval;
  final int indent;

  Timer? _timer;
  int _index = 0;

  ConsoleSpinner({
    this.message = 'Loading',
    this.finalMessage = 'Done',
    this.sequences = const ['⣷', '⣯', '⣟', '⡿', '⢿', '⣻', '⣽', '⣾'],
    this.interval = const Duration(milliseconds: 100),
    this.indent = 50,
  });

  void start() {
    _timer = Timer.periodic(interval, (timer) {
      stdout.write('\r${message.padRight(indent)}${sequences[_index]}');
      _index = (_index + 1) % sequences.length;
    });
  }

  void stop() {
    _timer?.cancel();
    stdout.write('\r${finalMessage.padRight(indent)}✓\n');
  }
}
