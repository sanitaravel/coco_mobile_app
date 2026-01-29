import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, description, dueDate, isCompleted];
}