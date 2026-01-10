import 'package:flutter/material.dart';
import '../widgets/article_details.dart';
import '../widgets/tutorial_card.dart';

class ArticleData {
  final String title;
  final String author;
  final String content;
  final String imagePath;
  final String subtitle;

  ArticleData({
    required this.title,
    required this.author,
    required this.content,
    required this.imagePath,
    required this.subtitle,
  });
}
