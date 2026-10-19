import 'package:clock/clock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/features/reminders/data/reminder_scheduler.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';

ReminderTexts reminderTexts(BuildContext context) => ReminderTexts(
  channelName: context.tr('reminders.channel'),
  trainingTitle: context.tr('reminders.trainingTitle'),
  trainingBody: context.tr('reminders.trainingBody'),
  weighInTitle: context.tr('reminders.weighInTitle'),
  weighInBody: context.tr('reminders.weighInBody'),
);

/// After the first weigh-in, suggest (once) a weekly reminder at this same
/// day and time — the moment the notification permission makes sense.
Future<void> offerWeighInReminder(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(remindersControllerProvider.notifier);
  final settings = await ref.read(remindersControllerProvider.future);
  if (settings.weighInEnabled || settings.weighInOffered) return;
  await controller.markWeighInOffered();
  if (!context.mounted) return;
  final texts = reminderTexts(context);
  final messenger = ScaffoldMessenger.of(context);
  final denied = context.tr('reminders.denied');
  final now = clock.now();
  messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 8),
      content: Text(context.tr('reminders.weighInOffer')),
      action: SnackBarAction(
        label: context.tr('reminders.enable'),
        onPressed: () async {
          final current = await ref.read(remindersControllerProvider.future);
          final granted = await controller.save(
            current.copyWith(
              weighInEnabled: true,
              weighInDay: now.weekday,
              weighInHour: now.hour,
              weighInMinute: now.minute - now.minute % 5,
            ),
            texts,
          );
          if (!granted) {
            messenger.showSnackBar(SnackBar(content: Text(denied)));
          }
        },
      ),
    ),
  );
}
