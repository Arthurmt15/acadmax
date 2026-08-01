import 'package:flutter/material.dart';
import 'agenda_screen.dart';
import 'routines_screen.dart';
import 'evolution_screen.dart';
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
    const EvolutionScreen(),
    const SuggestionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 2)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF111111),
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFFF3333),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_week, size: 28),
              label: 'AGENDA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset, size: 28),
              label: 'TREINOS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up, size: 28),
              label: 'EVOLUÇÃO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline, size: 28),
              label: 'DICAS',
            ),
          ],
        ),
      ),
    );
  }
}
