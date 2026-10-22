import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';

void main() {
  group('staleChannels', () {
    test('deletes prefixed channels except the kept one', () {
      final stale = staleChannels(
        ['reminders', 'reminder_training_a', 'reminder_training_b'],
        prefix: 'reminder_training_',
        keep: 'reminder_training_a',
      );

      expect(stale, ['reminder_training_b']);
    });

    test('a keep outside the prefix removes every prefixed channel', () {
      final stale = staleChannels(
        ['reminders', 'reminder_training_a', 'reminder_weighin_a'],
        prefix: 'reminder_training_',
        keep: 'reminders',
      );

      expect(stale, ['reminder_training_a']);
    });

    test('never touches other channels', () {
      expect(
        staleChannels(
          ['rest_timer', 'reminders'],
          prefix: 'rest_timer_',
          keep: 'x',
        ),
        isEmpty,
      );
    });
  });
}
