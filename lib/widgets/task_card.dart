import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String subtitle;

  const TaskCard({super.key, required this.title, required this.subtitle});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: const Color(0xFFeeefe4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 1.0,
            letterSpacing: -0.01,
            color: Color(0xFF3D402E),
          ),
        ),
        subtitle: Text(
          widget.subtitle,
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