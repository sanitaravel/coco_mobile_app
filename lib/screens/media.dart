import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../media_interactions/media_cubit.dart';
import 'camera.dart';

enum _AddTarget { photo, video }

class Media extends StatelessWidget {
  const Media({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MediaCubit(),
      child: const _MediaView(),
    );
  }
}

class _MediaView extends StatelessWidget {
  const _MediaView();

  static const _bg = Color(0xFFDFE1D3); 
  static const _accent = Color(0xFF73AE50); 
  static const _text = Color(0xFF3D402E);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
      ),
      body: BlocBuilder<MediaCubit, MediaState>(
        builder: (context, state) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  if (state.error != null) ...[
                    _ErrorBanner(message: state.error!),
                    const SizedBox(height: 12),
                  ],
                  _Section(
                    title: 'Videos',
                    accent: _accent,
                    onAdd: () => _openAddMediaSheet(context, target: _AddTarget.video),
                    items: state.videos
                        .map((v) => _ThumbItem.video(
                              id: v.id,
                              file: v.file,
                              onRemove: () => context.read<MediaCubit>().removeVideo(v.id),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 26),
                  _Section(
                    title: 'Photos',
                    accent: _accent,
                    onAdd: () => _openAddMediaSheet(context, target: _AddTarget.photo),
                    items: state.photos
                        .map((p) => _ThumbItem.photo(
                              id: p.id,
                              file: p.file,
                              onRemove: () => context.read<MediaCubit>().removePhoto(p.id),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 26),
                  _Section(
                    title: 'Posts',
                    accent: _accent,
                    onAdd: () => _openAddPostSheet(context),
                    items: state.posts
                        .map((p) => _ThumbItem.post(
                              id: p.id,
                              text: p.text,
                              onRemove: () => context.read<MediaCubit>().removePost(p.id),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
              if (state.isPicking)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: Color(0x33000000),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openAddPostSheet(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write something...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<MediaCubit>().addTextPost(controller.text);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
void _openAddMediaSheet(BuildContext context, {required _AddTarget target}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.pop(ctx);

                    final cubit = context.read<MediaCubit>();
                    if (target == _AddTarget.photo) {
                      await cubit.pickPhotoFromGallery();
                    } else {
                      await cubit.pickVideoFromGallery();
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Use camera'),
                  onTap: () async {
                    Navigator.pop(ctx);

                    final result = await Navigator.push<CaptureResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraCapturePage(
                          initialMode: target == _AddTarget.photo
                              ? CaptureMode.photo
                              : CaptureMode.video,
                        ),
                      ),
                    );

                    if (result == null) return;

                    final cubit = context.read<MediaCubit>();
                    if (result.type == CapturedType.photo) {
                      cubit.addCapturedPhoto(result.file);
                    } else {
                      cubit.addCapturedVideo(result.file);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.onAdd,
    required this.items,
    required this.accent,
  });

  final String title;
  final VoidCallback onAdd;
  final List<_ThumbItem> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w800,
            height: 1.0,
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 1 + items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              if (index == 0) return _AddTile(accent: accent, onTap: onAdd);
              return items[index - 1];
            },
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.accent, required this.onTap});

  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: const SizedBox(
          width: 88,
          height: 88,
          child: Center(
            child: Icon(Icons.add, size: 44, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _ThumbItem extends StatelessWidget {
  const _ThumbItem._({
    required this.child,
    required this.onRemove,
  });

  factory _ThumbItem.photo({
    required String id,
    required File file,
    required VoidCallback onRemove,
  }) {
    return _ThumbItem._(
      onRemove: onRemove,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(file, fit: BoxFit.cover),
      ),
    );
  }

  factory _ThumbItem.video({
    required String id,
    required File file,
    required VoidCallback onRemove,
  }) {
    // For real video thumbs, generate with a thumbnail package or backend.
    // Here we show a placeholder with a play icon.
    return _ThumbItem._(
      onRemove: onRemove,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: const Center(
          child: Icon(Icons.play_circle_fill, size: 42, color: Colors.black54),
        ),
      ),
    );
  }

  factory _ThumbItem.post({
    required String id,
    required String text,
    required VoidCallback onRemove,
  }) {
    return _ThumbItem._(
      onRemove: onRemove,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.85),
        ),
        child: SizedBox(
          width: 140,
          child: Text(
            text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, height: 1.2),
          ),
        ),
      ),
    );
  }

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: const Color(0x66000000),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}