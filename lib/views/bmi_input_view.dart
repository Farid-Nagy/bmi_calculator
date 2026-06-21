import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/bmi_cubit/bmi_cubit.dart';
import 'bmi_result_view.dart';

class BmiInputView extends StatefulWidget {
  const BmiInputView({super.key});

  @override
  State<BmiInputView> createState() => _BmiInputViewState();
}

class _BmiInputViewState extends State<BmiInputView> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _weightController.clear();
    _heightController.clear();
    _ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BmiCubit, BmiState>(
      listener: (context, state) {
        if (state is BmiError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (state is BmiWarningState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.amber,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is BmiCalculated) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BmiResultView(bmi: state.bmi, category: state.category),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('BMI Calculator')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Weight field
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: 'e.g. 70',
                ),
              ),
              const SizedBox(height: 20),
              // Height field
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (m)',
                  prefixIcon: Icon(Icons.height),
                  hintText: 'e.g. 1.75',
                ),
              ),
              const SizedBox(height: 20),
              // Age field
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age (years)',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'e.g. 25',
                ),
              ),
              const SizedBox(height: 40),
              // Buttons row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final weight = double.tryParse(_weightController.text);
                        final height = double.tryParse(_heightController.text);
                        final age = int.tryParse(_ageController.text);
                        if (weight == null || height == null || age == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter valid numbers'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.read<BmiCubit>().calculateBmi(
                          weight: weight,
                          height: height,
                          age: age,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                      ),
                      child: BlocBuilder<BmiCubit, BmiState>(
                        builder: (context, state) {
                          if (state is BmiLoading) {
                            return const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            );
                          }
                          return const Text('Calculate BMI');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
