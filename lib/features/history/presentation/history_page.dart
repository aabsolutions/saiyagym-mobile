import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/widgets/async_body.dart';
import 'package:saiyagym_mobile/core/widgets/empty_state.dart';
import 'package:saiyagym_mobile/core/widgets/refreshable_list.dart';
import 'package:saiyagym_mobile/core/widgets/sync_status_button.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/history/domain/month_grid.dart';
import 'package:saiyagym_mobile/features/live_workout/domain/live_session.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/workouts/domain/workout.dart';
import 'package:saiyagym_mobile/features/workouts/workouts_providers.dart';

enum _View { list, calendar }

/// Finished workouts from the LOCAL database: list or month calendar.
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  _View _view = _View.list;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _day;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(workoutHistoryProvider);
    final workouts = history.value ?? const <Workout>[];
    final shown = _view == _View.calendar && _day != null
        ? workouts.where((w) => dayOf(w.startedAt) == _day).toList()
        : workouts;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('history.title')),
        actions: const [SyncStatusButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SegmentedButton<_View>(
              segments: [
                ButtonSegment(
                  value: _View.list,
                  icon: const Icon(Icons.view_list),
                  label: Text(context.tr('history.views.list')),
                ),
                ButtonSegment(
                  value: _View.calendar,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(context.tr('history.views.calendar')),
                ),
              ],
              selected: {_view},
              onSelectionChanged: (value) =>
                  setState(() => _view = value.single),
            ),
          ),
        ),
      ),
      body: AsyncBody(
        value: history,
        onRetry: () => ref.invalidate(workoutHistoryProvider),
        builder: (_) => RefreshableList(
          onRefresh: () => ref.read(syncServiceProvider).sync(),
          empty: EmptyState(
            icon: Icons.history,
            title: context.tr('history.emptyTitle'),
            message: context.tr('history.emptyMessage'),
          ),
          children: [
            if (_view == _View.calendar && workouts.isNotEmpty)
              _MonthCalendar(
                month: _month,
                selected: _day,
                trainedDays: {for (final w in workouts) dayOf(w.startedAt)},
                onMonth: (month) => setState(() {
                  _month = month;
                  _day = null;
                }),
                onDay: (day) => setState(() => _day = _day == day ? null : day),
              ),
            for (final workout in shown) WorkoutTile(workout: workout),
          ],
        ),
      ),
    );
  }
}

class _MonthCalendar extends ConsumerWidget {
  const _MonthCalendar({
    required this.month,
    required this.selected,
    required this.trainedDays,
    required this.onMonth,
    required this.onDay,
  });

  final DateTime month;
  final DateTime? selected;
  final Set<DateTime> trainedDays;
  final ValueChanged<DateTime> onMonth;
  final ValueChanged<DateTime> onDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstDay = ref.watch(
      currentUserProvider.select((u) => u?.preferences.firstDayOfWeek ?? 1),
    );
    final locale = context.locale.languageCode;
    final scheme = Theme.of(context).colorScheme;
    final cells = monthGrid(month.year, month.month, firstDayOfWeek: firstDay);
    final today = dayOf(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: context.tr('history.previousMonth'),
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () =>
                      onMonth(DateTime(month.year, month.month - 1)),
                ),
                Expanded(
                  child: Text(
                    DateFormat.yMMMM(locale).format(month),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: context.tr('history.nextMonth'),
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () =>
                      onMonth(DateTime(month.year, month.month + 1)),
                ),
              ],
            ),
            Row(
              children: [
                for (final weekday in weekdayOrder(firstDay))
                  Expanded(
                    child: Text(
                      DateFormat.E(locale).format(DateTime(2024, 1, weekday)),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
              ],
            ),
            for (var row = 0; row < cells.length ~/ 7; row++)
              Row(
                children: [
                  for (final day in cells.sublist(row * 7, row * 7 + 7))
                    Expanded(
                      child: day == null
                          ? const SizedBox(height: 44)
                          : InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: trainedDays.contains(day)
                                  ? () => onDay(day)
                                  : null,
                              child: Container(
                                height: 44,
                                margin: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: day == selected
                                      ? scheme.primary
                                      : trainedDays.contains(day)
                                      ? scheme.primaryContainer
                                      : null,
                                  border: day == today
                                      ? Border.all(color: scheme.primary)
                                      : null,
                                ),
                                child: Text(
                                  '${day.day}',
                                  semanticsLabel: DateFormat.yMMMd(locale)
                                      .format(day),
                                  style: TextStyle(
                                    color: day == selected
                                        ? scheme.onPrimary
                                        : null,
                                    fontWeight: trainedDays.contains(day)
                                        ? FontWeight.w700
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class WorkoutTile extends ConsumerWidget {
  const WorkoutTile({required this.workout, super.key});

  final Workout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.unitFormatter(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          workout.name.isEmpty ? context.tr('history.untitled') : workout.name,
        ),
        subtitle: Text(
          [
            DateFormat.yMMMEd(context.locale.languageCode)
                .format(workout.startedAt.toLocal()),
            context.tr(
              'history.sets',
              namedArgs: {'count': '${workout.completedWorkingSets}'},
            ),
            formatter.formatWeight(
              (workout.volumeKg ?? workout.liveVolumeKg).roundToDouble(),
            ),
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go(AppRoutes.workoutDetail(workout.id)),
      ),
    );
  }
}
