import 'package:json_annotation/json_annotation.dart';

/// Only normal / dropset / failure count for volume and PRs; warmups never.
enum SetType {
  warmup,
  normal,
  dropset,
  failure;

  bool get countsForVolume => this != warmup;
}

/// Exercise tier per goal (S best).
enum Tier {
  @JsonValue('S')
  s,
  @JsonValue('A')
  a,
  @JsonValue('B')
  b,
  @JsonValue('C')
  c,
}

enum Goal { hypertrophy, powerlifting }
