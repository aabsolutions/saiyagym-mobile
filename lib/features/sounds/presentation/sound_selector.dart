import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_picker_sheet.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

/// Row with the current sound of [purpose]; tap to change it.
class SoundSelector extends ConsumerWidget {
  const SoundSelector({required this.purpose, super.key});

  final SoundPurpose purpose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedSoundIdProvider(purpose));
    // The catalog is cached for offline; while loading, show the default.
    final name = selected == null
        ? null
        : ref
              .watch(restSoundsProvider)
              .value
              ?.data
              .where((sound) => sound.id == selected)
              .firstOrNull
              ?.name;

    return ListTile(
      leading: const Icon(Icons.music_note_outlined),
      // Reminder rows sit under their own reminder: just "Sound".
      title: Text(
        context.tr(
          purpose == SoundPurpose.rest ? 'sounds.entry' : 'reminders.sound',
        ),
      ),
      subtitle: Text(name ?? context.tr('sounds.default')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showSoundPickerSheet(context, purpose),
    );
  }
}
