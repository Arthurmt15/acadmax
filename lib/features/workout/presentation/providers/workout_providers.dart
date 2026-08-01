import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../domain/models.dart';
import '../../data/workout_repository.dart';

final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return WorkoutRepository(isar);
});

final workoutRoutinesProvider = FutureProvider<List<WorkoutRoutine>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  final routines = await repository.getAllRoutines();
  for (final r in routines) {
    await r.exercises.load();
  }
  return routines;
});

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllExercises();
});

// Todas as sessões (filtro por semana é feito na UI)
final workoutSessionsProvider = FutureProvider<List<WorkoutSession>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllSessions();
});
