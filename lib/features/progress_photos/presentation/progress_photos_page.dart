import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saiyagym_mobile/app/router/app_routes.dart';
import 'package:saiyagym_mobile/core/feedback/haptics.dart';
import 'package:saiyagym_mobile/core/network/api_exception.dart';
import 'package:saiyagym_mobile/core/widgets/error_banner.dart';
import 'package:saiyagym_mobile/features/plans/domain/entitlements.dart';
import 'package:saiyagym_mobile/features/plans/plans_providers.dart';
import 'package:saiyagym_mobile/features/plans/presentation/upgrade_cta.dart';
import 'package:saiyagym_mobile/features/progress_photos/data/photo_device.dart';
import 'package:saiyagym_mobile/features/progress_photos/domain/progress_photo.dart';
import 'package:saiyagym_mobile/features/progress_photos/presentation/framing_guide.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';

/// Photos of one view: queued ones (local files) first, then uploaded.
class ProgressPhotosPage extends ConsumerStatefulWidget {
  const ProgressPhotosPage({super.key});

  @override
  ConsumerState<ProgressPhotosPage> createState() => _ProgressPhotosPageState();
}

class _ProgressPhotosPageState extends ConsumerState<ProgressPhotosPage> {
  PhotoView _view = PhotoView.front;
  StreamSubscription<ProgressPhoto>? _uploaded;

  @override
  void initState() {
    super.initState();
    final queue = ref.read(photoUploadQueueProvider);
    _uploaded = queue.uploaded.listen(
      (photo) => ref
        ..invalidate(progressPhotosProvider(photo.view))
        ..invalidate(photoComparisonProvider(photo.view)),
    );
    unawaited(queue.process());
  }

  @override
  void dispose() {
    unawaited(_uploaded?.cancel());
    super.dispose();
  }

  Future<void> _capture() async {
    final view = _view;
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _GuideSheet(view: view),
    );
    if (source == null) return;
    final path = await ref.read(photoPickerProvider).pick(source);
    if (path == null || !mounted) return;
    final notes = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PhotoPreviewPage(path: path, view: view),
      ),
    );
    if (notes == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final queued = context.tr('photos.queued');
    final unreadable = context.tr('photos.unreadable');
    try {
      await ref
          .read(photoUploadQueueProvider)
          .enqueue(path, view: view, notes: notes);
      unawaited(confirmHaptic());
      messenger.showSnackBar(SnackBar(content: Text(queued)));
    } on ApiException {
      messenger.showSnackBar(SnackBar(content: Text(unreadable)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final allowed = ref.watch(
      entitlementsProvider.select((p) => p.has(PlanFeature.progressPhotos)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('photos.title')),
        actions: [
          if (allowed)
            IconButton(
              tooltip: context.tr('photos.compare'),
              icon: const Icon(Icons.compare),
              onPressed: () =>
                  unawaited(context.push(AppRoutes.photoCompare(_view))),
            ),
        ],
      ),
      floatingActionButton: allowed
          ? FloatingActionButton.extended(
              onPressed: _capture,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(context.tr('photos.add')),
            )
          : null,
      body: !allowed
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: UpgradeCta.feature(PlanFeature.progressPhotos),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ViewSelector(
                    value: _view,
                    onChanged: (view) => setState(() => _view = view),
                  ),
                ),
                Expanded(child: _PhotoGrid(view: _view)),
              ],
            ),
    );
  }
}

class ViewSelector extends StatelessWidget {
  const ViewSelector({required this.value, required this.onChanged, super.key});

  final PhotoView value;
  final ValueChanged<PhotoView> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<PhotoView>(
    showSelectedIcon: false,
    segments: [
      for (final view in PhotoView.values)
        ButtonSegment(
          value: view,
          label: Text(context.tr('photos.views.${view.name}')),
        ),
    ],
    selected: {value},
    onSelectionChanged: (selection) => onChanged(selection.single),
  );
}

class _PhotoGrid extends ConsumerWidget {
  const _PhotoGrid({required this.view});

  final PhotoView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = [
      for (final photo
          in ref.watch(pendingPhotosProvider).value ?? const <PendingPhoto>[])
        if (photo.view == view) photo,
    ];
    final remote = ref.watch(progressPhotosProvider(view));
    final uploaded = remote.value ?? const <ProgressPhoto>[];
    final dateFormat = DateFormat.yMMMd(context.locale.toLanguageTag());

    if (pending.isEmpty && remote.isLoading && !remote.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: () => ref.refresh(progressPhotosProvider(view).future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (remote.error case final error?)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  errorText(context, error),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (pending.isEmpty && uploaded.isEmpty && remote.hasValue)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    context.tr('photos.empty'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3 / 4,
              children: [
                for (final photo in pending) _PendingTile(photo: photo),
                for (final photo in uploaded)
                  _PhotoTile(
                    photo: photo,
                    caption: dateFormat.format(photo.takenAt.toLocal()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends ConsumerWidget {
  const _PhotoTile({required this.photo, required this.caption});

  final ProgressPhoto photo;
  final String caption;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.tr('photos.deleteTitle')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.tr('common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.tr('common.delete')),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false) || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(progressPhotosApiProvider).delete(photo.id);
      ref
        ..invalidate(progressPhotosProvider(photo.view))
        ..invalidate(photoComparisonProvider(photo.view));
    } on ApiException catch (error) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(errorText(context, error))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onLongPress: () => unawaited(_delete(context, ref)),
    child: _Framed(
      image: Image.network(
        photo.url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
      ),
      caption: caption,
    ),
  );
}

class _PendingTile extends ConsumerWidget {
  const _PendingTile({required this.photo});

  final PendingPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.read(photoUploadQueueProvider);
    final failed = photo.error != null;
    return FutureBuilder<File>(
      future: queue.fileOf(photo),
      builder: (context, file) => InkWell(
        onTap: failed ? () => unawaited(_failedActions(context, ref)) : null,
        child: _Framed(
          image: file.data == null
              ? const SizedBox.shrink()
              : Image.file(
                  file.data!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.broken_image_outlined),
                ),
          caption: context.tr(failed ? 'photos.failed' : 'photos.pending'),
          badge: Icon(failed ? Icons.error_outline : Icons.cloud_upload),
        ),
      ),
    );
  }

  Future<void> _failedActions(BuildContext context, WidgetRef ref) async {
    final queue = ref.read(photoUploadQueueProvider);
    final retry = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.tr('photos.failedTitle')),
              subtitle: Text(
                photo.error == 'PLAN_FEATURE_REQUIRED'
                    ? context.tr('photos.needsPremium')
                    : context.tr('photos.failedMessage'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: Text(context.tr('common.retry')),
              onTap: () => Navigator.pop(sheetContext, true),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(context.tr('photos.discard')),
              onTap: () => Navigator.pop(sheetContext, false),
            ),
          ],
        ),
      ),
    );
    if (retry == null) return;
    await (retry ? queue.retry(photo.id) : queue.discard(photo.id));
  }
}

class _Framed extends StatelessWidget {
  const _Framed({required this.image, required this.caption, this.badge});

  final Widget image;
  final String caption;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      image: true,
      label: caption,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: theme.colorScheme.surfaceContainerHighest),
            image,
            if (badge != null)
              Positioned(
                top: 6,
                right: 6,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.surface,
                  child: IconTheme(
                    data: const IconThemeData(size: 18),
                    child: badge!,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How to take a comparable photo, then camera or gallery.
class _GuideSheet extends StatelessWidget {
  const _GuideSheet({required this.view});

  final PhotoView view;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('photos.guide.title.${view.name}'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                height: 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FramingGuide(view: view),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  [
                    context.tr('photos.guide.${view.name}'),
                    context.tr('photos.guide.same'),
                  ].join('\n\n'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, PhotoSource.camera),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(context.tr('photos.camera')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context, PhotoSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(context.tr('photos.gallery')),
          ),
        ],
      ),
    ),
  );
}

/// The picked photo under the framing guide: use it (with notes) or not.
/// Pops the notes when accepted.
class PhotoPreviewPage extends StatefulWidget {
  const PhotoPreviewPage({required this.path, required this.view, super.key});

  final String path;
  final PhotoView view;

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final _notes = TextEditingController();
  bool _guide = true;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.tr('photos.views.${widget.view.name}')),
      actions: [
        IconButton(
          tooltip: context.tr('photos.toggleGuide'),
          icon: Icon(_guide ? Icons.grid_on : Icons.grid_off),
          onPressed: () => setState(() => _guide = !_guide),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(widget.path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.broken_image_outlined),
                ),
                if (_guide) FramingGuide(view: widget.view),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notes,
          maxLength: 1000,
          decoration: InputDecoration(labelText: context.tr('body.notes')),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('photos.retake')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context, _notes.text),
                child: Text(context.tr('photos.use')),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
