import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/workout/presentation/screens/home_screen.dart';
import 'features/workout/presentation/providers/workout_providers.dart';
import 'core/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dbService = DatabaseService();
  final isar = await dbService.openDB();

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
