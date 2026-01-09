import 'package:flutter/material.dart';
import '../widgets/tutorial_card.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({super.key});

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  int _selectedIndex = 0;

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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1538449327350-43b4fcfd35ac?q=80&w=1173&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                                  'Public speaking 101',
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
                                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula e',
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
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: 50,
              child: ListView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                children: [
                  'Public speaking',
                  'Writing',
                  'Filming',
                  'Research',
                ].asMap().entries.map((entry) {
                  int index = entry.key;
                  String tag = entry.value;
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: _buildTag(tag, index == _selectedIndex),
                      ),
                      if (index < 3) const SizedBox(width: 8),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                TutorialCard(
                  imagePath: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=300&fit=crop&crop=center',
                  title: 'Public Speaking Basics',
                  subtitle: 'Learn the fundamentals of effective communication',
                ),
                TutorialCard(
                  imagePath: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop&crop=center',
                  title: 'Content Writing Tips',
                  subtitle: 'Master the art of engaging written content',
                ),
                TutorialCard(
                  imagePath: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=300&fit=crop&crop=center',
                  title: 'Public Speaking Basics',
                  subtitle: 'Learn the fundamentals of effective communication',
                ),
                TutorialCard(
                  imagePath: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400&h=300&fit=crop&crop=center',
                  title: 'Content Writing Tips',
                  subtitle: 'Master the art of engaging written content',
                ),
              ],
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
}