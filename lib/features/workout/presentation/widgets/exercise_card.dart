import 'package:flutter/material.dart';
import 'set_input_row.dart';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final double? lastWorkoutWeight;
  final int? lastWorkoutReps;

  const ExerciseCard({
    Key? key,
    required this.exerciseName,
    this.lastWorkoutWeight,
    this.lastWorkoutReps,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<Map<String, dynamic>> currentSets = [
    {'weight': null, 'reps': null, 'completed': false}
  ];

  void addSet() {
    setState(() {
      currentSets.add({'weight': null, 'reps': null, 'completed': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.exerciseName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.lastWorkoutWeight != null)
                  Tooltip(
                    message: 'Último treino',
                    child: Chip(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      label: Text(
                        'Último: ${widget.lastWorkoutWeight}kg x ${widget.lastWorkoutReps}',
                        style: const TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            const Row(
              children: [
                SizedBox(width: 40, child: Text('SÉRIE', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Center(child: Text('KG', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('REPS', style: TextStyle(fontWeight: FontWeight.bold)))),
                SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(currentSets.length, (index) {
              return SetInputRow(
                setNumber: index + 1,
                onCompleted: (weight, reps) {
                  setState(() {
                    currentSets[index]['completed'] = true;
                  });
                },
              );
            }),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: addSet,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Série'),
            )
          ],
        ),
      ),
    );
  }
}
