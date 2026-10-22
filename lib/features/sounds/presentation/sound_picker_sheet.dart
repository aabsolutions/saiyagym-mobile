import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/cached_view.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/sounds/data/sound_preview.dart';
import 'package:saiyagym_mobile/features/sounds/domain/rest_sound.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_titles.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

Future<void> showSoundPickerSheet(BuildContext context, SoundPurpose purpose) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SoundPickerSheet(purpose: purpose),
    );

/// Sounds for one [purpose]: the default one plus the catalog. Premium sounds
/// the plan lacks are shown locked; tapping one explains the upgrade and
/// sends NOTHING (the API would reject it anyway).
class SoundPickerSheet extends ConsumerStatefulWidget {
  const SoundPickerSheet({required this.purpose, super.key});

  final SoundPurpose purpose;

  @override
  ConsumerState<SoundPickerSheet> createState() => _SoundPickerSheetState();
}

class _SoundPickerSheetState extends ConsumerState<SoundPickerSheet> {
  bool _showUpgrade = false;
  String? _previewing;
  // Kept in a field: `ref` can't be used in dispose().
  late final SoundPreview _player;

  @override
  void initState() {
    super.initState();
    _player = ref.read(soundPreviewProvider);
  }

  @override
  void dispose() {
    unawaited(_player.stop());
    super.dispose();
  }

  SoundSelectionControllerProvider get _controller =>
      soundSelectionControllerProvider(widget.purpose);

  Future<void> _select(RestSound sound) async {
    if (sound.locked) {
      setState(() => _showUpgrade = true);
      return;
    }
    setState(() => _showUpgrade = false);
    await ref.read(_controller.notifier).select(sound);
  }

  Future<void> _preview(RestSound sound) async {
    if (_previewing == sound.id) {
      setState(() => _previewing = null);
      await _player.stop();
      return;
    }
    setState(() => _previewing = sound.id);
    await _player.play(sound);
  }

  @override
  Widget build(BuildContext context) {
    final (titleKey, subtitleKey) = soundTitleKeys(widget.purpose);
    final sounds = ref.watch(restSoundsProvider);
    final selected = ref.watch(selectedSoundIdProvider(widget.purpose));
    final saving = ref.watch(_controller);

    // A premium rejection from the API (plan changed meanwhile) also ends
    // in the upgrade explanation; other errors are a snack bar.
    ref.listen(_controller, (_, next) {
      if (next case AsyncError(:final error)) {
        if (UpgradeReason.fromError(error) != null) {
          setState(() => _showUpgrade = true);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorText(context, error))));
        }
      }
    });

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              context.tr(titleKey),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(context.tr(subtitleKey)),
            if (saving.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(),
              ),
            if (_showUpgrade)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: UpgradeCta.feature(PlanFeature.premiumSounds),
              ),
            const SizedBox(height: 8),
            ListTile(
              key: const ValueKey('sound-default'),
              leading: Icon(
                selected == null
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: Text(context.tr('sounds.default')),
              selected: selected == null,
              onTap: saving.isLoading
                  ? null
                  : () {
                      setState(() => _showUpgrade = false);
                      unawaited(ref.read(_controller.notifier).useDefault());
                    },
            ),
            CachedView<List<RestSound>>(
              value: sounds,
              onRetry: () => ref.invalidate(restSoundsProvider),
              builder: (items) => Column(
                children: [
                  for (final sound in items)
                    _SoundTile(
                      sound: sound,
                      selected: sound.id == selected,
                      previewing: _previewing == sound.id,
                      busy: saving.isLoading,
                      onTap: () => unawaited(_select(sound)),
                      onPreview: () => unawaited(_preview(sound)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundTile extends StatelessWidget {
  const _SoundTile({
    required this.sound,
    required this.selected,
    required this.previewing,
    required this.busy,
    required this.onTap,
    required this.onPreview,
  });

  final RestSound sound;
  final bool selected;
  final bool previewing;
  final bool busy;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey('sound-${sound.id}'),
      leading: Icon(
        sound.locked
            ? Icons.lock_outline
            : selected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
      ),
      title: Text(sound.name),
      subtitle: sound.access == SoundAccess.premium
          ? Text(context.tr('sounds.premium'))
          : null,
      trailing: sound.locked
          ? null
          : IconButton(
              tooltip: context.tr('sounds.preview'),
              icon: Icon(previewing ? Icons.stop : Icons.play_arrow),
              onPressed: onPreview,
            ),
      selected: selected,
      onTap: busy ? null : onTap,
    );
  }
}
