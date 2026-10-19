import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPoint {
  const ChartPoint(this.date, this.value);

  /// UTC midnight of a local day, or an instant.
  final DateTime date;
  final double value;
}

const _chartHeight = 180.0;

double _dayOf(DateTime date) =>
    date.millisecondsSinceEpoch / Duration.millisecondsPerDay;

DateTime _dateOf(double day) => DateTime.fromMillisecondsSinceEpoch(
  (day * Duration.millisecondsPerDay).round(),
  isUtc: true,
);

/// A value over time (one point per session / week / measurement). Values
/// arrive already in display units; [format] adds the unit.
class TrendChart extends StatelessWidget {
  const TrendChart({
    required this.points,
    required this.format,
    this.emptyText,
    super.key,
  });

  final List<ChartPoint> points;
  final String Function(double value) format;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(
            emptyText ?? context.tr('progress.noData'),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final locale = context.locale.toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);
    final values = [for (final p in points) p.value];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final margin = math.max((high - low) * 0.15, high.abs() * 0.05 + 1);
    final minX = _dayOf(points.first.date);
    final maxX = math.max(_dayOf(points.last.date), minX + 1);
    final color = theme.colorScheme.primary;

    return _ChartSemantics(
      label: context.tr(
        'progress.chartSummary',
        namedArgs: {
          'count': '${points.length}',
          'first': format(points.first.value),
          'last': format(points.last.value),
        },
      ),
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: math.max(0, low - margin),
          maxY: high + margin,
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    meta.formattedValue,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: math.max(1, (maxX - minX) / 3),
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    dateFormat.format(_dateOf(value)),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  LineTooltipItem(
                    '${format(spot.y)}\n'
                    '${dateFormat.format(_dateOf(spot.x))}',
                    TextStyle(color: theme.colorScheme.onInverseSurface),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (final p in points) FlSpot(_dayOf(p.date), p.value)],
              color: color,
              barWidth: 3,
              preventCurveOverShooting: true,
              isCurved: points.length > 2,
              dotData: FlDotData(show: points.length <= 20),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One bar per week.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    required this.weeks,
    required this.values,
    required this.format,
    super.key,
  });

  /// UTC midnight of each week's first day, oldest first.
  final List<DateTime> weeks;
  final List<double> values;
  final String Function(double value) format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.MMMd(context.locale.toLanguageTag());
    final high = values.isEmpty
        ? 1.0
        : math.max<double>(values.reduce(math.max), 1);
    // Labels on every bar get crowded past ~6 weeks.
    final labelEvery = math.max(1, (weeks.length / 5).ceil());

    return _ChartSemantics(
      label: values.isEmpty
          ? context.tr('progress.noData')
          : context.tr(
              'progress.barSummary',
              namedArgs: {
                'count': '${values.length}',
                'last': format(values.last),
              },
            ),
      child: BarChart(
        BarChartData(
          maxY: high * 1.15,
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    meta.formattedValue,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final show =
                      index >= 0 &&
                      index < weeks.length &&
                      (weeks.length - 1 - index) % labelEvery == 0;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      show ? dateFormat.format(weeks[index]) : '',
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.inverseSurface,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                '${format(rod.toY)}\n${dateFormat.format(weeks[group.x])}',
                TextStyle(color: theme.colorScheme.onInverseSurface),
              ),
            ),
          ),
          barGroups: [
            for (final (index, value) in values.indexed)
              BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: value,
                    color: theme.colorScheme.primary,
                    width: math.max(6, 120 / math.max(values.length, 1)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Screen readers hear [label], not the chart's painted pieces.
class _ChartSemantics extends StatelessWidget {
  const _ChartSemantics({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: label,
    child: ExcludeSemantics(
      child: SizedBox(height: _chartHeight, child: child),
    ),
  );
}
