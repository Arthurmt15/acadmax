import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../domain/models.dart';
import '../../data/workout_repository.dart';

final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return WorkoutRepository(isar);
});

final selectedDayProvider = StateProvider<int>((ref) => DateTime.now().weekday);

final workoutRoutinesProvider = FutureProvider<List<WorkoutRoutine>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllRoutines();
});

final routinesForSelectedDayProvider = FutureProvider<List<WorkoutRoutine>>((ref) async {
  final routines = await ref.watch(workoutRoutinesProvider.future);
  final selectedDay = ref.watch(selectedDayProvider);
  
  return routines.where((r) => r.daysOfWeek.contains(selectedDay)).toList();
});

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllExercises();
});

