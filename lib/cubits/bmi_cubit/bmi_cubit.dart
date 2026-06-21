import 'package:flutter_bloc/flutter_bloc.dart';

part 'bmi_states.dart';

class BmiCubit extends Cubit<BmiState> {
  BmiCubit() : super(BmiInitial());

  void calculateBmi({
    required double weight,
    required double height, // in meters
    required int age,
  }) {
    if (weight < 10 || age < 5) {
      emit(BmiWarningState('Please enter logical data, Hero!'));
      return;
    }

    if (weight <= 0 || height <= 0 || age <= 0) {
      emit(BmiError('Weight, height, and age must be greater than zero'));
      return;
    }

    emit(BmiLoading());

    Future.delayed(const Duration(milliseconds: 400), () {
      final bmi = weight / (height * height);
      final category = _getCategory(bmi);
      emit(BmiCalculated(bmi: bmi, category: category));
    });
  }

  String _getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  void reset() {
    emit(BmiInitial());
  }
}
