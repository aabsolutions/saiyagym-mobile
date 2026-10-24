import 'package:flutter_test/flutter_test.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';

Map<String, Object> guideJson(String id, {String kind = 'image'}) => {
  'id': id,
  'kind': kind,
  'url':
      'https://res.cloudinary.com/demo/image/upload/q_auto/'
      'gymapp/production/exercises/guides/$id.${kind == 'animation' ? 'gif' : 'png'}',
  'width': 480,
  'height': 360,
  'caption': kind == 'animation' ? 'Baja controlado' : '',
};

void main() {
  final access = GuideAccess.fromJson({
    'guidesPerRoutine': 5,
    'items': [
      {
        'exerciseId': 'squat',
        'guides': [guideJson('g1', kind: 'animation'), guideJson('g2')],
      },
    ],
    'lockedExerciseIds': ['bench'],
  });

  test('parses the API answer in display order', () {
    expect(access.guidesPerRoutine, 5);
    final status = access.statusOf('squat') as GuideUnlocked;
    expect(status.guides.map((g) => g.id), ['g1', 'g2']);
    expect(status.guides.first.kind, GuideKind.animation);
    expect(status.guides.first.caption, 'Baja controlado');
    expect(status.guides.first.aspectRatio, closeTo(4 / 3, 1e-9));
  });

  test('status: unlocked, locked by the plan, or no guide at all', () {
    expect(access.statusOf('squat'), isA<GuideUnlocked>());
    expect(access.statusOf('bench'), isA<GuideLocked>());
    expect(access.statusOf('curl'), isA<NoGuide>());
    expect(GuideAccess.empty.statusOf('squat'), isA<NoGuide>());
  });

  test('premium (null) parses as unlimited', () {
    expect(
      GuideAccess.fromJson({'guidesPerRoutine': null}).guidesPerRoutine,
      isNull,
    );
  });

  test('a session answer only adds unlocks', () {
    final session = GuideAccess.fromJson({
      'guidesPerRoutine': 5,
      'items': [
        {
          'exerciseId': 'bench',
          'guides': [guideJson('g3')],
        },
      ],
      'lockedExerciseIds': ['row'],
    });
    final merged = access.merge(session);
    expect(merged.statusOf('squat'), isA<GuideUnlocked>());
    expect(merged.statusOf('bench'), isA<GuideUnlocked>());
    expect(merged.statusOf('row'), isA<GuideLocked>());
  });

  test('file names: guide id + the extension of the url (no query)', () {
    final guide = ExerciseGuide.fromJson(guideJson('g1', kind: 'animation'));
    expect(guideFileName(guide.source), 'g1.gif');
    expect(
      guideFileName((id: 'g9', url: 'https://cdn/x/abc.PNG?_a=1')),
      'g9.png',
    );
    // Records compare by value: a stable provider key.
    expect(guide.source, (id: 'g1', url: guide.url));
  });

  test('sourcesOf lists the unlocked files of the given exercises', () {
    expect(access.sourcesOf(['squat', 'bench', 'curl']).map((s) => s.id), [
      'g1',
      'g2',
    ]);
  });
}
