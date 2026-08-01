import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_providers.dart';
import 'active_workout_screen.dart';
import 'package:gym_tracker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
final weekOffsetProvider = StateProvider<int>((ref) => 0);

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  late final PageController _pageController;
  static const int _centerPage = 5000;
  double _dragStartX = 0;

  void _goToPreviousWeek() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextWeek() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _centerPage, viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getGreeting(AppLocalizations loc) {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return loc.morningGrind;
    if (hour >= 12 && hour < 18) return loc.afternoonShift;
    return loc.nightOperation;
  }

  String _weekdayShort(DateTime day, String locale) {
    return DateFormat.E(locale).format(day).toUpperCase();
  }

  String _monthShort(DateTime day, String locale) {
    return DateFormat.MMM(locale).format(day).toUpperCase();
  }

  DateTime _getMondayOf(int weekOffset) {
    final today = DateTime.now();
    final midnight = DateTime(today.year, today.month, today.day);
    final fromMonday = midnight.weekday - 1;
    return midnight
        .subtract(Duration(days: fromMonday))
        .add(Duration(days: weekOffset * 7));
  }

  String _weekLabel(int offset, DateTime monday, AppLocalizations loc, String localeName) {
    final sunday = monday.add(const Duration(days: 6));
    if (offset == 0) return loc.currentWeek;
    if (offset == -1) return loc.previousWeek;
    if (offset == 1) return loc.nextWeek;
    if (monday.month == sunday.month) {
      return '${monday.day}-${sunday.day} ${_monthShort(monday, localeName)}';
    }
    return '${monday.day} ${_monthShort(monday, localeName)} - ${sunday.day} ${_monthShort(sunday, localeName)}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final routinesAsync = ref.watch(workoutRoutinesProvider);
    final sessionsAsync = ref.watch(workoutSessionsProvider);
    final currentOffset = ref.watch(weekOffsetProvider);
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    
    // Brutalism Colors
    final primary = Theme.of(context).colorScheme.primary;
    const darkBg = Color(0xFF111111);
    const lightBorder = Colors.white;

    final workedOutDates = sessionsAsync.whenData((sessions) {
      return sessions.map((s) {
        final d = s.startTime;
        return DateTime(d.year, d.month, d.day);
      }).toSet();
    }).valueOrNull ?? <DateTime>{};

    final currentMonday = _getMondayOf(currentOffset);
    final trainedThisWeek = List.generate(7, (i) => currentMonday.add(Duration(days: i)))
        .where((d) => workedOutDates.contains(d))
        .length;

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            _dragStartX = details.globalPosition.dx;
          },
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity > 200) {
              _goToPreviousWeek();
            } else if (velocity < -200) {
              _goToNextWeek();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── HEADER ───────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: lightBorder, width: 2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(loc),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loc.overcome,
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primary,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$trainedThisWeek',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            loc.sessions,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ─── CARROSSEL DE SEMANAS ─────────────────────────────────
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: lightBorder, width: 2)),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (page) {
                    ref.read(weekOffsetProvider.notifier).state = page - _centerPage;
                  },
                  itemBuilder: (context, page) {
                    final offset = page - _centerPage;
                    final monday = _getMondayOf(offset);
                    final label = _weekLabel(offset, monday, loc, localeName);
                    final isCurrentWeek = offset == 0;

                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _goToPreviousWeek,
                                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                              ),
                              Text(
                                label.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentWeek ? primary : Colors.grey.shade400,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: _goToNextWeek,
                                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (i) {
                              final day = monday.add(Duration(days: i));
                              final isToday = day == todayMidnight;
                              final didWorkout = workedOutDates.contains(day);
                              final isPast = day.isBefore(todayMidnight);

                              Color boxColor;
                              Color textColor;
                              Color borderColor;

                              if (didWorkout) {
                                boxColor = Colors.white;
                                textColor = Colors.black;
                                borderColor = Colors.white;
                              } else if (isToday) {
                                boxColor = primary;
                                textColor = Colors.white;
                                borderColor = primary;
                              } else if (isPast) {
                                boxColor = Colors.transparent;
                                textColor = Colors.grey.shade600;
                                borderColor = Colors.grey.shade800;
                              } else {
                                boxColor = Colors.transparent;
                                textColor = Colors.white;
                                borderColor = Colors.white;
                              }

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _weekdayShort(day, localeName),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isToday ? primary : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: boxColor,
                                      border: Border.all(color: borderColor, width: 2),
                                    ),
                                    child: Center(
                                      child: didWorkout
                                          ? const Icon(Icons.check, color: Colors.black, size: 20)
                                          : Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ─── SEÇÃO DE TREINOS ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  loc.routinesLabel,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),

              // ─── LISTA DE TREINOS ─────────────────────────────────────
              Expanded(
                child: routinesAsync.when(
                  data: (routines) {
                    if (routines.isEmpty) {
                      return Center(
                        child: Text(
                          loc.noRoutinesBuildOne,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: routines.length,
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        final exCount = routine.exercises.length;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () async {
                              final repo = ref.read(workoutRepositoryProvider);
                              final session = await repo.startSession(routine);
                              ref.invalidate(workoutSessionsProvider);
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActiveWorkoutScreen(
                                      routine: routine,
                                      session: session,
                                    ),
                                  ),
                                ).then((_) => ref.invalidate(workoutSessionsProvider));
                              }
                            },
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
                                    color: primary, // Barra lateral brutalista
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          routine.name.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          loc.exercisesCountUpper(exCount),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      border: Border(left: BorderSide(color: Colors.white, width: 2)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      loc.startWorkout,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: Text(loc.loadingUpper, style: const TextStyle(color: Colors.white, fontSize: 18))),
                  error: (e, _) => Center(child: Text(loc.errorUpper(e.toString()))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
