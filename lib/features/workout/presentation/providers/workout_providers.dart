import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';

// Placeholder provider para simular dados do banco
final workoutRoutinesProvider = FutureProvider<List<WorkoutRoutine>>((ref) async {
  // Simulando uma busca no banco Isar
  await Future.delayed(const Duration(milliseconds: 500));
  
  final routine1 = WorkoutRoutine()
    ..name = 'Treino A - Peito e Tríceps'
    ..daysOfWeek = [1, 4]; // Segunda e Quinta

  final routine2 = WorkoutRoutine()
    ..name = 'Treino B - Costas e Bíceps'
    ..daysOfWeek = [2, 5]; // Terça e Sexta
    
  return [routine1, routine2];
});
