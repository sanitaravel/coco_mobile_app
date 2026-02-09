import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

extension TaskFirestore on Task {
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'steps': steps ?? <String>[],
      'completedSteps': completedSteps ?? List<bool>.filled(steps?.length ?? 0, false),
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }

  static Task fromMap(String id, Map<String, dynamic> map) {
    final ts = map['dueDate'];
    DateTime due;
    if (ts is Timestamp) {
      due = ts.toDate();
    } else if (ts is DateTime) {
      due = ts;
    } else {
      due = DateTime.now();
    }

    final stepsList = (map['steps'] as List<dynamic>?)?.map((e) => e as String).toList();
    final completed = (map['completedSteps'] as List<dynamic>?)?.map((e) => e as bool).toList();

    return Task(
      id: id,
      title: (map['title'] as String?) ?? '',
      subtitle: (map['subtitle'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      steps: stepsList,
      completedSteps: completed,
      dueDate: due,
      isCompleted: (map['isCompleted'] as bool?) ?? false,
    );
  }
}