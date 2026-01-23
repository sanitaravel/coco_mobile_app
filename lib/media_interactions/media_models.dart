import 'dart:io';

enum MediaType { photo, video }

class MediaItem {
  final String id;
  final MediaType type;
  final File file;

  const MediaItem({
    required this.id,
    required this.type,
    required this.file,
  });
}

class TextPost {
  final String id;
  final String text;
  final DateTime createdAt;

  const TextPost({
    required this.id,
    required this.text,
    required this.createdAt,
  });
}