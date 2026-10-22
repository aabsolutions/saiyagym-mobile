import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/features/reminders/domain/reminder_settings.dart';
import 'package:saiyagym_mobile/features/reminders/presentation/weigh_in_prompt.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';
import 'package:saiyagym_mobile/features/sounds/domain/sound_purpose.dart';
import 'package:saiyagym_mobile/features/sounds/presentation/sound_selector.dart';

/// Training days + time and the weekly weigh-in, as local notifications.
class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(remindersControllerProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('reminders.title'))),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : _RemindersForm(settings: settings),
    );
  }
}

class _RemindersForm extends ConsumerWidget {
  const _RemindersForm({required this.settings});

  final ReminderSettings settings;

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    ReminderSettings next,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final denied = context.tr('reminders.denied');
    final granted = await ref
        .read(remindersControllerProvider.notifier)
        .save(next, reminderTexts(context));
    if (granted) {
      unawaited(confirmHaptic());
    } else {
      messenger.showSnackBar(SnackBar(content: Text(denied)));
    }
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, int hour, int minute) =>
      showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: hour, minute: minute),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale.toLanguageTag();
    // 2026-10-19 is a Monday: + (day - 1) gives the ISO weekday's name.
    String dayName(int day, {bool short = false}) =>
        (short ? DateFormat.E(locale) : DateFormat.EEEE(locale)).format(
          DateTime(2026, 10, 18 + day),
        );
    String time(int hour, int minute) =>
        TimeOfDay(hour: hour, minute: minute).format(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.fitness_center),
          title: Text(context.tr('reminders.training')),
          subtitle: Text(context.tr('reminders.trainingHint')),
          value: settings.trainingEnabled,
          onChanged: (on) =>
              _save(context, ref, settings.copyWith(trainingEnabled: on)),
        ),
        if (settings.trainingEnabled) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var day = 1; day <= 7; day++)
                  FilterChip(
                    label: Text(dayName(day, short: true)),
                    tooltip: dayName(day),
                    selected: settings.trainingDays.contains(day),
                    onSelected: (on) {
                      final days = {...settings.trainingDays};
                      on ? days.add(day) : days.remove(day);
                      // No day left = reminder off (keeps the last days).
                      unawaited(
                        _save(
                          context,
                          ref,
                          days.isEmpty
                              ? settings.copyWith(trainingEnabled: false)
                              : settings.copyWith(trainingDays: days),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(context.tr('reminders.time')),
            trailing: Text(
              time(settings.trainingHour, settings.trainingMinute),
            ),
            onTap: () async {
              final picked = await _pickTime(
                context,
                settings.trainingHour,
                settings.trainingMinute,
              );
              if (picked == null || !context.mounted) return;
              await _save(
                context,
                ref,
                settings.copyWith(
                  trainingHour: picked.hour,
                  trainingMinute: picked.minute,
                ),
              );
            },
          ),
          const SoundSelector(purpose: SoundPurpose.trainingReminder),
        ],
        const Divider(),
        SwitchListTile(
          secondary: const Icon(Icons.monitor_weight_outlined),
          title: Text(context.tr('reminders.weighIn')),
          subtitle: Text(context.tr('reminders.weighInHint')),
          value: settings.weighInEnabled,
          onChanged: (on) =>
              _save(context, ref, settings.copyWith(weighInEnabled: on)),
        ),
        if (settings.weighInEnabled) ...[
          ListTile(
            leading: const Icon(Icons.event_repeat),
            title: Text(context.tr('reminders.day')),
            trailing: DropdownButton<int>(
              value: settings.weighInDay,
              underline: const SizedBox.shrink(),
              items: [
                for (var day = 1; day <= 7; day++)
                  DropdownMenuItem(value: day, child: Text(dayName(day))),
              ],
              onChanged: (day) => day == null
                  ? null
                  : _save(context, ref, settings.copyWith(weighInDay: day)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(context.tr('reminders.time')),
            trailing: Text(time(settings.weighInHour, settings.weighInMinute)),
            onTap: () async {
              final picked = await _pickTime(
                context,
                settings.weighInHour,
                settings.weighInMinute,
              );
              if (picked == null || !context.mounted) return;
              await _save(
                context,
                ref,
                settings.copyWith(
                  weighInHour: picked.hour,
                  weighInMinute: picked.minute,
                ),
              );
            },
          ),
          const SoundSelector(purpose: SoundPurpose.weighIn),
        ],
      ],
    );
  }
}
