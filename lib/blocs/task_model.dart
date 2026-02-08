import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String>? steps;
  final List<bool>? completedSteps;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    this.steps,
    this.completedSteps,
    required this.dueDate,
    this.isCompleted = false,
  });

  List<String> get safeSteps => steps ?? [];
  List<bool> get safeCompletedSteps => completedSteps ?? List.filled(safeSteps.length, false);

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    List<String>? steps,
    List<bool>? completedSteps,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      completedSteps: completedSteps ?? this.completedSteps,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, description, steps, completedSteps, dueDate, isCompleted];
}