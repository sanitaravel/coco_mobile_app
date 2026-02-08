import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const TutorialCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Reduced width to fit better
      margin: const EdgeInsets.only(right: 8), // Reduced margin from 16 to 8
      child: Card(
        elevation: 0,
        color: const Color(0xFFEEEFE4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: const Color(0xFFD4D7C4),
        child: Padding(
          padding: const EdgeInsets.all(8), // Reduced padding from 12 to 8
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Added this to prevent overflow
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(5), // 0.3125rem = 5px
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0,      0,      0,      1, 0,
                  ]),
                  child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        height: 100, // Reduced height
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 100,
                            width: double.infinity,
                            color: const Color(0xFFEEEFE4),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF73AE50)),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            color: const Color(0xFFEEEFE4),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Color(0xFFA9AD90),
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        height: 100, // Reduced height
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            color: const Color(0xFFEEEFE4),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Color(0xFFA9AD90),
                              size: 40,
                            ),
                          );
                        },
                      ),
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF393B31),
                  fontFamily: 'WixMadeforText',
                  fontSize: 13, // 0.8125rem = 13px
                  fontWeight: FontWeight.w500,
                  height: 1.2, // Adjusted line height
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // Reduced spacing
              // Subtitle
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFA9AD90),
                  fontFamily: 'WixMadeforText',
                  fontSize: 13, // 0.8125rem = 13px
                  fontWeight: FontWeight.w500,
                  height: 1.2, // Adjusted line height
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}