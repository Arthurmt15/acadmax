import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDay = ref.read(selectedDayProvider);
      setState(() {
        _selectedDays.add(selectedDay);
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
      
      final routine = WorkoutRoutine()
        ..name = _nameController.text
        ..daysOfWeek = _selectedDays.toList();
      
      routine.exercises.addAll(_selectedExercises);

      await repo.saveRoutine(routine);
      ref.invalidate(workoutRoutinesProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Treino criado com sucesso!')),
        );
      }
    } else if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um dia da semana.')),
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
              title: const Text('Novo Exercício'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nome do Exercício'),
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
                    decoration: const InputDecoration(labelText: 'Grupo Muscular'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
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
                  child: const Text('Salvar'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Treino'),
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
              decoration: const InputDecoration(
                labelText: 'Nome do Treino',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Informe um nome' : null,
            ),
            const SizedBox(height: 20),
            const Text('Dias da Semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                const Text('Exercícios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton.icon(
                  onPressed: _showAddExerciseDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Criar Novo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar Exercício',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Todos'),
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

                if (filtered.isEmpty) return const Text('Nenhum exercício encontrado.');
                
                return Column(
                  children: filtered.map((ex) {
                    final isSelected = _selectedExercises.contains(ex);
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
                            _selectedExercises.remove(ex);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erro: $e'),
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
