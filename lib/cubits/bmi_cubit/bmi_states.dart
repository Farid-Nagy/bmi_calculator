part of 'bmi_cubit.dart';

@override
abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiLoading extends BmiState {}

class BmiWarningState extends BmiState {
  final String message;
  BmiWarningState(this.message);
}

class BmiCalculated extends BmiState {
  final double bmi;
  final String category;
  BmiCalculated({required this.bmi, required this.category});
}

class BmiError extends BmiState {
  final String message;
  BmiError(this.message);
}
