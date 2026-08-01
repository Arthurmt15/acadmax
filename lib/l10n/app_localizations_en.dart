// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gym Tracker';

  @override
  String get myWorkouts => 'My Workouts';

  @override
  String get noWorkoutsFound => 'No workouts found.\nTap + to create one.';

  @override
  String exercisesCount(int count) {
    return '$count exercises';
  }

  @override
  String get deleteWorkout => 'Delete Workout';

  @override
  String deleteWorkoutConfirm(String name) {
    return 'Do you want to delete \"$name\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get workoutDeletedSuccess => 'Workout deleted successfully!';

  @override
  String errorText(String error) {
    return 'Error: $error';
  }

  @override
  String get morningGrind => 'MORNING GRIND';

  @override
  String get afternoonShift => 'AFTERNOON SHIFT';

  @override
  String get nightOperation => 'NIGHT OPERATION';

  @override
  String get currentWeek => 'CURRENT WEEK';

  @override
  String get previousWeek => 'PREVIOUS WEEK';

  @override
  String get nextWeek => 'NEXT WEEK';

  @override
  String get overcome => 'OVERCOME.';

  @override
  String get sessions => 'SESSIONS';

  @override
  String get routinesLabel => 'ROUTINES';

  @override
  String get noRoutinesBuildOne => 'NO ROUTINES FOUND.\nBUILD ONE.';

  @override
  String exercisesCountUpper(int count) {
    return '$count EXERCISES';
  }

  @override
  String get startWorkout => 'START';

  @override
  String get loadingUpper => 'LOADING...';

  @override
  String errorUpper(String error) {
    return 'ERROR: $error';
  }

  @override
  String get noRoutinesCreateOne => 'NO ROUTINES.\nCREATE ONE.';

  @override
  String get routineDeletedUpper => 'ROUTINE DELETED';

  @override
  String daysLabelUpper(String days) {
    return 'DAYS: $days';
  }

  @override
  String get routineCreatedUpper => 'ROUTINE CREATED';

  @override
  String get newExerciseUpper => 'NEW EXERCISE';

  @override
  String get exerciseNameUpper => 'EXERCISE NAME';

  @override
  String get muscleGroupUpper => 'MUSCLE GROUP';

  @override
  String get cancelUpper => 'CANCEL';

  @override
  String get saveUpper => 'SAVE';

  @override
  String get newRoutineUpper => 'NEW ROUTINE';

  @override
  String get routineNameUpper => 'ROUTINE NAME';

  @override
  String get requiredUpper => 'REQUIRED';

  @override
  String get exercisesUpper => 'EXERCISES';

  @override
  String get newUpper => 'NEW';

  @override
  String get searchUpper => 'SEARCH';

  @override
  String get allUpper => 'ALL';

  @override
  String get notFoundUpper => 'NOT FOUND.';

  @override
  String get routineUpdatedSuccess => 'Routine updated successfully!';

  @override
  String get selectOneDayAtLeast => 'Select at least one day of the week.';

  @override
  String get newExercise => 'New Exercise';

  @override
  String get exerciseName => 'Exercise Name';

  @override
  String get muscleGroup => 'Muscle Group';

  @override
  String get editRoutine => 'Edit Routine';

  @override
  String get routineName => 'Routine Name';

  @override
  String get required => 'Required';

  @override
  String get daysOfWeek => 'Days of the Week';

  @override
  String get exercises => 'Exercises';

  @override
  String get createNew => 'Create New';

  @override
  String get searchExercise => 'Search Exercise';

  @override
  String get all => 'All';

  @override
  String get noExercisesFound => 'No exercises found.';

  @override
  String get finishUpper => 'FINISH';

  @override
  String get emptyUpper => 'EMPTY.';

  @override
  String get addExercisesToContinueUpper => 'ADD EXERCISES TO CONTINUE.';

  @override
  String get suggestionsTitle => 'Suggestions';

  @override
  String get forMen => 'For Men';

  @override
  String get forWomen => 'For Women';

  @override
  String get suggestHypertrophyChest => 'Hypertrophy - Chest and Triceps';

  @override
  String get suggestHypertrophyChestDesc =>
      'Volume focus for the upper front body.';

  @override
  String get suggestHypertrophyBack => 'Hypertrophy - Back and Biceps';

  @override
  String get suggestHypertrophyBackDesc =>
      'Development focused on back width and thickness.';

  @override
  String get suggestGlutesQuads => 'Glutes and Quads Focus';

  @override
  String get suggestGlutesQuadsDesc =>
      'Complete lower workout with emphasis on glutes.';

  @override
  String get suggestHamstringsUpper => 'Hamstrings and Upper Body';

  @override
  String get suggestHamstringsUpperDesc =>
      'Upper body workout with focus on the core.';

  @override
  String get exercisesLabel => 'Exercises:';

  @override
  String get addToMyRoutineUpper => 'ADD TO MY ROUTINE';

  @override
  String get routineImported =>
      'Routine imported! Go to Routines tab to configure it.';

  @override
  String get exBenchPress => 'Bench Press';

  @override
  String get exInclineBenchPress => 'Incline Bench Press';

  @override
  String get exFly => 'Chest Fly';

  @override
  String get exTricepsPushdown => 'Triceps Pushdown';

  @override
  String get exSkullCrusher => 'Skull Crusher';

  @override
  String get exLatPulldown => 'Lat Pulldown';

  @override
  String get exBentOverRow => 'Bent Over Row';

  @override
  String get exBicepCurl => 'Bicep Curl';

  @override
  String get exHammerCurl => 'Hammer Curl';

  @override
  String get exSquat => 'Squat';

  @override
  String get exHipThrust => 'Hip Thrust';

  @override
  String get exLegPress => 'Leg Press';

  @override
  String get exLegExtension => 'Leg Extension';

  @override
  String get exLegAbduction => 'Leg Abduction';

  @override
  String get exLegCurl => 'Leg Curl';

  @override
  String get exStiff => 'Stiff Leg Deadlift';

  @override
  String get exLateralRaise => 'Lateral Raise';

  @override
  String get exCrunch => 'Crunch';

  @override
  String get evolutionUpper => 'EVOLUTION';

  @override
  String get noRecordsUpper => 'NO RECORDS.';

  @override
  String get startLiftingUpper => 'START LIFTING TO BUILD YOUR LEGACY.';

  @override
  String get maxLoadUpper => 'MAX LOAD';

  @override
  String get kg => 'KG';

  @override
  String progressUpper(int completed, int total) {
    return 'PROGRESS: $completed / $total';
  }

  @override
  String get bodywtUpper => 'BODYWT';

  @override
  String get weightUpper => 'WEIGHT';

  @override
  String lastRecordUpper(String weight, int reps) {
    return 'LAST: ${weight}KG x $reps';
  }

  @override
  String get typeUpper => 'TYPE';

  @override
  String get repsUpper => 'REPS';

  @override
  String get addSetUpper => '+ ADD SET';

  @override
  String get bodyUpper => 'BODY';

  @override
  String get doUpper => 'DO';
}
