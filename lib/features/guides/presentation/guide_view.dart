import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saiyagym_mobile/features/guides/domain/exercise_guide.dart';
import 'package:saiyagym_mobile/features/guides/guides_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_sheet.dart';

/// Opens the guide of one exercise (live session): its files, or why it is
/// locked.
Future<void> showGuideSheet(
  BuildContext context, {
  required String exerciseName,
  required GuideStatus status,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(exerciseName, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GuideSection(status: status),
      ],
    ),
  ),
);

/// The guide area of an exercise; nothing when it has no guides.
class GuideSection extends StatelessWidget {
  const GuideSection({required this.status, super.key});

  final GuideStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    NoGuide() => const SizedBox.shrink(),
    GuideLocked() => const GuideLockedCard(),
    GuideUnlocked(:final guides) => GuideCarousel(guides: guides),
  };
}

class GuideLockedCard extends StatelessWidget {
  const GuideLockedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: scheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.tr('guides.locked.title'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('guides.locked.message'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.workspace_premium),
              label: Text(context.tr('plans.cta.action')),
              onPressed: () => showUpgradeSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Swipeable guide files with their captions. GIFs animate (Flutter plays
/// them natively from the downloaded file).
class GuideCarousel extends StatefulWidget {
  const GuideCarousel({required this.guides, super.key});

  final List<ExerciseGuide> guides;

  @override
  State<GuideCarousel> createState() => _GuideCarouselState();
}

class _GuideCarouselState extends State<GuideCarousel> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guides = widget.guides;
    final page = _page.clamp(0, guides.length - 1);
    final caption = guides[page].caption;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Square box: the files are capped to 1080 px on both sides and
        // shown whole (contain), so nothing is cropped.
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainerHighest,
              child: PageView.builder(
                controller: _controller,
                itemCount: guides.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) => _GuideImage(
                  guide: guides[index],
                  label: context.tr(
                    'guides.imageLabel',
                    namedArgs: {
                      'n': '${index + 1}',
                      'total': '${guides.length}',
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (guides.length > 1) ...[
          const SizedBox(height: 8),
          _Dots(count: guides.length, current: page),
        ],
        if (caption.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(caption, style: theme.textTheme.bodyLarge),
        ],
      ],
    );
  }
}

class _GuideImage extends ConsumerWidget {
  const _GuideImage({required this.guide, required this.label});

  final ExerciseGuide guide;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(guideFileProvider(guide.source));
    return switch (file) {
      AsyncData(value: final file?) => Image.file(
        file,
        fit: BoxFit.contain,
        semanticLabel: guide.caption.isEmpty
            ? label
            : '$label. ${guide.caption}',
        errorBuilder: (context, _, _) => _Unavailable(label: label),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      _ => _Unavailable(label: label),
    };
  }
}

/// Not downloaded and no network.
class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 8),
            Text(context.tr('guides.offline'), textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == current ? scheme.primary : scheme.outlineVariant,
              ),
            ),
        ],
      ),
    );
  }
}
