import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/live_workout/data/device_services.dart';
import 'package:saiyagym_mobile/features/sounds/data/alarm_sound_platform.dart';
import 'package:saiyagym_mobile/features/sounds/domain/alarm_sound.dart';

import '../../helpers/fake_alarm_sound_platform.dart';

const _sound = AlarmSound(
  assetKey: 'aaaa-1111',
  name: 'Bell',
  localPath: '/files/aaaa-1111.mp3',
  androidUri: 'content://media/external/audio/media/42',
);

void main() {
  group('usableSound (fallback to the default sound)', () {
    test(
      'no sound selected (null id: downgrade / deletion) -> default',
      () async {
        expect(await usableSound(null, FakeAlarmSoundPlatform()), isNull);
      },
    );

    test('installed and available -> the custom sound', () async {
      expect(await usableSound(_sound, FakeAlarmSoundPlatform()), _sound);
    });

    test('file / MediaStore item gone at schedule time -> default', () async {
      final platform = FakeAlarmSoundPlatform()..available = false;

      expect(await usableSound(_sound, platform), isNull);
    });

    test('a platform failure never breaks the alarm -> default', () async {
      expect(await usableSound(_sound, _ThrowingPlatform()), isNull);
    });
  });

  group('channels', () {
    test('default sound uses the default channel id', () {
      expect(restChannelIdFor(null), 'rest_timer');
    });

    test('custom sound gets its own channel per asset', () {
      expect(restChannelIdFor(_sound), 'rest_timer_aaaa-1111');
    });

    test('stale rest_timer_* channels are deleted, others are untouched', () {
      final stale = staleRestChannels([
        'rest_timer',
        'rest_timer_aaaa-1111',
        'rest_timer_old-2222',
        'reminders',
      ], keep: 'rest_timer_aaaa-1111');

      expect(stale, ['rest_timer_old-2222']);
    });

    test('back to the default sound: every custom channel goes', () {
      final stale = staleRestChannels([
        'rest_timer',
        'rest_timer_aaaa-1111',
      ], keep: restChannelId);

      expect(stale, ['rest_timer_aaaa-1111']);
    });
  });

  test('SilentDeviceServices accepts a sound without handling it', () async {
    final silent = SilentDeviceServices();

    await silent.prepare(channelName: 'x', sound: _sound);
    await silent.schedule(DateTime.utc(2030), title: 't');

    expect(silent.scheduled, hasLength(1));
  });
}

class _ThrowingPlatform extends FakeAlarmSoundPlatform {
  @override
  Future<bool> isAvailable(AlarmSound sound) async => throw StateError('boom');
}
