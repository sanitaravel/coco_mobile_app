import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MetricCard extends StatelessWidget {
  final String metricName;
  final String number;
  final String changeText;
  final bool isPositive;

  const MetricCard({
    super.key,
    required this.metricName,
    required this.number,
    required this.changeText,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFE4),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metricName,
            style: const TextStyle(
              fontFamily: 'WixMadeforText',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.1,
              color: Color(0xFF393B31),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: Color(0xFF393B31),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFA9AD90),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    isPositive ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                    color: const Color(0xFFEEEFE4),
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                changeText,
                style: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  color: Color(0xFFA9AD90),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}