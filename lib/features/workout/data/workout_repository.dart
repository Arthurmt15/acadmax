import 'package:isar/isar.dart';
import '../domain/models.dart';

class WorkoutRepository {
  final Isar db;

  WorkoutRepository(this.db);

  // --- Rotinas ---

  Future<void> saveRoutine(WorkoutRoutine routine) async {
    await db.writeTxn(() async {
      await db.workoutRoutines.put(routine);
      await routine.exercises.save();
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

  // --- Sessões de Treino ---

  Future<WorkoutSession> startSession(WorkoutRoutine routine) async {
    final session = WorkoutSession()
      ..startTime = DateTime.now();
    await db.writeTxn(() async {
      await db.workoutSessions.put(session);
      session.routine.value = routine;
      await session.routine.save();
    });
    return session;
  }

  Future<void> finishSession(WorkoutSession session) async {
    session.endTime = DateTime.now();
    await db.writeTxn(() async {
      await db.workoutSessions.put(session);
    });
  }

  Future<List<WorkoutSession>> getSessionsForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return await db.workoutSessions
        .filter()
        .startTimeBetween(start, end)
        .findAll();
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    return await db.workoutSessions.where().findAll();
  }

  // --- Evolução e Séries ---

  Future<void> saveSetRecord(WorkoutSession session, Exercise exercise, int setNumber, double weight, int reps) async {
    final record = SetRecord()
      ..setNumber = setNumber
      ..weight = weight
      ..reps = reps
      ..timestamp = DateTime.now();

    await db.writeTxn(() async {
      await db.setRecords.put(record);
      record.session.value = session;
      record.exercise.value = exercise;
      await record.session.save();
      await record.exercise.save();
    });
  }

  /// Retorna o PR (Personal Record - Peso Máximo) para cada exercício, ordenado por data mais recente
  Future<Map<Exercise, double>> getPersonalRecords() async {
    final records = await db.setRecords.where().findAll();
    final prs = <int, double>{}; // exerciseId -> maxWeight
    final exercisesMap = <int, Exercise>{};

    for (final r in records) {
      await r.exercise.load();
      final ex = r.exercise.value;
      if (ex == null) continue;
      
      exercisesMap[ex.id] = ex;
      
      final currentMax = prs[ex.id] ?? 0.0;
      if (r.weight > currentMax) {
        prs[ex.id] = r.weight;
      }
    }

    // Convertendo para map de Exercise -> double
    final result = <Exercise, double>{};
    for (final entry in prs.entries) {
      if (exercisesMap.containsKey(entry.key)) {
        result[exercisesMap[entry.key]!] = entry.value;
      }
    }

    return result;
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

  Future<void> populateInitialExercises() async {
    final count = await db.exercises.filter().isCustomEqualTo(false).count();
    
    // Se tivermos menos que a lista completa, repovoar
    if (count < 85) {
      await db.writeTxn(() async {
        // Limpar os antigos não customizados para não duplicar
        await db.exercises.filter().isCustomEqualTo(false).deleteAll();
        
        final initialExercises = [
          // Peito
          Exercise()..name = 'Supino Reto'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Supino Inclinado'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Supino Declinado'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Crucifixo Reto'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Crucifixo Inclinado'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Voador (Peck Deck)'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Crossover Polia Alta'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Crossover Polia Baixa'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Flexão de Braço (Apoio)'..muscleGroup = MuscleGroup.chest,
          Exercise()..name = 'Pullover'..muscleGroup = MuscleGroup.chest,
          
          // Costas
          Exercise()..name = 'Barra Fixa'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Puxada Frontal'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Remada Curvada'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Remada Unilateral (Serrote)'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Remada Baixa'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Remada Cavalinho'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Puxada Triângulo'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Pulldown'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Levantamento Terra'..muscleGroup = MuscleGroup.back,
          Exercise()..name = 'Extensão Lombar'..muscleGroup = MuscleGroup.back,
          
          // Pernas
          Exercise()..name = 'Agachamento Livre'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Leg Press 45º'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Cadeira Extensora'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Agachamento Búlgaro'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Afundo / Passada'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Stiff'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Cadeira Flexora'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Mesa Flexora'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Elevação Pélvica'..muscleGroup = MuscleGroup.legs,
          Exercise()..name = 'Elevação de Gêmeos'..muscleGroup = MuscleGroup.legs,
          
          // Ombros
          Exercise()..name = 'Desenvolvimento com Barra'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Desenvolvimento com Halteres'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Elevação Lateral'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Elevação Frontal'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Crucifixo Invertido'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Desenvolvimento Arnold'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Remada Alta'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Face Pull'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Encolhimento'..muscleGroup = MuscleGroup.shoulders,
          Exercise()..name = 'Elevação Lateral na Polia'..muscleGroup = MuscleGroup.shoulders,
          
          // Bíceps
          Exercise()..name = 'Rosca Direta'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Alternada'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Martelo'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Scott'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Concentrada'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Inversa'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca na Polia Baixa'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca Aranha'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca no Banco Inclinado'..muscleGroup = MuscleGroup.biceps,
          Exercise()..name = 'Rosca 21'..muscleGroup = MuscleGroup.biceps,
          
          // Tríceps
          Exercise()..name = 'Tríceps Pulley'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Tríceps Corda'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Tríceps Testa'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Mergulho nas Paralelas'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Mergulho no Banco'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Tríceps Francês'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Supino Fechado'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Tríceps Coice'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Tríceps Pulley Invertido'..muscleGroup = MuscleGroup.triceps,
          Exercise()..name = 'Extensão de Tríceps Unilateral'..muscleGroup = MuscleGroup.triceps,
          
          // Abdômen (Core)
          Exercise()..name = 'Abdominal Supra'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Abdominal Infra'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Prancha Isométrica'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Abdominal Remador'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Abdominal Oblíquo'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Roda Abdominal'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Abdominal na Polia'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Russian Twist'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Prancha Lateral'..muscleGroup = MuscleGroup.core,
          Exercise()..name = 'Abdominal Canivete'..muscleGroup = MuscleGroup.core,

          // ── Peso Corporal (Bodyweight) ──────────────────────────
          Exercise()..name = 'Flexão de Braço'..muscleGroup = MuscleGroup.chest..isBodyweight = true,
          Exercise()..name = 'Flexão Diamante'..muscleGroup = MuscleGroup.triceps..isBodyweight = true,
          Exercise()..name = 'Flexão Fechada'..muscleGroup = MuscleGroup.chest..isBodyweight = true,
          Exercise()..name = 'Barra Fixa (Bodyweight)'..muscleGroup = MuscleGroup.back..isBodyweight = true,
          Exercise()..name = 'Barra Supinada (Bodyweight)'..muscleGroup = MuscleGroup.biceps..isBodyweight = true,
          Exercise()..name = 'Mergulho nas Paralelas (Bodyweight)'..muscleGroup = MuscleGroup.triceps..isBodyweight = true,
          Exercise()..name = 'Agachamento Livre (Bodyweight)'..muscleGroup = MuscleGroup.legs..isBodyweight = true,
          Exercise()..name = 'Afundo (Bodyweight)'..muscleGroup = MuscleGroup.legs..isBodyweight = true,
          Exercise()..name = 'Agachamento Búlgaro (Bodyweight)'..muscleGroup = MuscleGroup.legs..isBodyweight = true,
          Exercise()..name = 'Elevação de Quadril (Bodyweight)'..muscleGroup = MuscleGroup.legs..isBodyweight = true,
          Exercise()..name = 'Prancha (Bodyweight)'..muscleGroup = MuscleGroup.core..isBodyweight = true,
          Exercise()..name = 'Burpee'..muscleGroup = MuscleGroup.core..isBodyweight = true,
          Exercise()..name = 'Mountain Climber'..muscleGroup = MuscleGroup.core..isBodyweight = true,
          Exercise()..name = 'Superman'..muscleGroup = MuscleGroup.back..isBodyweight = true,
          Exercise()..name = 'Pike Push-Up'..muscleGroup = MuscleGroup.shoulders..isBodyweight = true,
        ];
        
        await db.exercises.putAll(initialExercises);
      });
    }
  }
}
