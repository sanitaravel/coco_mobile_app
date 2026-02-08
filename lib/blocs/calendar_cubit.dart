import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime currentMonth;

  const CalendarState({
    required this.currentMonth,
  });

  CalendarState copyWith({
    DateTime? currentMonth,
  }) {
    return CalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }

  @override
  List<Object?> get props => [currentMonth];
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(CalendarState(
          currentMonth: DateTime(DateTime.now().year, DateTime.now().month),
        ));

  void nextMonth() {
    final current = state.currentMonth;
    final nextMonth = DateTime(current.year, current.month + 1);
    emit(state.copyWith(currentMonth: nextMonth));
  }

  void previousMonth() {
    final current = state.currentMonth;
    final previousMonth = DateTime(current.year, current.month - 1);
    emit(state.copyWith(currentMonth: previousMonth));
  }

  void goToMonth(DateTime month) {
    emit(state.copyWith(currentMonth: DateTime(month.year, month.month)));
  }
}