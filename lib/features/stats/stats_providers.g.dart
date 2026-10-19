// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streak, this week's totals and the latest PR — from local data, so the
/// Today screen works offline (same rules as `/stats/summary`).

@ProviderFor(todayStats)
final todayStatsProvider = TodayStatsProvider._();

/// Streak, this week's totals and the latest PR — from local data, so the
/// Today screen works offline (same rules as `/stats/summary`).

final class TodayStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayStats>,
          TodayStats,
          FutureOr<TodayStats>
        >
    with $FutureModifier<TodayStats>, $FutureProvider<TodayStats> {
  /// Streak, this week's totals and the latest PR — from local data, so the
  /// Today screen works offline (same rules as `/stats/summary`).
  TodayStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayStatsHash();

  @$internal
  @override
  $FutureProviderElement<TodayStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodayStats> create(Ref ref) {
    return todayStats(ref);
  }
}

String _$todayStatsHash() => r'e9b9421940128083a98bca109c0efb1835e2606a';
