import 'package:equatable/equatable.dart';

class TimeValue extends Equatable {
  final int hour;
  final int minute;

  const TimeValue({required this.hour, required this.minute});

  @override
  List<Object?> get props => [hour, minute];
}
