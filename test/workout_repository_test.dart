import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:gym_tracker/features/workout/domain/models.dart';
import 'package:gym_tracker/features/workout/data/workout_repository.dart';
import 'dart:io';

void main() {
  late Isar isar;
  late WorkoutRepository repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    final dir = Directory.systemTemp.createTempSync('isar_test_');
    isar = await Isar.open(
      [ExerciseSchema, WorkoutRoutineSchema, WorkoutSessionSchema, SetRecordSchema],
      directory: dir.path,
    );
    repository = WorkoutRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('Deve incluir (salvar) e resgatar uma rotina de treino normalmente', () async {
    final routine = WorkoutRoutine()
      ..name = 'Treino Teste'
      ..daysOfWeek = [1, 2];

    await repository.saveRoutine(routine);

    final routines = await repository.getAllRoutines();
    
    expect(routines.length, 1);
    expect(routines.first.name, 'Treino Teste');
  });

  test('Deve excluir uma rotina de treino normalmente', () async {
    final routine = WorkoutRoutine()
      ..name = 'Treino Para Excluir'
      ..daysOfWeek = [3];

    await repository.saveRoutine(routine);
    
    var routines = await repository.getAllRoutines();
    expect(routines.length, 1);

    final idToDelete = routines.first.id;
    await repository.deleteRoutine(idToDelete);

    routines = await repository.getAllRoutines();
    expect(routines.isEmpty, true);
  });
}
