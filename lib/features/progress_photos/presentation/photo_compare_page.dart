import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';
import 'package:saiyagym_mobile/features/progress_photos/presentation/progress_photos_page.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';

/// First vs latest photo of a view, one over the other: drag to reveal.
class PhotoComparePage extends ConsumerStatefulWidget {
  const PhotoComparePage({required this.initialView, super.key});

  final PhotoView initialView;

  @override
  ConsumerState<PhotoComparePage> createState() => _PhotoComparePageState();
}

class _PhotoComparePageState extends ConsumerState<PhotoComparePage> {
  late PhotoView _view = widget.initialView;
  double _split = 0.5;

  @override
  Widget build(BuildContext context) {
    final comparison = ref.watch(photoComparisonProvider(_view));
    final dateFormat = DateFormat.yMMMd(context.locale.toLanguageTag());

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('photos.compare'))),
      body: PlanGate(
        feature: PlanFeature.progressPhotos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ViewSelector(
              value: _view,
              onChanged: (view) => setState(() => _view = view),
            ),
            const SizedBox(height: 16),
            switch (comparison) {
              AsyncValue(
                value: PhotoComparison(:final before?, :final after?),
              ) =>
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${context.tr('photos.before')} · '
                            '${dateFormat.format(before.takenAt.toLocal())}',
                          ),
                        ),
                        Text(
                          '${context.tr('photos.after')} · '
                          '${dateFormat.format(after.takenAt.toLocal())}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _image(after.url),
                            ClipRect(
                              clipper: _LeftClipper(_split),
                              child: _image(before.url),
                            ),
                            Align(
                              alignment: Alignment(_split * 2 - 1, 0),
                              child: Container(width: 2, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Slider(
                      value: _split,
                      label: context.tr('photos.before'),
                      onChanged: (value) => setState(() => _split = value),
                    ),
                  ],
                ),
              AsyncValue(value: PhotoComparison()) => Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  context.tr('photos.needTwo'),
                  textAlign: TextAlign.center,
                ),
              ),
              AsyncValue(:final error?) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  errorText(context, error),
                  textAlign: TextAlign.center,
                ),
              ),
              _ => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
          ],
        ),
      ),
    );
  }

  Widget _image(String url) => Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
  );
}

/// Keeps the left [fraction] of the child.
class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_LeftClipper old) => old.fraction != fraction;
}
