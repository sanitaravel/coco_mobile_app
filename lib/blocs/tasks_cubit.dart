import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'task_model.dart';

class TasksState extends Equatable {
  final List<Task> tasks;

  const TasksState({
    this.tasks = const [],
  });

  TasksState copyWith({
    List<Task>? tasks,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [tasks];
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState()) {
    // Initialize with some sample tasks
    _initializeTasks();
  }

  void _initializeTasks() {
    final tasks = [
      Task(
        id: '1',
        title: 'Film a tutorial',
        subtitle: 'Create a cupcake making tutorial video',
        description: 'Cupcake making',
        steps: [
          'Write a Script',
          'Organize Filming Location',
          'Practice the Script',
          'Record the Video'
        ],
        completedSteps: [false, false, false, false],
        dueDate: DateTime(2026, 1, 11),
      ),
      Task(
        id: '2',
        title: 'Film a tutorial',
        subtitle: 'Create a cupcake making tutorial video',
        description: 'Cupcake making',
        steps: [
          'Write a Script',
          'Organize Filming Location',
          'Practice the Script',
          'Record the Video'
        ],
        completedSteps: [false, false, false, false],
        dueDate: DateTime(2026, 1, 29),
      ),
      Task(
        id: '3',
        title: 'Film a tutorial',
        subtitle: 'Create a cupcake making tutorial video',
        description: 'Cupcake making',
        steps: [
          'Write a Script',
          'Organize Filming Location',
          'Practice the Script',
          'Record the Video'
        ],
        completedSteps: [false, false, false, false],
        dueDate: DateTime(2026, 2, 5),
      ),
      Task(
        id: '4',
        title: 'Film a tutorial',
        subtitle: 'Create a cupcake making tutorial video',
        description: 'Cupcake making',
        steps: [
          'Write a Script',
          'Organize Filming Location',
          'Practice the Script',
          'Record the Video'
        ],
        completedSteps: [false, false, false, false],
        dueDate: DateTime(2026, 2, 12),
      ),
    ];
    emit(state.copyWith(tasks: tasks));
  }

  void addTask(Task task) {
    final updatedTasks = [...state.tasks, task];
    emit(state.copyWith(tasks: updatedTasks));
  }

  void updateTask(String taskId, Task updatedTask) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == taskId ? updatedTask : task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void toggleTaskCompletion(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void toggleTaskStep(String taskId, int stepIndex) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        final currentCompletedSteps = task.safeCompletedSteps;
        final updatedCompletedSteps = List<bool>.from(currentCompletedSteps);
        updatedCompletedSteps[stepIndex] = !updatedCompletedSteps[stepIndex];
        
        // Check if all steps are now completed
        final allStepsCompleted = updatedCompletedSteps.every((step) => step);
        
        return task.copyWith(
          completedSteps: updatedCompletedSteps,
          isCompleted: allStepsCompleted,
        );
      }
      return task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void deleteTask(String taskId) {
    final updatedTasks = state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  Task? getClosestTask() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcomingTasks = state.tasks.where((task) => !task.dueDate.isBefore(today) && !task.isCompleted).toList();
    if (upcomingTasks.isEmpty) return null;

    upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return upcomingTasks.first;
  }

  List<Task> getTasksForDate(DateTime date) {
    return state.tasks.where((task) {
      return task.dueDate.year == date.year &&
             task.dueDate.month == date.month &&
             task.dueDate.day == date.day &&
             !task.isCompleted;
    }).toList();
  }
}