import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.suggestionsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: [
              Tab(text: loc.forMen),
              Tab(text: loc.forWomen),
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
    final loc = AppLocalizations.of(context)!;
    final suggestions = [
      _Suggestion(
        name: loc.suggestHypertrophyChest,
        description: loc.suggestHypertrophyChestDesc,
        exercises: [
          _SuggestedExercise(loc.exBenchPress, 'Supino Reto', MuscleGroup.chest),
          _SuggestedExercise(loc.exInclineBenchPress, 'Supino Inclinado', MuscleGroup.chest),
          _SuggestedExercise(loc.exFly, 'Crucifixo', MuscleGroup.chest),
          _SuggestedExercise(loc.exTricepsPushdown, 'Tríceps Polia', MuscleGroup.triceps),
          _SuggestedExercise(loc.exSkullCrusher, 'Tríceps Testa', MuscleGroup.triceps),
        ],
      ),
      _Suggestion(
        name: loc.suggestHypertrophyBack,
        description: loc.suggestHypertrophyBackDesc,
        exercises: [
          _SuggestedExercise(loc.exLatPulldown, 'Puxada Frontal', MuscleGroup.back),
          _SuggestedExercise(loc.exBentOverRow, 'Remada Curvada', MuscleGroup.back),
          _SuggestedExercise(loc.exBicepCurl, 'Rosca Direta', MuscleGroup.biceps),
          _SuggestedExercise(loc.exHammerCurl, 'Rosca Martelo', MuscleGroup.biceps),
        ],
      ),
    ];
    return _buildSuggestionList(context, ref, suggestions, loc);
  }

  Widget _buildWomenSuggestions(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final suggestions = [
      _Suggestion(
        name: loc.suggestGlutesQuads,
        description: loc.suggestGlutesQuadsDesc,
        exercises: [
          _SuggestedExercise(loc.exSquat, 'Agachamento Livre', MuscleGroup.legs),
          _SuggestedExercise(loc.exHipThrust, 'Elevação Pélvica', MuscleGroup.legs),
          _SuggestedExercise(loc.exLegPress, 'Leg Press', MuscleGroup.legs),
          _SuggestedExercise(loc.exLegExtension, 'Cadeira Extensora', MuscleGroup.legs),
          _SuggestedExercise(loc.exLegAbduction, 'Cadeira Abdutora', MuscleGroup.legs),
        ],
      ),
      _Suggestion(
        name: loc.suggestHamstringsUpper,
        description: loc.suggestHamstringsUpperDesc,
        exercises: [
          _SuggestedExercise(loc.exLegCurl, 'Cadeira Flexora', MuscleGroup.legs),
          _SuggestedExercise(loc.exStiff, 'Stiff', MuscleGroup.legs),
          _SuggestedExercise(loc.exLatPulldown, 'Puxada Frontal', MuscleGroup.back),
          _SuggestedExercise(loc.exLateralRaise, 'Elevação Lateral', MuscleGroup.shoulders),
          _SuggestedExercise(loc.exCrunch, 'Abdominal Supra', MuscleGroup.core),
        ],
      ),
    ];
    return _buildSuggestionList(context, ref, suggestions, loc);
  }

  Widget _buildSuggestionList(BuildContext context, WidgetRef ref, List<_Suggestion> suggestions, AppLocalizations loc) {
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
                Text(loc.exercisesLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                ...sug.exercises.map((e) => Text('• ${e.displayName} (${e.muscleGroup.name.toUpperCase()})')).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(loc.addToMyRoutineUpper),
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
      final existingMatches = allDbExercises.where((dbEx) => dbEx.name.toLowerCase() == ex.dbName.toLowerCase()).toList();
      if (existingMatches.isNotEmpty) {
        resolvedExercises.add(existingMatches.first);
      } else {
        final newEx = Exercise()
          ..name = ex.dbName
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
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.routineImported)),
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
  final String displayName;
  final String dbName;
  final MuscleGroup muscleGroup;
  _SuggestedExercise(this.displayName, this.dbName, this.muscleGroup);
}
