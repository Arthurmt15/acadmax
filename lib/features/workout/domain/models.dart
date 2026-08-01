import 'package:isar/isar.dart';

part 'models.g.dart';

enum MuscleGroup {
  chest, back, legs, shoulders, biceps, triceps, core
}

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  @enumerated
  late MuscleGroup muscleGroup;

  bool isCustom = false;
  bool isBodyweight = false;
}

@collection
class WorkoutRoutine {
  Id id = Isar.autoIncrement;

  late String name;
  late List<int> daysOfWeek;

  final exercises = IsarLinks<Exercise>();
}

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  late DateTime startTime;
  DateTime? endTime;

  final routine = IsarLink<WorkoutRoutine>();
  
  @Backlink(to: 'session')
  final setRecords = IsarLinks<SetRecord>();
}

@collection
class SetRecord {
  Id id = Isar.autoIncrement;

  final session = IsarLink<WorkoutSession>();
  final exercise = IsarLink<Exercise>();

  late int setNumber;
  late double weight;
  late int reps;
  late DateTime timestamp;
}
