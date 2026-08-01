import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/exercise_card.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutRoutine routine;
  final WorkoutSession session;

  const ActiveWorkoutScreen({
    Key? key,
    required this.routine,
    required this.session,
  }) : super(key: key);

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  List<Exercise> _exercises = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await widget.routine.exercises.load();
    if (mounted) {
      setState(() {
        _exercises = widget.routine.exercises.toList();
        _loading = false;
      });
    }
  }

  Future<void> _finishWorkout() async {
    final repo = ref.read(workoutRepositoryProvider);
    await repo.finishSession(widget.session);
    ref.invalidate(workoutSessionsProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: Text(
          widget.routine.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.white, height: 2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _finishWorkout,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.finishUpper,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)!.emptyUpper, style: TextStyle(color: Colors.grey.shade600, fontSize: 48, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.addExercisesToContinueUpper,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: ExerciseCard(
                          exercise: exercise,
                          session: widget.session,
                          initialBodyweight: exercise.isBodyweight,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
