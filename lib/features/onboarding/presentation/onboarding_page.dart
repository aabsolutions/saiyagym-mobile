import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/i18n/app_locales.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/onboarding/domain/complete_onboarding.dart';
import 'package:saiyagym_mobile/features/onboarding/presentation/onboarding_controller.dart';
import 'package:saiyagym_mobile/features/profile/presentation/widgets/profile_fields.dart';

/// Five short steps; only level and goal are mandatory.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _steps = 5;
  static const _bodyStep = 1;
  static const _levelStep = 2;
  static const _goalStep = 3;

  final _pages = PageController();
  final _bodyForm = GlobalKey<FormState>();
  int _step = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  bool get _isLast => _step == _steps - 1;

  Future<void> _goTo(int step) async {
    setState(() => _step = step);
    await _pages.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (_step == _bodyStep && !(_bodyForm.currentState?.validate() ?? true)) {
      return;
    }
    if (_isLast) {
      await ref.read(onboardingSubmitProvider.notifier).submit();
    } else {
      await _goTo(_step + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingDraftProvider);
    final submission = ref.watch(onboardingSubmitProvider);
    final canContinue = switch (_step) {
      _levelStep => data.level != null,
      _goalStep => data.goal != null,
      _ => true,
    };

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_goTo(_step - 1));
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: _step == 0
              ? null
              : BackButton(onPressed: () => _goTo(_step - 1)),
          title: Text(
            context.tr(
              'onboarding.stepOf',
              namedArgs: {'current': '${_step + 1}', 'total': '$_steps'},
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: LinearProgressIndicator(value: (_step + 1) / _steps),
          ),
        ),
        body: PageView(
          controller: _pages,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const _PreferencesStep(),
            _BodyStep(formKey: _bodyForm),
            const _LevelStep(),
            const _GoalStep(),
            const _RestStep(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (submission case AsyncError(:final error)) ...[
                  ErrorBanner(error: error),
                  const SizedBox(height: 12),
                ],
                PrimaryButton(
                  label: context.tr(
                    _isLast ? 'onboarding.finish' : 'onboarding.next',
                  ),
                  isLoading: submission.isLoading,
                  onPressed: canContinue ? _next : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepLayout extends StatelessWidget {
  const _StepLayout({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

/// Shorthand for the steps: read and update the draft.
mixin _Draft on ConsumerWidget {
  OnboardingData draft(WidgetRef ref) => ref.watch(onboardingDraftProvider);

  void change(
    WidgetRef ref,
    OnboardingData Function(OnboardingData current) edit,
  ) => ref.read(onboardingDraftProvider.notifier).update(edit);
}

class _PreferencesStep extends ConsumerWidget with _Draft {
  const _PreferencesStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = draft(ref);
    return _StepLayout(
      title: context.tr('onboarding.preferences.title'),
      subtitle: context.tr('onboarding.preferences.subtitle'),
      children: [
        _Label(context.tr('profile.language')),
        OptionCards<AppLanguage>(
          options: AppLocales.languages,
          selected: AppLocales.languages
              .where((language) => language.code == data.language)
              .firstOrNull,
          title: (language) => language.nativeName,
          onSelected: (language) async {
            change(ref, (d) => d.copyWith(language: language.code));
            await context.setLocale(language.locale);
          },
        ),
        const SizedBox(height: 12),
        _Label(context.tr('profile.units')),
        OptionCards<UnitSystem>(
          options: UnitSystem.values,
          selected: data.units,
          title: (units) => context.tr('profile.unitSystems.${units.name}'),
          description: (units) => UnitFormatter(
            units,
            locale: context.locale.languageCode,
          ).formatWeight(100),
          onSelected: (units) => change(ref, (d) => d.copyWith(units: units)),
        ),
      ],
    );
  }
}

class _BodyStep extends ConsumerWidget with _Draft {
  const _BodyStep({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = draft(ref);
    final formatter = UnitFormatter(
      data.units,
      locale: context.locale.languageCode,
    );
    return Form(
      key: formKey,
      child: _StepLayout(
        title: context.tr('onboarding.body.title'),
        subtitle: context.tr('onboarding.body.subtitle'),
        children: [
          BirthDateField(
            value: data.birthDate,
            onChanged: (date) =>
                change(ref, (d) => d.copyWith(birthDate: date)),
          ),
          const SizedBox(height: 16),
          _Label(context.tr('profile.sex')),
          SexSelector(
            selected: data.sex,
            onSelected: (sex) => change(ref, (d) => d.copyWith(sex: sex)),
          ),
          const SizedBox(height: 16),
          MeasurementField(
            // New unit system → re-render the text in the new unit.
            key: ValueKey(('height', data.units)),
            kind: MeasurementKind.length,
            label: context.tr('profile.height'),
            icon: Icons.height,
            formatter: formatter,
            min: BodyLimits.minHeightCm,
            max: BodyLimits.maxHeightCm,
            initialValue: data.heightCm,
            onChanged: (cm) => change(ref, (d) => d.copyWith(heightCm: cm)),
          ),
          const SizedBox(height: 16),
          MeasurementField(
            key: ValueKey(('weight', data.units)),
            kind: MeasurementKind.weight,
            label: context.tr('profile.weight'),
            icon: Icons.monitor_weight_outlined,
            formatter: formatter,
            min: BodyLimits.minWeightKg,
            max: BodyLimits.maxWeightKg,
            initialValue: data.weightKg,
            onChanged: (kg) => change(ref, (d) => d.copyWith(weightKg: kg)),
          ),
        ],
      ),
    );
  }
}

class _LevelStep extends ConsumerWidget with _Draft {
  const _LevelStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = draft(ref);
    return _StepLayout(
      title: context.tr('onboarding.level.title'),
      subtitle: context.tr('onboarding.level.subtitle'),
      children: [
        LevelSelector(
          selected: data.level,
          onSelected: (level) => change(ref, (d) => d.copyWith(level: level)),
        ),
      ],
    );
  }
}

class _GoalStep extends ConsumerWidget with _Draft {
  const _GoalStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = draft(ref);
    return _StepLayout(
      title: context.tr('onboarding.goal.title'),
      subtitle: context.tr('onboarding.goal.subtitle'),
      children: [
        GoalSelector(
          selected: data.goal,
          onSelected: (goal) => change(ref, (d) => d.copyWith(goal: goal)),
        ),
      ],
    );
  }
}

class _RestStep extends ConsumerWidget with _Draft {
  const _RestStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = draft(ref);
    return _StepLayout(
      title: context.tr('onboarding.rest.title'),
      subtitle: context.tr('onboarding.rest.subtitle'),
      children: [
        RestSelector(
          seconds: data.defaultRestSeconds,
          onSelected: (seconds) =>
              change(ref, (d) => d.copyWith(defaultRestSeconds: seconds)),
        ),
      ],
    );
  }
}
