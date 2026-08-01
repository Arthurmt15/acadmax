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
    
    // Se tivermos menos que a lista gigante, repovoar
    if (count < 70) {
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
        ];
        
        await db.exercises.putAll(initialExercises);
      });
    }
  }
}
