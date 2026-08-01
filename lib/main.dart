import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/workout/presentation/screens/main_screen.dart';
import 'features/workout/presentation/providers/workout_providers.dart';
import 'features/workout/data/workout_repository.dart';
import 'core/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dbService = DatabaseService();
  final isar = await dbService.openDB();

  final repo = WorkoutRepository(isar);
  await repo.populateInitialExercises();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const GymTrackerApp(),
    ),
  );
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4F46E5), // Indigo 600
          secondary: Color(0xFF10B981), // Emerald 500
          surface: Color(0xFF18181B),
          background: Color(0xFF09090B),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        chipTheme: const ChipThemeData(
          selectedColor: Color(0xFF4F46E5), // Indigo 600
          checkmarkColor: Colors.white,
          secondarySelectedColor: Color(0xFF4F46E5),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
