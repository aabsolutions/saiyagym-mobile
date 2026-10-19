import 'package:clock/clock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/core/units/unit_formatter.dart';
import 'package:saiyagym_mobile/core/widgets/primary_button.dart';
import 'package:saiyagym_mobile/features/body_metrics/body_metrics_providers.dart';
import 'package:saiyagym_mobile/features/body_metrics/domain/body_metric.dart';
import 'package:saiyagym_mobile/features/profile/presentation/preferences_providers.dart';
import 'package:saiyagym_mobile/features/progress/progress_providers.dart';
import 'package:uuid/uuid.dart';

/// Every measurement at once (new or edit). Empty fields are left unset.
class BodyMetricFormPage extends ConsumerWidget {
  const BodyMetricFormPage({this.metricId, super.key});

  final String? metricId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = metricId;
    if (id == null) return const _BodyMetricForm();
    final metrics = ref.watch(bodyMetricsProvider);
    final existing = metrics.value?.where((m) => m.id == id).firstOrNull;
    if (existing == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: metrics.isLoading
              ? const CircularProgressIndicator()
              : Text(context.tr('body.notFound')),
        ),
      );
    }
    return _BodyMetricForm(existing: existing);
  }
}

class _BodyMetricForm extends ConsumerStatefulWidget {
  const _BodyMetricForm({this.existing});

  final BodyMetric? existing;

  @override
  ConsumerState<_BodyMetricForm> createState() => _BodyMetricFormState();
}

class _BodyMetricFormState extends ConsumerState<_BodyMetricForm> {
  static const _uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  final Map<BodyMeasure, TextEditingController> _fields = {
    for (final measure in BodyMeasure.values) measure: TextEditingController(),
  };
  final _notes = TextEditingController();
  late DateTime _measuredAt;
  bool _saving = false;
  bool _filled = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _measuredAt = widget.existing?.measuredAt.toLocal() ?? clock.now();
    _notes.text = widget.existing?.notes ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Needs the locale / units: once, not on every rebuild.
    final existing = widget.existing;
    if (_filled || existing == null) return;
    _filled = true;
    final formatter = UnitFormatter(
      ref.read(unitSystemProvider),
      locale: context.locale.languageCode,
    );
    for (final measure in BodyMeasure.values) {
      final value = measure.of(existing);
      if (value != null) {
        _fields[measure]!.text = formatter.formatNumber(
          _toDisplay(formatter, measure, value),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    _notes.dispose();
    super.dispose();
  }

  static double _toDisplay(UnitFormatter f, BodyMeasure m, double value) =>
      switch (m.kind) {
        MeasureKind.weight => f.displayWeight(value),
        MeasureKind.length => f.displayLength(value),
        MeasureKind.percent => value,
      };

  static double _fromDisplay(UnitFormatter f, BodyMeasure m, double value) =>
      switch (m.kind) {
        MeasureKind.weight => f.weightToKg(value),
        MeasureKind.length => f.lengthToCm(value),
        MeasureKind.percent => value,
      };

  String? _validate(UnitFormatter formatter, BodyMeasure measure, String text) {
    if (text.trim().isEmpty) return null;
    final value = UnitFormatter.parseNumber(text);
    if (value == null) return context.tr('body.invalid');
    final stored = _fromDisplay(formatter, measure, value);
    if (measure.accepts(stored)) return null;
    String show(double v) =>
        formatter.formatNumber(_toDisplay(formatter, measure, v));
    return context.tr(
      'body.range',
      namedArgs: {'min': show(measure.min), 'max': show(measure.max)},
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _measuredAt,
      firstDate: DateTime(2000),
      lastDate: clock.now(),
    );
    if (picked == null) return;
    setState(
      () => _measuredAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _measuredAt.hour,
        _measuredAt.minute,
      ),
    );
  }

  Future<void> _save(UnitFormatter formatter) async {
    if (!_formKey.currentState!.validate()) return;
    var metric =
        (widget.existing ??
                BodyMetric(id: _uuid.v4(), measuredAt: _measuredAt.toUtc()))
            .copyWith(
              measuredAt: _measuredAt.toUtc(),
              notes: _notes.text.trim(),
            );
    for (final measure in BodyMeasure.values) {
      final value = UnitFormatter.parseNumber(_fields[measure]!.text);
      metric = measure.put(
        metric,
        value == null ? null : _fromDisplay(formatter, measure, value),
      );
    }
    if (metric.isEmpty) {
      setState(() => _error = context.tr('body.atLeastOne'));
      return;
    }
    setState(() => _saving = true);
    await ref.read(bodyMetricsRepositoryProvider).save(metric);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = ref.unitFormatter(context);
    final date = DateFormat.yMMMd(context.locale.toLanguageTag())
        .format(_measuredAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(widget.existing == null ? 'body.newTitle' : 'body.edit'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(context.tr('body.date')),
              trailing: Text(date),
              onTap: _pickDate,
            ),
            for (final measure in BodyMeasure.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: _fields[measure],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.tr('body.measures.${measure.name}'),
                    suffixText: switch (measure.kind) {
                      MeasureKind.weight => formatter.weightUnit,
                      MeasureKind.length => formatter.lengthUnit,
                      MeasureKind.percent => '%',
                    },
                  ),
                  validator: (text) =>
                      _validate(formatter, measure, text ?? ''),
                ),
              ),
            TextFormField(
              controller: _notes,
              maxLength: 1000,
              maxLines: 3,
              decoration: InputDecoration(labelText: context.tr('body.notes')),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            PrimaryButton(
              label: context.tr('common.save'),
              isLoading: _saving,
              onPressed: () => _save(formatter),
            ),
          ],
        ),
      ),
    );
  }
}
