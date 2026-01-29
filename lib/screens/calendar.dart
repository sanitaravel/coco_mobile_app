import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: CalendarWidget(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Tasks',
                        style: const TextStyle(
                          color: Color(0xFF364027),
                          fontFamily: 'WixMadeforText',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: const Color(0xFF73AE50),
                          padding: const EdgeInsets.all(8),
                          elevation: 0,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.plus,
                          color: Color(0xFFDFE1D3),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  // Task list placeholder
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(
                          title: Text('Task on 11 Jan 2026'),
                        ),
                        ListTile(
                          title: Text('Task on 29 Jan 2026'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> taskDates = [
      DateTime(2026, 1, 11),
      DateTime(2026, 1, 29),
    ];
    const List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    String monthName = monthNames[now.month - 1];
    int year = now.year;
    int month = now.month;
    DateTime firstDay = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int startWeekday = firstDay.weekday; // 1=Mon, 7=Sun

    const List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day numbers
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime dayDate = DateTime(year, month, day);
      DateTime today = DateTime.now();
      DateTime todayDate = DateTime(today.year, today.month, today.day);
      bool isPassed = dayDate.isBefore(todayDate);
      TextStyle dayStyle = isPassed
          ? const TextStyle(
              color: Color(0x88364027), // with opacity 0.5
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )
          : const TextStyle(
              color: Color(0xFF364027),
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            );
      bool hasTask = taskDates.contains(dayDate);
      Widget dayWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$day',
            style: dayStyle,
          ),
          hasTask
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF73AE50),
                    shape: BoxShape.circle,
                  ),
                )
              : const SizedBox(height: 6),
        ],
      );
      dayWidgets.add(
        Center(
          child: dayWidget,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName,
          style: const TextStyle(
            color: Color(0xFF3D402E),
            fontFamily: 'WixMadeforText',
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.38,
          ),
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekdays.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Color(0xFF364027),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )).toList(),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: dayWidgets,
            ),
          ),
        ],
      );
  }
}