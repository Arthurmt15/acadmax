import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  const CreateRoutineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final Set<int> _selectedDays = {};
  final Set<Exercise> _selectedExercises = {};

  String _searchQuery = '';
  MuscleGroup? _selectedFilter;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(workoutRepositoryProvider);
      
      final routine = WorkoutRoutine()
        ..name = _nameController.text
        ..daysOfWeek = _selectedDays.toList();
      
      routine.exercises.addAll(_selectedExercises);

      await repo.saveRoutine(routine);
      ref.invalidate(workoutRoutinesProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.routineCreatedUpper, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        );
      }
    }
  }

  Future<void> _showAddExerciseDialog() async {
    final nameCtrl = TextEditingController();
    MuscleGroup selectedGroup = MuscleGroup.chest;
    final primary = Theme.of(context).colorScheme.primary;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF111111),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              title: Text(AppLocalizations.of(context)!.newExerciseUpper, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exerciseNameUpper,
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<MuscleGroup>(
                    value: selectedGroup,
                    dropdownColor: const Color(0xFF1A1A1A),
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.muscleGroupUpper,
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancelUpper, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    side: BorderSide.none,
                  ),
                  child: Text(AppLocalizations.of(context)!.saveUpper, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
    final exercisesAsync = ref.watch(exercisesProvider);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newRoutineUpper, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.white, height: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 32),
            onPressed: _saveRoutine,
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.routineNameUpper,
                  labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.bold),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: primary, width: 3),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                ),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.requiredUpper : null,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.exercisesUpper, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
                  TextButton.icon(
                    onPressed: _showAddExerciseDialog,
                    icon: Icon(Icons.add, color: primary),
                    label: Text(AppLocalizations.of(context)!.newUpper, style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.searchUpper,
                  labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  filled: true,
                  fillColor: Color(0xFF1A1A1A),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: Text(AppLocalizations.of(context)!.allUpper),
                    selected: _selectedFilter == null,
                    selectedColor: primary,
                    onSelected: (_) => setState(() => _selectedFilter = null),
                  ),
                  ...MuscleGroup.values.map((mg) {
                    return FilterChip(
                      label: Text(mg.name.toUpperCase()),
                      selected: _selectedFilter == mg,
                      selectedColor: primary,
                      onSelected: (_) => setState(() => _selectedFilter = mg),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 24),
              exercisesAsync.when(
                data: (exercises) {
                  var filtered = exercises.where((ex) {
                    final matchesQuery = ex.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    final matchesFilter = _selectedFilter == null || ex.muscleGroup == _selectedFilter;
                    return matchesQuery && matchesFilter;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(AppLocalizations.of(context)!.notFoundUpper, style: TextStyle(color: Colors.grey.shade600, fontSize: 24, fontWeight: FontWeight.bold)),
                    );
                  }
                  
                  return Column(
                    children: filtered.map((ex) {
                      final isSelected = _selectedExercises.contains(ex);
                      return CheckboxListTile(
                        title: Text(ex.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(ex.muscleGroup.name.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                        value: isSelected,
                        activeColor: primary,
                        checkColor: Colors.white,
                        tileColor: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
                        shape: const Border(bottom: BorderSide(color: Color(0xFF333333), width: 1)),
                        onChanged: (bool? val) {
                          setState(() {
                            if (val == true) {
                              _selectedExercises.add(ex);
                            } else {
                              _selectedExercises.remove(ex);
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(AppLocalizations.of(context)!.errorUpper(e.toString())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
