import 'package:flutter/material.dart';
import 'metric_card.dart';

class SocialDetails extends StatefulWidget {
  final String networkName;
  final int subscribers;

  const SocialDetails({
    super.key,
    required this.networkName,
    required this.subscribers,
  });

  @override
  SocialDetailsState createState() => SocialDetailsState();
}

class SocialDetailsState extends State<SocialDetails> {
  String selectedPeriod = 'Today';

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
              Text(
                widget.networkName,
                style: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w700,
                  fontSize: 38,
                  letterSpacing: -0.38,
                  color: Color(0xFF3D402E),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF3D402E)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Key Metrics',
                style: const TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 16 / 24,
                  color: Color(0xFFA9AD90),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.info_outline,
                color: Color(0xFFA9AD90),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 30 ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: ['Today', 'Week', 'Month'].map((period) {
              final isSelected = selectedPeriod == period;
              return GestureDetector(
                onTap: () => setState(() => selectedPeriod = period),
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontFamily: 'WixMadeforText',
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF548E32) : const Color(0xFF364027),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                MetricCard(
                  metricName: 'Video Views',
                  number: '12,345',
                  changeText: '+1,234 (10.1%)',
                  isPositive: true,
                ),
                MetricCard(
                  metricName: 'Comments',
                  number: '567',
                  changeText: '+89 (18.7%)',
                  isPositive: true,
                ),
                MetricCard(
                  metricName: 'Unique Viewers',
                  number: '8,901',
                  changeText: '+456 (5.4%)',
                  isPositive: true,
                ),
                MetricCard(
                  metricName: 'Shares',
                  number: '234',
                  changeText: '-12 (-4.9%)',
                  isPositive: false,
                ),
                MetricCard(
                  metricName: 'Profile Views',
                  number: '3,456',
                  changeText: '+123 (3.7%)',
                  isPositive: true,
                ),
                MetricCard(
                  metricName: 'Likes',
                  number: '9,876',
                  changeText: '+543 (5.8%)',
                  isPositive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}