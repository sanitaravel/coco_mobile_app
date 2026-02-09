import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'task_model.dart';
import '../services/task_service.dart';

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
  final TaskService _service;
  StreamSubscription<List<Task>>? _sub;
  String? _currentUid;

  TasksCubit({TaskService? service}) : _service = service ?? TaskService(), super(const TasksState()) {
    // Initialize with some sample tasks while not connected to Firestore
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

  Future<void> addTask(Task task) async {
    // optimistic local add
    final updatedTasks = [...state.tasks, task];
    emit(state.copyWith(tasks: updatedTasks));

    if (_currentUid != null) {
      try {
        final newId = await _service.createTask(_currentUid!, task);
        // replace optimistic task id with server id
        final replaced = state.tasks.map((t) {
          if (t.id == task.id) {
            return t.copyWith(id: newId);
          }
          return t;
        }).toList();
        emit(state.copyWith(tasks: replaced));
      } catch (_) {
        // on failure, revert optimistic add
        final reverted = state.tasks.where((t) => t.id != task.id).toList();
        emit(state.copyWith(tasks: reverted));
      }
    }
  }

  void updateTask(String taskId, Task updatedTask) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == taskId ? updatedTask : task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));

    if (_currentUid != null) {
      _service.updateTask(_currentUid!, updatedTask).catchError((_) {
        // no-op on failure for now; could re-fetch
      });
    }
  }

  void toggleTaskCompletion(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
    final changed = updatedTasks.firstWhere((t) => t.id == taskId);
    if (_currentUid != null) {
      _service.updateTask(_currentUid!, changed).catchError((_) {});
    }
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
    final changed = updatedTasks.firstWhere((t) => t.id == taskId);
    if (_currentUid != null) {
      _service.updateTask(_currentUid!, changed).catchError((_) {});
    }
  }

  void deleteTask(String taskId) {
    final updatedTasks = state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));

    if (_currentUid != null) {
      _service.deleteTask(_currentUid!, taskId).catchError((_) {
        // no-op for now; could re-fetch on failure
      });
    }
  }

  /// Start listening for tasks for the given user id.
  void setUser(String uid) {
    if (_currentUid == uid) return;
    _currentUid = uid;
    _sub?.cancel();
    _sub = _service.tasksStreamForUser(uid).listen((tasks) {
      emit(state.copyWith(tasks: tasks));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
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