import 'package:flutter/material.dart';
import '../blocs/task_model.dart';

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
    final formattedDate = '${widget.task.dueDate.day.toString().padLeft(2, '0')}.${widget.task.dueDate.month.toString().padLeft(2, '0')}.${widget.task.dueDate.year}';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: const Color(0xFFeeefe4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Color(0xFFeeefe4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Color(0xFF3D402E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.task.subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFA9AD90),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFF3D402E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.task.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFF3D402E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            color: isSelected ? const Color(0xFFA9AD90) : const Color(0xFF364027),
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