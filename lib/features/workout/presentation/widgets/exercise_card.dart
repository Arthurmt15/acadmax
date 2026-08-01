import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'set_input_row.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';

class ExerciseCard extends ConsumerStatefulWidget {
  final Exercise exercise;
  final WorkoutSession session;
  final bool initialBodyweight;
  final double? lastWorkoutWeight;
  final int? lastWorkoutReps;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.session,
    this.initialBodyweight = false,
    this.lastWorkoutWeight,
    this.lastWorkoutReps,
  }) : super(key: key);

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard> {
  List<Map<String, dynamic>> currentSets = [
    {'weight': null, 'reps': null, 'completed': false}
  ];
  late bool _isBodyweight;

  @override
  void initState() {
    super.initState();
    _isBodyweight = widget.initialBodyweight;
  }

  void addSet() {
    setState(() {
      currentSets.add({'weight': null, 'reps': null, 'completed': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    
    final completedCount = currentSets.where((s) => s['completed'] == true).length;
    final totalCount = currentSets.length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PROGRESS: $completedCount / $totalCount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: completedCount == totalCount && totalCount > 0 ? primary : Colors.grey.shade400,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isBodyweight = !_isBodyweight),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isBodyweight ? Colors.white : Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      _isBodyweight ? 'BODYWT' : 'WEIGHT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isBodyweight ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chip de histórico
          if (widget.lastWorkoutWeight != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
              ),
              child: Text(
                'LAST: ${widget.lastWorkoutWeight}KG x ${widget.lastWorkoutReps}',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],

          // Séries
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Headers
                Row(
                  children: [
                    const SizedBox(width: 48), // Spacer para o index
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isBodyweight ? 'TYPE' : 'KG',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'REPS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(width: 56), // Spacer para o botão OK
                  ],
                ),
                const SizedBox(height: 12),

                ...List.generate(currentSets.length, (index) {
                  return SetInputRow(
                    setNumber: index + 1,
                    isBodyweight: _isBodyweight,
                    onCompleted: (weight, reps) async {
                      setState(() {
                        currentSets[index]['weight'] = weight;
                        currentSets[index]['reps'] = reps;
                        currentSets[index]['completed'] = true;
                      });
                      
                      final repo = ref.read(workoutRepositoryProvider);
                      await repo.saveSetRecord(
                        widget.session,
                        widget.exercise,
                        index + 1,
                        weight ?? 0.0,
                        reps
                      );
                    },
                  );
                }),

                const SizedBox(height: 16),

                // Add Set Button
                GestureDetector(
                  onTap: addSet,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+ ADD SET',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
