import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise.dart';
import 'package:saiyagym_mobile/features/exercises/domain/exercise_catalog.dart';
import 'package:saiyagym_mobile/features/exercises/exercises_providers.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';

/// New custom exercise. Needs the API (custom exercises are created there
/// and count toward the plan limit); stored locally on success.
class CustomExercisePage extends ConsumerStatefulWidget {
  const CustomExercisePage({super.key});

  @override
  ConsumerState<CustomExercisePage> createState() => _CustomExercisePageState();
}

class _CustomExercisePageState extends ConsumerState<CustomExercisePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _muscle = muscles.first;
  String _equipment = equipments.first;
  String _mechanic = 'compound';
  bool _saving = false;
  Object? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final exercise = await ref
          .read(exercisesRepositoryProvider)
          .createCustom(
            CustomExerciseDraft(
              name: _name.text,
              primaryMuscle: _muscle,
              equipment: _equipment,
              mechanic: _mechanic,
            ),
          );
      if (mounted) context.go(AppRoutes.exercise(exercise.id));
    } on Object catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final upgrade = error == null ? null : UpgradeReason.fromError(error);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('exercises.create'))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              maxLength: 80,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.tr('exercises.form.name'),
                counterText: '',
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? context.tr('validation.required')
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _muscle,
              decoration: InputDecoration(
                labelText: context.tr('exercises.form.muscle'),
              ),
              items: [
                for (final m in muscles)
                  DropdownMenuItem(
                    value: m,
                    child: Text(context.tr('muscles.$m')),
                  ),
              ],
              onChanged: (value) => setState(() => _muscle = value ?? _muscle),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _equipment,
              decoration: InputDecoration(
                labelText: context.tr('exercises.form.equipment'),
              ),
              items: [
                for (final e in equipments)
                  DropdownMenuItem(
                    value: e,
                    child: Text(context.tr('equipment.$e')),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _equipment = value ?? _equipment),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: [
                for (final m in ['compound', 'isolation'])
                  ButtonSegment(
                    value: m,
                    label: Text(context.tr('exercises.mechanics.$m')),
                  ),
              ],
              selected: {_mechanic},
              onSelectionChanged: (value) =>
                  setState(() => _mechanic = value.single),
            ),
            const SizedBox(height: 16),
            if (upgrade != null)
              UpgradeCta(reason: upgrade)
            else if (error != null)
              ErrorBanner(error: error),
            const SizedBox(height: 16),
            PrimaryButton(
              label: context.tr('common.save'),
              isLoading: _saving,
              onPressed: _save,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('exercises.form.onlineHint'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
