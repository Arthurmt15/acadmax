import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

class EditRoutineScreen extends ConsumerStatefulWidget {
  final WorkoutRoutine routine;
  const EditRoutineScreen({Key? key, required this.routine}) : super(key: key);

  @override
  ConsumerState<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends ConsumerState<EditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final Set<int> _selectedDays = {};
  final Set<Exercise> _selectedExercises = {};
  bool _initialized = false;

  String _searchQuery = '';
  MuscleGroup? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.routine.name);
    _selectedDays.addAll(widget.routine.daysOfWeek);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.routine.exercises.load();
      setState(() {
        _selectedExercises.addAll(widget.routine.exercises);
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate() && _selectedDays.isNotEmpty) {
      final repo = ref.read(workoutRepositoryProvider);
      
      final updatedRoutine = widget.routine
        ..name = _nameController.text
        ..daysOfWeek = _selectedDays.toList();
      
      updatedRoutine.exercises.clear();
      updatedRoutine.exercises.addAll(_selectedExercises);

      await repo.saveRoutine(updatedRoutine);
      ref.invalidate(workoutRoutinesProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.routineUpdatedSuccess)),
        );
      }
    } else if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectOneDayAtLeast)),
      );
    }
  }

  Future<void> _showAddExerciseDialog() async {
    final nameCtrl = TextEditingController();
    MuscleGroup selectedGroup = MuscleGroup.chest;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.newExercise),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.exerciseName),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MuscleGroup>(
                    value: selectedGroup,
                    items: MuscleGroup.values.map((mg) {
                      return DropdownMenuItem(
                        value: mg,
                        child: Text(mg.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() => selectedGroup = val);
                      }
                    },
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.muscleGroup),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.isNotEmpty) {
                      final ex = Exercise()
                        ..name = nameCtrl.text
                        ..muscleGroup = selectedGroup
                        ..isCustom = true;
                      
                      final repo = ref.read(workoutRepositoryProvider);
                      await repo.saveExercise(ex);
                      ref.invalidate(exercisesProvider);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editRoutine),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRoutine,
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.routineName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.required : null,
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.daysOfWeek, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildDayChip('Seg', 1),
                _buildDayChip('Ter', 2),
                _buildDayChip('Qua', 3),
                _buildDayChip('Qui', 4),
                _buildDayChip('Sex', 5),
                _buildDayChip('Sáb', 6),
                _buildDayChip('Dom', 7),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(AppLocalizations.of(context)!.exercises, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextButton.icon(
                  onPressed: _showAddExerciseDialog,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.createNew),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchExercise,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: Text(AppLocalizations.of(context)!.all),
                  selected: _selectedFilter == null,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  onSelected: (_) => setState(() => _selectedFilter = null),
                ),
                ...MuscleGroup.values.map((mg) {
                  return FilterChip(
                    label: Text(mg.name),
                    selected: _selectedFilter == mg,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    onSelected: (_) => setState(() => _selectedFilter = mg),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 16),
            exercisesAsync.when(
              data: (exercises) {
                var filtered = exercises.where((ex) {
                  final matchesQuery = ex.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  final matchesFilter = _selectedFilter == null || ex.muscleGroup == _selectedFilter;
                  return matchesQuery && matchesFilter;
                }).toList();

                if (filtered.isEmpty) return Text(AppLocalizations.of(context)!.noExercisesFound);
                
                return Column(
                  children: filtered.map((ex) {
                    final isSelected = _selectedExercises.any((e) => e.id == ex.id);
                    return CheckboxListTile(
                      title: Text(ex.name),
                      subtitle: Text(ex.muscleGroup.name),
                      value: isSelected,
                      activeColor: Theme.of(context).colorScheme.primary,
                      checkColor: Colors.black,
                      onChanged: (bool? val) {
                        setState(() {
                          if (val == true) {
                            _selectedExercises.add(ex);
                          } else {
                            _selectedExercises.removeWhere((e) => e.id == ex.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(AppLocalizations.of(context)!.errorText(e.toString())),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildDayChip(String label, int day) {
    final isSelected = _selectedDays.contains(day);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Theme.of(context).colorScheme.primary,
      onSelected: (val) {
        setState(() {
          if (val) _selectedDays.add(day);
          else _selectedDays.remove(day);
        });
      },
    );
  }
}
