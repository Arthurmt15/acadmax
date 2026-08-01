import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import '../../domain/models.dart';
import 'active_workout_screen.dart';
import 'create_routine_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesForSelectedDayProvider);
    final selectedDay = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Treinos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Treino',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateRoutineScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(ref, selectedDay),
          Expanded(
            child: routinesAsync.when(
              data: (routines) {
                if (routines.isEmpty) {
                  return const Center(child: Text('Nenhum treino para este dia. Clique no + para criar.'));
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
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(WidgetRef ref, int selectedDay) {
    final days = [
      {'label': 'Seg', 'value': 1},
      {'label': 'Ter', 'value': 2},
      {'label': 'Qua', 'value': 3},
      {'label': 'Qui', 'value': 4},
      {'label': 'Sex', 'value': 5},
      {'label': 'Sáb', 'value': 6},
      {'label': 'Dom', 'value': 7},
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = selectedDay == day['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(day['label'] as String),
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  ref.read(selectedDayProvider.notifier).state = day['value'] as int;
                }
              },
              selectedColor: Colors.deepPurple.shade200,
            ),
          );
        },
      ),
    );
  }
}
