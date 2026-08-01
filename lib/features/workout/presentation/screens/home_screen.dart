import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import 'create_routine_screen.dart';
import 'edit_routine_screen.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

// home_screen.dart agora é só a tela de gerenciamento de treinos (lista + editar + criar)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(workoutRoutinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myWorkouts, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noWorkoutsFound,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 88),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(routine.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(AppLocalizations.of(context)!.exercisesCount(routine.exercises.length)),
                  trailing: const Icon(Icons.edit, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRoutineScreen(routine: routine),
                      ),
                    );
                  },
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.deleteWorkout),
                        content: Text(AppLocalizations.of(context)!.deleteWorkoutConfirm(routine.name)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.cancel)),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red))),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final repo = ref.read(workoutRepositoryProvider);
                      await repo.deleteRoutine(routine.id);
                      ref.invalidate(workoutRoutinesProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.workoutDeletedSuccess)),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorText(err.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoutineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
