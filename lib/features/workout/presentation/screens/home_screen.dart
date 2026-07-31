import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import '../../domain/models.dart';
import 'active_workout_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(workoutRoutinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Treinos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Treino Teste',
            onPressed: () async {
              final repo = ref.read(workoutRepositoryProvider);
              final newRoutine = WorkoutRoutine()
                ..name = 'Treino Novo (Teste)'
                ..daysOfWeek = [1, 3, 5]; // Ex: Seg, Qua, Sex
                
              await repo.saveRoutine(newRoutine);
              ref.invalidate(workoutRoutinesProvider);
            },
          )
        ],
      ),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(child: Text('Nenhum treino cadastrado. Clique no + para criar.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(routine.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Dias da semana: ${routine.daysOfWeek.join(", ")}\n(Segure para excluir)'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActiveWorkoutScreen(routineName: routine.name),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('INICIAR'),
                  ),
                  onLongPress: () async {
                    // Exclui a rotina ao segurar o toque
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
    );
  }
}
