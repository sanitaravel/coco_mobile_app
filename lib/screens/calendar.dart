import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/calendar_cubit.dart';
import '../blocs/tasks_cubit.dart';
import '../widgets/task_card.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Scaffold(
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
                    BlocBuilder<TasksCubit, TasksState>(
                      builder: (context, state) {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final upcomingTasks = state.tasks
                            .where((task) => !task.isCompleted && !task.dueDate.isBefore(today))
                            .toList()
                          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                        if (upcomingTasks.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                'No upcoming tasks',
                                style: TextStyle(
                                  color: Color(0xFFA9AD90),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: upcomingTasks.length,
                            itemBuilder: (context, index) {
                              final task = upcomingTasks[index];
                              return TaskCard(
                                task: task,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, calendarState) {
        return BlocBuilder<TasksCubit, TasksState>(
          builder: (context, tasksState) {
            final pageController = PageController(initialPage: 1); // Start at current month

            return PageView.builder(
              controller: pageController,
              onPageChanged: (pageIndex) {
                if (pageIndex == 0) {
                  // Swiped to previous month
                  context.read<CalendarCubit>().previousMonth();
                  pageController.jumpToPage(1); // Reset to middle page
                } else if (pageIndex == 2) {
                  // Swiped to next month
                  context.read<CalendarCubit>().nextMonth();
                  pageController.jumpToPage(1); // Reset to middle page
                }
              },
              itemBuilder: (context, pageIndex) {
                DateTime displayMonth;
                if (pageIndex == 0) {
                  // Previous month
                  displayMonth = DateTime(calendarState.currentMonth.year, calendarState.currentMonth.month - 1);
                } else if (pageIndex == 2) {
                  // Next month
                  displayMonth = DateTime(calendarState.currentMonth.year, calendarState.currentMonth.month + 1);
                } else {
                  // Current month
                  displayMonth = calendarState.currentMonth;
                }

                return _buildCalendarForMonth(displayMonth, context.read<TasksCubit>());
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCalendarForMonth(DateTime month, TasksCubit tasksCubit) {
    const List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    String monthName = monthNames[month.month - 1];
    int year = month.year;
    DateTime firstDay = DateTime(year, month.month, 1);
    int daysInMonth = DateTime(year, month.month + 1, 0).day;
    int startWeekday = firstDay.weekday; // 1=Mon, 7=Sun

    const List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day numbers
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime dayDate = DateTime(year, month.month, day);
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
      List tasksForDate = tasksCubit.getTasksForDate(dayDate);
      bool hasTask = tasksForDate.isNotEmpty;
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
          '$monthName $year',
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