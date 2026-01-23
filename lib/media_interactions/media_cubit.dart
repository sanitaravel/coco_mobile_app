import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import 'media_models.dart';

class MediaState extends Equatable {
  final List<MediaItem> photos;
  final List<MediaItem> videos;
  final List<TextPost> posts;

  final bool isPicking;
  final String? error;

  const MediaState({
    this.photos = const [],
    this.videos = const [],
    this.posts = const [],
    this.isPicking = false,
    this.error,
  });

  MediaState copyWith({
    List<MediaItem>? photos,
    List<MediaItem>? videos,
    List<TextPost>? posts,
    bool? isPicking,
    String? error, // set to null to clear
  }) {
    return MediaState(
      photos: photos ?? this.photos,
      videos: videos ?? this.videos,
      posts: posts ?? this.posts,
      isPicking: isPicking ?? this.isPicking,
      error: error,
    );
  }

  @override
  List<Object?> get props => [photos, videos, posts, isPicking, error];
}

class MediaCubit extends Cubit<MediaState> {
  MediaCubit({ImagePicker? picker})
      : _picker = picker ?? ImagePicker(),
        super(const MediaState());

  final ImagePicker _picker;

  Future<void> pickPhotoFromGallery() async {
    await _guardedPick(() async {
      final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
      if (xfile == null) return;

      final item = MediaItem(
        id: _newId(),
        type: MediaType.photo,
        file: File(xfile.path),
      );

      emit(state.copyWith(
        photos: [item, ...state.photos],
        error: null,
      ));
    });
  }

  Future<void> pickVideoFromGallery() async {
    await _guardedPick(() async {
      final XFile? xfile = await _picker.pickVideo(source: ImageSource.gallery);
      if (xfile == null) return;

      final item = MediaItem(
        id: _newId(),
        type: MediaType.video,
        file: File(xfile.path),
      );

      emit(state.copyWith(
        videos: [item, ...state.videos],
        error: null,
      ));
    });
  }

  void addTextPost(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final post = TextPost(
      id: _newId(),
      text: trimmed,
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(posts: [post, ...state.posts], error: null));
  }

  void removePhoto(String id) {
    emit(state.copyWith(
      photos: state.photos.where((p) => p.id != id).toList(),
      error: null,
    ));
  }

  void removeVideo(String id) {
    emit(state.copyWith(
      videos: state.videos.where((v) => v.id != id).toList(),
      error: null,
    ));
  }

  void removePost(String id) {
    emit(state.copyWith(
      posts: state.posts.where((p) => p.id != id).toList(),
      error: null,
    ));
  }

  Future<void> _guardedPick(Future<void> Function() fn) async {
    try {
      emit(state.copyWith(isPicking: true, error: null));
      await fn();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isPicking: false));
    }
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString(); 
}

extension CapturedMedia on MediaCubit {
  void addCapturedPhoto(File file) {
    final item = MediaItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: MediaType.photo,
      file: file,
    );
    emit(state.copyWith(photos: [item, ...state.photos], error: null));
  }

  void addCapturedVideo(File file) {
    final item = MediaItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: MediaType.video,
      file: file,
    );
    emit(state.copyWith(videos: [item, ...state.videos], error: null));
  }
}