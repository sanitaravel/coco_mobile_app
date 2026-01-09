import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/task_card.dart';
import '../widgets/social_card.dart';
import '../widgets/social_details.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for impressions month to date (30 days)
    final List<FlSpot> spots = List.generate(30, (index) {
      // Mock data: increasing impressions with some variation
      double base = 100 + index * 10;
      double variation = (index % 5) * 20;
      return FlSpot((index + 1).toDouble(), base + variation);
    });

    final double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    final socialNetworks = [
      {'name': 'TikTok', 'subscribers': 1234},
      {'name': 'Instagram', 'subscribers': -567},
    ];

    void showSocialDetails(BuildContext context, String networkName, int subscribers) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SocialDetails(
            networkName: networkName,
            subscribers: subscribers,
          ),
        ),
      );
    }

    List<Widget> socialCards = [];
    for (int i = 0; i < socialNetworks.length; i++) {
      socialCards.add(SizedBox(
        width: 200,
        child: SocialCard(
          networkName: socialNetworks[i]['name'] as String,
          subscribers: socialNetworks[i]['subscribers'] as int,
          onTap: () => showSocialDetails(context, socialNetworks[i]['name'] as String, socialNetworks[i]['subscribers'] as int),
          ),
      ));
      if (i < socialNetworks.length - 1) {
        socialCards.add(SizedBox(width: 16));
      }
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, [name]!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 38,
                letterSpacing: -0.38,
                color: const Color(0xFF3D402E),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFeeefe4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Impressions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: const Color(0xFFB7B8B2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final labelStyle = TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: const Color(0xFFB7B8B2),
                                    );

                                    // Left-most label
                                    if (value == 1) {
                                      return Text('${value.toInt()}.12', style: labelStyle);
                                    }

                                    // Right-most label
                                    if (value == 30) {
                                      return Text('${value.toInt()}.12', style: labelStyle);
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  // remove any reserved space on the left so the axis line
                                  // sits flush with the chart container padding. We then
                                  // translate the labels right so they appear to the
                                  // right of the axis line (inside the chart area).
                                  reservedSize: 0,
                                  getTitlesWidget: (value, meta) {
                                    final labelStyle = TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: const Color(0xFFB7B8B2),
                                    );

                                    // Show only top and bottom ticks (matching the
                                    // original design) and translate them right so the
                                    // text sits just to the right of the y-axis line.
                                    if ((value - maxY).abs() < 0.0001 || value == 0) {
                                      return Text('${value.toInt()}', style: labelStyle);
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            // Hide axis lines: we want only the axis labels/text visible
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData(enabled: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: const Color(0xFF73AE50),
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Upcoming event',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: -0.01,
                color: const Color(0xFF3D402E),
              ),
            ),
            TaskCard(
              title: 'Current Task Title',
              subtitle: 'Subtitle for the current task',
            ),
            const SizedBox(height: 32),
            Text(
              'Socials',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: -0.01,
                color: const Color(0xFF3D402E),
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: socialCards,
              ),
            ),
          ],
        ),
      ),
    );
  } 
}