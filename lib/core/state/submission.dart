import 'package:riverpod_annotation/riverpod_annotation.dart';

/// State of a form submission: only loading / error matter, the result goes
/// elsewhere (usually the session). Maps the action's result to it.
AsyncValue<void> submissionOf<T>(AsyncValue<T> result) => switch (result) {
  AsyncData() => const AsyncData(null),
  AsyncError(:final error, :final stackTrace) => AsyncError(error, stackTrace),
  AsyncLoading() => const AsyncLoading(),
};
