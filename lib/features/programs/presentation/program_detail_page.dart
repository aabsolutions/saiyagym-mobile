import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/programs/domain/program.dart';
import 'package:saiyagym_mobile/features/programs/domain/program_schedule.dart';
import 'package:saiyagym_mobile/features/programs/programs_providers.dart';
import 'package:saiyagym_mobile/features/routines/domain/routine.dart';
import 'package:saiyagym_mobile/features/routines/routines_providers.dart';

/// Program overview (weeks → days → routine). Mobile only views and
/// (de)activates; editing is on the web. Activation needs the API.
class ProgramDetailPage extends ConsumerStatefulWidget {
  const ProgramDetailPage({required this.programId, super.key});

  final String programId;

  @override
  ConsumerState<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends ConsumerState<ProgramDetailPage> {
  bool _busy = false;
  Object? _error;

  Future<void> _toggle(Program program) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final repository = ref.read(programsRepositoryProvider);
    try {
      if (program.status == ProgramStatus.active) {
        await repository.deactivate(program.id);
      } else {
        // Program dates are the user's LOCAL calendar date.
        await repository.activate(
          program.id,
          startDate: localDate(DateTime.now()),
        );
      }
    } on Object catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final program = (ref.watch(programsProvider).value ?? const <Program>[])
        .where((p) => p.id == widget.programId)
        .firstOrNull;
    final routines = {
      for (final routine
          in ref.watch(activeRoutinesProvider).value ?? const <Routine>[])
        routine.id: routine.name,
    };
    final theme = Theme.of(context);
    final error = _error;
    final upgrade = error == null ? null : UpgradeReason.fromError(error);
    String weekday(int iso) =>
        DateFormat.EEEE(context.locale.languageCode)
            .format(DateTime(2024, 1, iso)); // 2024-01-01 is a Monday

    return Scaffold(
      appBar: AppBar(title: Text(program?.name ?? '')),
      body: program == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        context.tr('programs.status.${program.status.name}'),
                      ),
                    ),
                    Chip(
                      label: Text(
                        context.tr(
                          'programs.weeks',
                          namedArgs: {'count': '${program.durationWeeks}'},
                        ),
                      ),
                    ),
                  ],
                ),
                if (program.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(program.notes, style: theme.textTheme.bodyLarge),
                ],
                const SizedBox(height: 16),
                for (final (index, week) in program.weeks.indexed)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(
                              'programs.week',
                              namedArgs: {'n': '${index + 1}'},
                            ),
                            style: theme.textTheme.titleMedium,
                          ),
                          if (week.days.isEmpty)
                            Text(context.tr('programs.noDays'))
                          else
                            for (final day in [
                              ...week.days,
                            ]..sort((a, b) => a.weekday - b.weekday))
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  day.label ?? routines[day.routineId] ?? '—',
                                ),
                                subtitle: Text(weekday(day.weekday)),
                              ),
                        ],
                      ),
                    ),
                  ),
                if (upgrade != null)
                  UpgradeCta(reason: upgrade)
                else if (error != null)
                  ErrorBanner(error: error),
                const SizedBox(height: 16),
                if (program.status != ProgramStatus.completed)
                  PrimaryButton(
                    label: context.tr(
                      program.status == ProgramStatus.active
                          ? 'programs.deactivate'
                          : 'programs.activate',
                    ),
                    isLoading: _busy,
                    onPressed: () => _toggle(program),
                  ),
                const SizedBox(height: 8),
                Text(
                  context.tr('programs.editOnWeb'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
    );
  }
}
