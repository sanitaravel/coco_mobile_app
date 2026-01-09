import 'package:flutter/material.dart';

class SocialCard extends StatelessWidget {
  final String networkName;
  final int subscribers;
  final VoidCallback? onTap;

  const SocialCard({
    super.key,
    required this.networkName,
    required this.subscribers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String sign = subscribers >= 0 ? '+' : '-';
    String unit = subscribers.abs() == 1 ? 'subscriber' : 'subscribers';
    String formattedSubscribers = '$sign${subscribers.abs()} $unit';

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 0,
        color: const Color(0xFFeeefe4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    networkName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.0,
                      letterSpacing: -0.01,
                      color: Color(0xFF73AE50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF73AE50),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formattedSubscribers,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 24 / 16,
                  letterSpacing: -0.01,
                  color: Color(0xFFA9AD90),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}