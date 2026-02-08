import 'package:flutter/material.dart';
import '../widgets/tutorial_card.dart';
import '../widgets/article_details.dart';
import 'article_data.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({super.key});

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  int _selectedIndex = 0;
  // Example article data
  final List<ArticleData> articles = [
    ArticleData(
      title: 'Public Speaking Basics',
      author: 'Jane Doe',
      content: '''# Public Speaking 101\n\n## Introduction\n\nPublic speaking is a vital skill for personal and professional success.\n\n---\n\n### Key Points\n\n- **Preparation** is the foundation of a great speech.\n- Practice makes perfect.\n- Know your audience.\n\n## Steps to Improve\n\n1. Write an outline.\n2. Rehearse in front of a mirror.\n3. Record yourself and review.\n4. Ask for feedback.\n\n> "The success of your presentation will be judged not by the knowledge you send but by what the listener receives."\n\n## Resources\n\n- [Toastmasters International](https://www.toastmasters.org/)\n- [TED Talks](https://www.ted.com/talks)\n\n---\n\nThank you for reading!\n''',
      imagePath: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=300&fit=crop&crop=center',
      subtitle: 'Learn the fundamentals of effective communication',
    ),
    ArticleData(
      title: 'Content Writing Tips',
      author: 'John Smith',
      content: '''# Content Writing Tips\n\n## Why Good Writing Matters\n\nGood content writing can help you connect with your audience and achieve your goals.\n\n---\n\n### Tips\n\n- Use **clear** and *concise* language.\n- Structure your text with headings and lists.\n- Add images and links for engagement.\n\n## Example Structure\n\n1. **Headline**: Grab attention\n2. **Introduction**: Set the stage\n3. **Body**: Deliver value\n4. **Conclusion**: Summarize and call to action\n\n---\n\n> "The pen is mightier than the sword."\n\n## Further Reading\n\n- [Copyblogger](https://copyblogger.com/)\n- [Grammarly Blog](https://www.grammarly.com/blog/)\n''',
      imagePath: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop&crop=center',
      subtitle: 'Master the art of engaging written content',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(30.0),
            child: Text(
              'Recommended',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 38,
                letterSpacing: -0.38,
                color: const Color(0xFF3D402E),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showArticleDetails(context, articles[0]),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  articles[0].imagePath,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -50,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: SizedBox(
                      width: 280,
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFF73AE50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tutorial',
                                    style: TextStyle(
                                      fontFamily: 'Wix Madefor Text',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: const Color(0xFF1E4109),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    articles[0].title,
                                    style: TextStyle(
                                      fontFamily: 'Wix Madefor Text',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      height: 1,
                                      letterSpacing: -0.01,
                                      color: const Color(0xFFDFE1D3),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 210,
                                    child: Text(
                                      articles[0].subtitle,
                                      style: TextStyle(
                                        fontFamily: 'Wix Madefor Text',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        height: 16 / 14,
                                        color: const Color(0xFFB9E59F),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: const Color(0xFFDFE1D3),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: 50,
              child: ListView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                children: List.generate(4, (index) {
                  final tags = ['Public speaking', 'Writing', 'Filming', 'Research'];
                  final tag = tags[index];
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: _buildTag(tag, index == _selectedIndex),
                      ),
                      if (index < 3) const SizedBox(width: 8),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => _showArticleDetails(context, article),
                  child: TutorialCard(
                    imagePath: article.imagePath,
                    title: article.title,
                    subtitle: article.subtitle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontFamily: 'Wix Madefor Text',
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 16,
          color: isSelected ? const Color(0xFF548E32) : const Color(0xFF364027),
        ),
        child: Text(text),
      ),
    );
  }
  void _showArticleDetails(BuildContext context, ArticleData article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.92,
        child: ArticleDetails(
          title: article.title,
          author: article.author,
          content: article.content,
        ),
      ),
    );
  }
}