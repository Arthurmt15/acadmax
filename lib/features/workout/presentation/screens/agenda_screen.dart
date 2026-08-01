import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import 'active_workout_screen.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesForSelectedDayProvider);
    final selectedDay = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildDaySelector(context, ref, selectedDay),
          Expanded(
            child: routinesAsync.when(
              data: (routines) {
                if (routines.isEmpty) {
                  return const Center(
                    child: Text(
                      'Dia livre de treinos!\nVá na aba Treinos para criar ou editar algo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    final routine = routines[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(routine.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${routine.exercises.length} exercícios'),
                        ),
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
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('INICIAR', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
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

  Widget _buildDaySelector(BuildContext context, WidgetRef ref, int selectedDay) {
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: days.map((day) {
            final isSelected = selectedDay == day['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  day['label'] as String,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    ref.read(selectedDayProvider.notifier).state = day['value'] as int;
                  }
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: const Color(0xFF27272A),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
