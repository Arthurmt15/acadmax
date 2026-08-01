import 'package:flutter/material.dart';
import 'agenda_screen.dart';
import 'routines_screen.dart';
import 'suggestions_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    const AgendaScreen(),
    const RoutinesScreen(),
    const SuggestionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).colorScheme.primary, // Azul
          indicatorColor: Colors.white.withOpacity(0.25), // Fundo do ícone selecionado
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return IconThemeData(color: Colors.white.withOpacity(0.7));
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
            }
            return TextStyle(color: Colors.white.withOpacity(0.7));
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Agenda',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center),
              label: 'Treinos',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline),
              selectedIcon: Icon(Icons.lightbulb),
              label: 'Sugestões',
            ),
          ],
        ),
      ),
    );
  }
}
