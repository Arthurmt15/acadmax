import 'package:isar/isar.dart';
import '../domain/models.dart';

class WorkoutRepository {
  final Isar db;

  WorkoutRepository(this.db);

  // --- Rotinas ---

  Future<void> saveRoutine(WorkoutRoutine routine) async {
    await db.writeTxn(() async {
      await db.workoutRoutines.put(routine);
    });
  }

  Future<List<WorkoutRoutine>> getAllRoutines() async {
    return await db.workoutRoutines.where().findAll();
  }

  Future<void> deleteRoutine(int id) async {
    await db.writeTxn(() async {
      await db.workoutRoutines.delete(id);
    });
  }

  // --- Exercícios ---

  Future<void> saveExercise(Exercise exercise) async {
    await db.writeTxn(() async {
      await db.exercises.put(exercise);
    });
  }

  Future<List<Exercise>> getAllExercises() async {
    return await db.exercises.where().findAll();
  }
}
