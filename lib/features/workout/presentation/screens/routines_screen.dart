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
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text('ROUTINES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.white, height: 2),
        ),
      ),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Text(
                'NO ROUTINES.\nCREATE ONE.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 88.0),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
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
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('ROUTINE DELETED', style: TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: primary,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 90,
                          color: primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                routine.name.toUpperCase(),
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'DAYS: ${routine.daysOfWeek.join(", ")}',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${routine.exercises.length} EXERCISES',
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 90,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            border: Border(left: BorderSide(color: Colors.white, width: 2)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.edit, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('ERROR: $err')),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: FloatingActionButton(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateRoutineScreen()),
            );
          },
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}
