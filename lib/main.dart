import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/workout/presentation/screens/main_screen.dart';
import 'features/workout/presentation/providers/workout_providers.dart';
import 'features/workout/data/workout_repository.dart';
import 'core/database/database.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111111),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF3333), // Laranja Sangue / Vermelho Cru
          secondary: Colors.white,
          surface: Color(0xFF1A1A1A),
          background: Color(0xFF111111),
          error: Color(0xFFFF3333),
        ),
        textTheme: GoogleFonts.oswaldTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false, // Títulos alinhados à esquerda (Brutalismo)
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),

        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedColor: Color(0xFFFF3333),
          checkmarkColor: Colors.white,
          secondarySelectedColor: Color(0xFFFF3333),
          labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          secondaryLabelStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3333),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            side: const BorderSide(color: Color(0xFFFF3333), width: 2),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF3333),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
