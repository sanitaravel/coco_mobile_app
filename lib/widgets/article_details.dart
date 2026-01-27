import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class ArticleDetails extends StatelessWidget {
  final String title;
  final String author;
  final String content;

  const ArticleDetails({
    super.key,
    required this.title,
    required this.author,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFDFE1D3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'WixMadeforText',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    letterSpacing: -0.38,
                    color: Color(0xFF3D402E),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF3D402E)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'By $author',
            style: const TextStyle(
              fontFamily: 'WixMadeforText',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFFA9AD90),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Markdown(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontSize: 18,
                  color: Color(0xFF364027),
                  height: 1.5,
                ),
                h1: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF3D402E),
                ),
                h2: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color(0xFF3D402E),
                ),
                h3: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF3D402E),
                ),
                listBullet: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontSize: 18,
                  color: Color(0xFF364027),
                ),
                blockquote: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  color: Color(0xFF3D402E),
                ),
                blockquotePadding: EdgeInsets.all(16),
                blockquoteDecoration: BoxDecoration(
                  color: Color(0xFFB9E59F), // Greenish background
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1, // Thinner line
                    ),
                  ),
                ),
                a: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF548E32), // Brand green
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
