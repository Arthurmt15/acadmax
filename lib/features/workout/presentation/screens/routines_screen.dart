import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import 'create_routine_screen.dart';
import 'edit_routine_screen.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(workoutRoutinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Treinos', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum treino cadastrado.\nClique no + para criar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 88.0),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(routine.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text('Dias da semana: ${routine.daysOfWeek.join(", ")}\n${routine.exercises.length} exercícios'),
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
                    final repo = ref.read(workoutRepositoryProvider);
                    await repo.deleteRoutine(routine.id);
                    ref.invalidate(workoutRoutinesProvider);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Treino excluído com sucesso!')),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
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
