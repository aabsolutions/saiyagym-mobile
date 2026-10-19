import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/profile/domain/profile_repository.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/profile/presentation/widgets/profile_fields.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = ref.read(currentUserProvider)?.profile ?? const UserProfile();
    _name = TextEditingController(text: _profile.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final name = _name.text.trim();
    await ref
        .read(profileSaveControllerProvider.notifier)
        .saveProfile(
          ProfileUpdate(
            name: name.isEmpty ? null : name,
            birthDate: _profile.birthDate,
            sex: _profile.sex,
            heightCm: _profile.heightCm,
            level: _profile.level,
            goal: _profile.goal,
          ),
        );
    if (!mounted) return;
    if (ref.read(profileSaveControllerProvider) is AsyncData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr('profile.edit.saved'))));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(profileSaveControllerProvider);
    final formatter = ref.unitFormatter(context);
    final theme = Theme.of(context);

    Widget label(String key) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(context.tr(key), style: theme.textTheme.titleMedium),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('profile.edit.title'))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              maxLength: 80,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: context.tr('auth.name'),
                prefixIcon: const Icon(Icons.person_outline),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            BirthDateField(
              value: _profile.birthDate,
              onChanged: (date) =>
                  setState(() => _profile = _profile.copyWith(birthDate: date)),
            ),
            label('profile.sex'),
            SexSelector(
              selected: _profile.sex,
              onSelected: (sex) =>
                  setState(() => _profile = _profile.copyWith(sex: sex)),
            ),
            const SizedBox(height: 16),
            MeasurementField(
              kind: MeasurementKind.length,
              label: context.tr('profile.height'),
              icon: Icons.height,
              formatter: formatter,
              min: BodyLimits.minHeightCm,
              max: BodyLimits.maxHeightCm,
              initialValue: _profile.heightCm,
              onChanged: (cm) =>
                  setState(() => _profile = _profile.copyWith(heightCm: cm)),
            ),
            label('profile.level'),
            LevelSelector(
              selected: _profile.level,
              onSelected: (level) =>
                  setState(() => _profile = _profile.copyWith(level: level)),
            ),
            label('profile.goal'),
            GoalSelector(
              selected: _profile.goal,
              onSelected: (goal) =>
                  setState(() => _profile = _profile.copyWith(goal: goal)),
            ),
            if (saving case AsyncError(:final error)) ...[
              const SizedBox(height: 8),
              ErrorBanner(error: error),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: context.tr('profile.edit.save'),
              isLoading: saving.isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
