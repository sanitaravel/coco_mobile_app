import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_model.dart';
import '../blocs/tasks_cubit.dart';
import '../blocs/navigation_bloc.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${widget.task.dueDate.day.toString().padLeft(2, '0')}.${widget.task.dueDate.month.toString().padLeft(2, '0')}.${widget.task.dueDate.year}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: const Color(0xFFeeefe4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          _showTaskDescription(context);
        },
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          title: Text(
            widget.task.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              height: 1.0,
              letterSpacing: -0.01,
              color: Color(0xFF3D402E),
            ),
          ),
          subtitle: Text(
            '${widget.task.subtitle} - Due: $formattedDate',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 16 / 14,
              color: Color(0xFFA9AD90),
            ),
          ),
          trailing: RadioButton(
            isSelected: _isSelected,
            onTap: () => setState(() => _isSelected = !_isSelected),
          ),
        ),
      ),
    );
  }

  void _showTaskDescription(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: tasksCubit,
          child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              // Find the current task from the updated state
              final currentTask = state.tasks.firstWhere(
                (task) => task.id == widget.task.id,
                orElse: () => widget.task,
              );
              final formattedDate =
                  '${currentTask.dueDate.day.toString().padLeft(2, '0')}.${currentTask.dueDate.month.toString().padLeft(2, '0')}.${currentTask.dueDate.year}';

              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  color: Color(0xFFDFE1D3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA9AD90),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Task name
                            Text(
                              currentTask.title,
                              style: const TextStyle(
                                color: Color(0xFF3D402E),
                                fontFamily: 'WixMadeforText',
                                fontSize: 38,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing:
                                    -0.02375 *
                                    16, // Convert rem to pixels approximately
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Description
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                currentTask.description,
                                style: const TextStyle(
                                  color: Color(0xFF3D402E),
                                  fontFamily: 'WixMadeforText',
                                  fontSize: 32,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  letterSpacing: -0.02 * 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Expiration date
                            Text(
                              'Until $formattedDate',
                              style: const TextStyle(
                                color: Color(0xFFA9AD90),
                                fontFamily: 'WixMadeforText',
                                fontSize: 24,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Steps
                            ...currentTask.safeSteps.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final step = entry.value;
                              final isCompleted =
                                  currentTask.safeCompletedSteps[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    CircularCheckbox(
                                      isSelected: isCompleted,
                                      onTap: () {
                                        context
                                            .read<TasksCubit>()
                                            .toggleTaskStep(
                                              currentTask.id,
                                              index,
                                            );
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        step,
                                        style: TextStyle(
                                          color: const Color(0xFF364027),
                                          fontFamily: 'WixMadeforText',
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          height: 1.1,
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: const Color(
                                            0xFF364027,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 30),
                            // Bottom buttons
                            Row(
                              children: [
                                // Delete button
                                TextButton(
                                  onPressed: () {
                                    context.read<TasksCubit>().deleteTask(
                                      currentTask.id,
                                    );
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the modal
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Color(0xFF3D402E),
                                      fontFamily: 'WixMadeforText',
                                      fontSize: 24,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      letterSpacing: -0.015 * 16,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // Go to media button
                                TextButton(
                                  onPressed: () {
                                    // Navigate to media page (index 2)
                                    context.read<NavigationBloc>().add(
                                      ChangePage(2),
                                    );
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the modal
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Go to Media',
                                        style: const TextStyle(
                                          color: Color(0xFF73AE50),
                                          fontFamily: 'WixMadeforText',
                                          fontSize: 24,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          letterSpacing: -0.015 * 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFF73AE50),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const RadioButton({super.key, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA9AD90)
                : const Color(0xFF364027),
            width: 3,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            width: isSelected ? 12 : 0,
            height: isSelected ? 12 : 0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFA9AD90),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularCheckbox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CircularCheckbox({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA9AD90)
                : const Color(0xFF364027),
            width: 2,
          ),
          color: isSelected ? const Color(0xFFA9AD90) : Colors.transparent,
        ),
        child: Center(
          child: isSelected
              ? const Icon(Icons.check, color: Color(0xFFDFE1D3), size: 16)
              : null,
        ),
      ),
    );
  }
}
