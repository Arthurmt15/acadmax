import 'package:flutter/material.dart';
import '../widgets/exercise_card.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  final String routineName;

  const ActiveWorkoutScreen({Key? key, required this.routineName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routineName),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('FINALIZAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExerciseCard(
            exerciseName: 'Supino Reto',
            lastWorkoutWeight: 60.0,
            lastWorkoutReps: 10,
          ),
          SizedBox(height: 16),
          ExerciseCard(
            exerciseName: 'Crucifixo com Halteres',
            lastWorkoutWeight: 18.0,
            lastWorkoutReps: 12,
          ),
        ],
      ),
    );
  }
}
