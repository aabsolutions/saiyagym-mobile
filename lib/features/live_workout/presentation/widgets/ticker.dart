import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';

/// Rebuilds every second with the current time (session clock, rest).
class Ticker extends StatefulWidget {
  const Ticker({required this.builder, super.key});

  final Widget Function(BuildContext context, DateTime now) builder;

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, clock.now().toUtc());
}

/// `1:05:09` / `4:09`.
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0
      ? '$hours:${minutes.toString().padLeft(2, '0')}:$seconds'
      : '$minutes:$seconds';
}
