import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_picker_sheet.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

/// Profile row: the current rest-alarm sound; tap to change it.
class RestSoundSelector extends ConsumerWidget {
  const RestSoundSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRestSoundIdProvider);
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
      title: Text(context.tr('sounds.entry')),
      subtitle: Text(name ?? context.tr('sounds.default')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showSoundPickerSheet(context),
    );
  }
}
