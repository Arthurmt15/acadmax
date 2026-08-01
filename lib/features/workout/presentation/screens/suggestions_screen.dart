import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sugestões', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Para Homens'),
              Tab(text: 'Para Mulheres'),
            ],
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildMenSuggestions(context, ref),
            _buildWomenSuggestions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMenSuggestions(BuildContext context, WidgetRef ref) {
    final suggestions = [
      _Suggestion(
        name: 'Hipertrofia - Peito e Tríceps',
        description: 'Foco em volume para a parte superior frontal.',
        exercises: [
          _SuggestedExercise('Supino Reto', MuscleGroup.chest),
          _SuggestedExercise('Supino Inclinado', MuscleGroup.chest),
          _SuggestedExercise('Crucifixo', MuscleGroup.chest),
          _SuggestedExercise('Tríceps Polia', MuscleGroup.triceps),
          _SuggestedExercise('Tríceps Testa', MuscleGroup.triceps),
        ],
      ),
      _Suggestion(
        name: 'Hipertrofia - Costas e Bíceps',
        description: 'Desenvolvimento focado na largura e espessura das costas.',
        exercises: [
          _SuggestedExercise('Puxada Frontal', MuscleGroup.back),
          _SuggestedExercise('Remada Curvada', MuscleGroup.back),
          _SuggestedExercise('Rosca Direta', MuscleGroup.biceps),
          _SuggestedExercise('Rosca Martelo', MuscleGroup.biceps),
        ],
      ),
    ];
    return _buildSuggestionList(context, ref, suggestions);
  }

  Widget _buildWomenSuggestions(BuildContext context, WidgetRef ref) {
    final suggestions = [
      _Suggestion(
        name: 'Foco Glúteos e Quadríceps',
        description: 'Treino inferior completo com ênfase em glúteos.',
        exercises: [
          _SuggestedExercise('Agachamento Livre', MuscleGroup.legs),
          _SuggestedExercise('Elevação Pélvica', MuscleGroup.legs),
          _SuggestedExercise('Leg Press', MuscleGroup.legs),
          _SuggestedExercise('Cadeira Extensora', MuscleGroup.legs),
          _SuggestedExercise('Cadeira Abdutora', MuscleGroup.legs),
        ],
      ),
      _Suggestion(
        name: 'Posterior e Superiores',
        description: 'Treino de membros superiores com foco no core.',
        exercises: [
          _SuggestedExercise('Cadeira Flexora', MuscleGroup.legs),
          _SuggestedExercise('Stiff', MuscleGroup.legs),
          _SuggestedExercise('Puxada Frontal', MuscleGroup.back),
          _SuggestedExercise('Elevação Lateral', MuscleGroup.shoulders),
          _SuggestedExercise('Abdominal Supra', MuscleGroup.core),
        ],
      ),
    ];
    return _buildSuggestionList(context, ref, suggestions);
  }

  Widget _buildSuggestionList(BuildContext context, WidgetRef ref, List<_Suggestion> suggestions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final sug = suggestions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sug.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 8),
                Text(sug.description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                const Text('Exercícios:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...sug.exercises.map((e) => Text('• ${e.name} (${e.muscleGroup.name.toUpperCase()})')).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('ADICIONAR À MINHA ROTINA'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _importRoutine(context, ref, sug),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _importRoutine(BuildContext context, WidgetRef ref, _Suggestion sug) async {
    final repo = ref.read(workoutRepositoryProvider);
    
    final List<Exercise> resolvedExercises = [];
    final allDbExercises = await repo.getAllExercises();
    
    for (final ex in sug.exercises) {
      final existingMatches = allDbExercises.where((dbEx) => dbEx.name.toLowerCase() == ex.name.toLowerCase()).toList();
      if (existingMatches.isNotEmpty) {
        resolvedExercises.add(existingMatches.first);
      } else {
        final newEx = Exercise()
          ..name = ex.name
          ..muscleGroup = ex.muscleGroup
          ..isCustom = false;
        await repo.saveExercise(newEx);
        resolvedExercises.add(newEx);
      }
    }

    final routine = WorkoutRoutine()
      ..name = sug.name
      ..daysOfWeek = []; // Imported routine starts without specific days
      
    routine.exercises.addAll(resolvedExercises);

    await repo.saveRoutine(routine);
    ref.invalidate(workoutRoutinesProvider);
    ref.invalidate(exercisesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino importado! Vá na aba Treinos para configurá-lo.')),
      );
    }
  }
}

class _Suggestion {
  final String name;
  final String description;
  final List<_SuggestedExercise> exercises;
  _Suggestion({required this.name, required this.description, required this.exercises});
}

class _SuggestedExercise {
  final String name;
  final MuscleGroup muscleGroup;
  _SuggestedExercise(this.name, this.muscleGroup);
}
