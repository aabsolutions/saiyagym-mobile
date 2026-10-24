/// Execution guides (images / animated GIFs) of global exercises. The API
/// decides who sees which (`GET /guides`): this app only shows what it got.
library;

enum GuideKind { image, animation }

/// What identifies a guide FILE (a record: compared by value).
typedef GuideSource = ({String id, String url});

/// Name of the downloaded copy: the id plus the extension of the URL. A new
/// file (new URL) gets a new id from the API, so a name never goes stale.
String guideFileName(GuideSource source) {
  final path = Uri.parse(source.url).path;
  final dot = path.lastIndexOf('.');
  final extension = dot < 0 ? '' : path.substring(dot).toLowerCase();
  return '${source.id}$extension';
}

/// One guide file, as `ExerciseGuideDto`.
class ExerciseGuide {
  const ExerciseGuide({
    required this.id,
    required this.kind,
    required this.url,
    this.width = 0,
    this.height = 0,
    this.caption = '',
  });

  factory ExerciseGuide.fromJson(Map<String, dynamic> json) => ExerciseGuide(
    id: json['id'] as String,
    kind: json['kind'] == 'animation' ? GuideKind.animation : GuideKind.image,
    url: json['url'] as String,
    width: (json['width'] as num?)?.toInt() ?? 0,
    height: (json['height'] as num?)?.toInt() ?? 0,
    caption: json['caption'] as String? ?? '',
  );

  final String id;
  final GuideKind kind;
  final String url;
  final int width;
  final int height;

  /// Localized by the API; empty when the admin wrote none.
  final String caption;

  GuideSource get source => (id: id, url: url);

  /// `null` when the API didn't report the dimensions.
  double? get aspectRatio => width > 0 && height > 0 ? width / height : null;
}

/// What the user may see for one exercise.
sealed class GuideStatus {
  const GuideStatus();
}

/// The exercise has no guides (or this app doesn't know of any yet).
final class NoGuide extends GuideStatus {
  const NoGuide();
}

/// It has guides the plan doesn't unlock: show a lock + upgrade.
final class GuideLocked extends GuideStatus {
  const GuideLocked();
}

final class GuideUnlocked extends GuideStatus {
  const GuideUnlocked(this.guides);

  /// In display order.
  final List<ExerciseGuide> guides;
}

/// `GuidesDto`: the unlocked exercises with their guides, plus the ones
/// locked by the plan.
class GuideAccess {
  const GuideAccess({
    this.guidesPerRoutine,
    this.unlocked = const {},
    this.locked = const {},
  });

  factory GuideAccess.fromJson(Map<String, dynamic> json) => GuideAccess(
    guidesPerRoutine: (json['guidesPerRoutine'] as num?)?.toInt(),
    unlocked: {
      for (final item in json['items'] as List? ?? const [])
        (item as Map)['exerciseId'] as String: [
          for (final guide in item['guides'] as List? ?? const [])
            ExerciseGuide.fromJson(Map<String, dynamic>.from(guide as Map)),
        ],
    },
    locked: {
      for (final id in json['lockedExerciseIds'] as List? ?? const [])
        id as String,
    },
  );

  /// Nothing known (signed out, never fetched).
  static const empty = GuideAccess();

  /// The plan's value; `null` = every guide.
  final int? guidesPerRoutine;
  final Map<String, List<ExerciseGuide>> unlocked;
  final Set<String> locked;

  GuideStatus statusOf(String exerciseId) {
    final guides = unlocked[exerciseId];
    if (guides != null && guides.isNotEmpty) return GuideUnlocked(guides);
    return locked.contains(exerciseId) ? const GuideLocked() : const NoGuide();
  }

  /// [session] (`POST /guides/resolve`, a session without a routine) only
  /// answers for the exercises it was asked about; it can only ADD unlocks.
  GuideAccess merge(GuideAccess session) {
    final unlocked = {...this.unlocked, ...session.unlocked};
    return GuideAccess(
      guidesPerRoutine: guidesPerRoutine ?? session.guidesPerRoutine,
      unlocked: unlocked,
      locked: {...locked, ...session.locked}.difference(unlocked.keys.toSet()),
    );
  }

  /// Every unlocked guide of [exerciseIds].
  Iterable<GuideSource> sourcesOf(Iterable<String> exerciseIds) =>
      guidesOf(exerciseIds).map((guide) => guide.source);

  Iterable<ExerciseGuide> guidesOf(Iterable<String> exerciseIds) sync* {
    for (final id in exerciseIds) {
      yield* unlocked[id] ?? const <ExerciseGuide>[];
    }
  }
}
