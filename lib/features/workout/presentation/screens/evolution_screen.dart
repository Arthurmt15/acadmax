import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../providers/workout_providers.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';

final personalRecordsProvider = FutureProvider<Map<Exercise, double>>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getPersonalRecords();
});

class EvolutionScreen extends ConsumerWidget {
  const EvolutionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(personalRecordsProvider);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.evolutionUpper, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: ColoredBox(color: Colors.white, child: SizedBox(height: 2, width: double.infinity)),
        ),
      ),
      body: SafeArea(
        child: prsAsync.when(
          data: (prs) {
            if (prs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.noRecordsUpper, style: TextStyle(color: Colors.grey.shade600, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.startLiftingUpper,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            final entries = prs.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)); // Sort by heavyest weights

            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final ex = entries[index].key;
                final maxWeight = entries[index].value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 80,
                          color: primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ex.name.toUpperCase(),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ex.muscleGroup.name.toUpperCase(),
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            border: const Border(left: BorderSide(color: Colors.white, width: 2)),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.maxLoadUpper,
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    maxWeight == maxWeight.truncateToDouble() 
                                        ? maxWeight.toInt().toString() 
                                        : maxWeight.toString(),
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.kg,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text(AppLocalizations.of(context)!.errorUpper(e.toString()))),
        ),
      ),
    );
  }
}
