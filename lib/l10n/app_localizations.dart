import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Gym Tracker'**
  String get appTitle;

  /// No description provided for @myWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Meus Treinos'**
  String get myWorkouts;

  /// No description provided for @noWorkoutsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum treino cadastrado.\nClique no + para criar.'**
  String get noWorkoutsFound;

  /// No description provided for @exercisesCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} exercícios'**
  String exercisesCount(int count);

  /// No description provided for @deleteWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Excluir treino'**
  String get deleteWorkout;

  /// No description provided for @deleteWorkoutConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir \"{name}\"?'**
  String deleteWorkoutConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @workoutDeletedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Treino excluído com sucesso!'**
  String get workoutDeletedSuccess;

  /// No description provided for @errorText.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String errorText(String error);

  /// No description provided for @morningGrind.
  ///
  /// In pt, this message translates to:
  /// **'TREINO MATINAL'**
  String get morningGrind;

  /// No description provided for @afternoonShift.
  ///
  /// In pt, this message translates to:
  /// **'TURNO DA TARDE'**
  String get afternoonShift;

  /// No description provided for @nightOperation.
  ///
  /// In pt, this message translates to:
  /// **'OPERAÇÃO NOTURNA'**
  String get nightOperation;

  /// No description provided for @currentWeek.
  ///
  /// In pt, this message translates to:
  /// **'SEMANA ATUAL'**
  String get currentWeek;

  /// No description provided for @previousWeek.
  ///
  /// In pt, this message translates to:
  /// **'SEMANA ANTERIOR'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In pt, this message translates to:
  /// **'PRÓXIMA SEMANA'**
  String get nextWeek;

  /// No description provided for @overcome.
  ///
  /// In pt, this message translates to:
  /// **'SUPERE-SE.'**
  String get overcome;

  /// No description provided for @sessions.
  ///
  /// In pt, this message translates to:
  /// **'TREINOS'**
  String get sessions;

  /// No description provided for @routinesLabel.
  ///
  /// In pt, this message translates to:
  /// **'ROTINAS'**
  String get routinesLabel;

  /// No description provided for @noRoutinesBuildOne.
  ///
  /// In pt, this message translates to:
  /// **'NENHUMA ROTINA.\nCRIE UMA.'**
  String get noRoutinesBuildOne;

  /// No description provided for @exercisesCountUpper.
  ///
  /// In pt, this message translates to:
  /// **'{count} EXERCÍCIOS'**
  String exercisesCountUpper(int count);

  /// No description provided for @startWorkout.
  ///
  /// In pt, this message translates to:
  /// **'INICIAR'**
  String get startWorkout;

  /// No description provided for @loadingUpper.
  ///
  /// In pt, this message translates to:
  /// **'CARREGANDO...'**
  String get loadingUpper;

  /// No description provided for @errorUpper.
  ///
  /// In pt, this message translates to:
  /// **'ERRO: {error}'**
  String errorUpper(String error);

  /// No description provided for @noRoutinesCreateOne.
  ///
  /// In pt, this message translates to:
  /// **'NENHUMA ROTINA.\nCRIE UMA.'**
  String get noRoutinesCreateOne;

  /// No description provided for @routineDeletedUpper.
  ///
  /// In pt, this message translates to:
  /// **'ROTINA EXCLUÍDA'**
  String get routineDeletedUpper;

  /// No description provided for @daysLabelUpper.
  ///
  /// In pt, this message translates to:
  /// **'DIAS: {days}'**
  String daysLabelUpper(String days);

  /// No description provided for @routineCreatedUpper.
  ///
  /// In pt, this message translates to:
  /// **'ROTINA CRIADA'**
  String get routineCreatedUpper;

  /// No description provided for @newExerciseUpper.
  ///
  /// In pt, this message translates to:
  /// **'NOVO EXERCÍCIO'**
  String get newExerciseUpper;

  /// No description provided for @exerciseNameUpper.
  ///
  /// In pt, this message translates to:
  /// **'NOME DO EXERCÍCIO'**
  String get exerciseNameUpper;

  /// No description provided for @muscleGroupUpper.
  ///
  /// In pt, this message translates to:
  /// **'GRUPO MUSCULAR'**
  String get muscleGroupUpper;

  /// No description provided for @cancelUpper.
  ///
  /// In pt, this message translates to:
  /// **'CANCELAR'**
  String get cancelUpper;

  /// No description provided for @saveUpper.
  ///
  /// In pt, this message translates to:
  /// **'SALVAR'**
  String get saveUpper;

  /// No description provided for @newRoutineUpper.
  ///
  /// In pt, this message translates to:
  /// **'NOVA ROTINA'**
  String get newRoutineUpper;

  /// No description provided for @routineNameUpper.
  ///
  /// In pt, this message translates to:
  /// **'NOME DA ROTINA'**
  String get routineNameUpper;

  /// No description provided for @requiredUpper.
  ///
  /// In pt, this message translates to:
  /// **'OBRIGATÓRIO'**
  String get requiredUpper;

  /// No description provided for @exercisesUpper.
  ///
  /// In pt, this message translates to:
  /// **'EXERCÍCIOS'**
  String get exercisesUpper;

  /// No description provided for @newUpper.
  ///
  /// In pt, this message translates to:
  /// **'NOVO'**
  String get newUpper;

  /// No description provided for @searchUpper.
  ///
  /// In pt, this message translates to:
  /// **'BUSCAR'**
  String get searchUpper;

  /// No description provided for @allUpper.
  ///
  /// In pt, this message translates to:
  /// **'TODOS'**
  String get allUpper;

  /// No description provided for @notFoundUpper.
  ///
  /// In pt, this message translates to:
  /// **'NÃO ENCONTRADO.'**
  String get notFoundUpper;

  /// No description provided for @routineUpdatedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Treino atualizado com sucesso!'**
  String get routineUpdatedSuccess;

  /// No description provided for @selectOneDayAtLeast.
  ///
  /// In pt, this message translates to:
  /// **'Selecione ao menos um dia da semana.'**
  String get selectOneDayAtLeast;

  /// No description provided for @newExercise.
  ///
  /// In pt, this message translates to:
  /// **'Novo Exercício'**
  String get newExercise;

  /// No description provided for @exerciseName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do Exercício'**
  String get exerciseName;

  /// No description provided for @muscleGroup.
  ///
  /// In pt, this message translates to:
  /// **'Grupo Muscular'**
  String get muscleGroup;

  /// No description provided for @editRoutine.
  ///
  /// In pt, this message translates to:
  /// **'Editar Treino'**
  String get editRoutine;

  /// No description provided for @routineName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do Treino'**
  String get routineName;

  /// No description provided for @required.
  ///
  /// In pt, this message translates to:
  /// **'Obrigatório'**
  String get required;

  /// No description provided for @daysOfWeek.
  ///
  /// In pt, this message translates to:
  /// **'Dias da Semana'**
  String get daysOfWeek;

  /// No description provided for @exercises.
  ///
  /// In pt, this message translates to:
  /// **'Exercícios'**
  String get exercises;

  /// No description provided for @createNew.
  ///
  /// In pt, this message translates to:
  /// **'Criar Novo'**
  String get createNew;

  /// No description provided for @searchExercise.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar Exercício'**
  String get searchExercise;

  /// No description provided for @all.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @noExercisesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum exercício encontrado.'**
  String get noExercisesFound;

  /// No description provided for @finishUpper.
  ///
  /// In pt, this message translates to:
  /// **'FINALIZAR'**
  String get finishUpper;

  /// No description provided for @emptyUpper.
  ///
  /// In pt, this message translates to:
  /// **'VAZIO.'**
  String get emptyUpper;

  /// No description provided for @addExercisesToContinueUpper.
  ///
  /// In pt, this message translates to:
  /// **'ADICIONE EXERCÍCIOS PARA CONTINUAR.'**
  String get addExercisesToContinueUpper;

  /// No description provided for @suggestionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sugestões'**
  String get suggestionsTitle;

  /// No description provided for @forMen.
  ///
  /// In pt, this message translates to:
  /// **'Para Homens'**
  String get forMen;

  /// No description provided for @forWomen.
  ///
  /// In pt, this message translates to:
  /// **'Para Mulheres'**
  String get forWomen;

  /// No description provided for @suggestHypertrophyChest.
  ///
  /// In pt, this message translates to:
  /// **'Hipertrofia - Peito e Tríceps'**
  String get suggestHypertrophyChest;

  /// No description provided for @suggestHypertrophyChestDesc.
  ///
  /// In pt, this message translates to:
  /// **'Foco em volume para a parte superior frontal.'**
  String get suggestHypertrophyChestDesc;

  /// No description provided for @suggestHypertrophyBack.
  ///
  /// In pt, this message translates to:
  /// **'Hipertrofia - Costas e Bíceps'**
  String get suggestHypertrophyBack;

  /// No description provided for @suggestHypertrophyBackDesc.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvimento focado na largura e espessura das costas.'**
  String get suggestHypertrophyBackDesc;

  /// No description provided for @suggestGlutesQuads.
  ///
  /// In pt, this message translates to:
  /// **'Foco Glúteos e Quadríceps'**
  String get suggestGlutesQuads;

  /// No description provided for @suggestGlutesQuadsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Treino inferior completo com ênfase em glúteos.'**
  String get suggestGlutesQuadsDesc;

  /// No description provided for @suggestHamstringsUpper.
  ///
  /// In pt, this message translates to:
  /// **'Posterior e Superiores'**
  String get suggestHamstringsUpper;

  /// No description provided for @suggestHamstringsUpperDesc.
  ///
  /// In pt, this message translates to:
  /// **'Treino de membros superiores com foco no core.'**
  String get suggestHamstringsUpperDesc;

  /// No description provided for @exercisesLabel.
  ///
  /// In pt, this message translates to:
  /// **'Exercícios:'**
  String get exercisesLabel;

  /// No description provided for @addToMyRoutineUpper.
  ///
  /// In pt, this message translates to:
  /// **'ADICIONAR À MINHA ROTINA'**
  String get addToMyRoutineUpper;

  /// No description provided for @routineImported.
  ///
  /// In pt, this message translates to:
  /// **'Treino importado! Vá na aba Treinos para configurá-lo.'**
  String get routineImported;

  /// No description provided for @exBenchPress.
  ///
  /// In pt, this message translates to:
  /// **'Supino Reto'**
  String get exBenchPress;

  /// No description provided for @exInclineBenchPress.
  ///
  /// In pt, this message translates to:
  /// **'Supino Inclinado'**
  String get exInclineBenchPress;

  /// No description provided for @exFly.
  ///
  /// In pt, this message translates to:
  /// **'Crucifixo'**
  String get exFly;

  /// No description provided for @exTricepsPushdown.
  ///
  /// In pt, this message translates to:
  /// **'Tríceps Polia'**
  String get exTricepsPushdown;

  /// No description provided for @exSkullCrusher.
  ///
  /// In pt, this message translates to:
  /// **'Tríceps Testa'**
  String get exSkullCrusher;

  /// No description provided for @exLatPulldown.
  ///
  /// In pt, this message translates to:
  /// **'Puxada Frontal'**
  String get exLatPulldown;

  /// No description provided for @exBentOverRow.
  ///
  /// In pt, this message translates to:
  /// **'Remada Curvada'**
  String get exBentOverRow;

  /// No description provided for @exBicepCurl.
  ///
  /// In pt, this message translates to:
  /// **'Rosca Direta'**
  String get exBicepCurl;

  /// No description provided for @exHammerCurl.
  ///
  /// In pt, this message translates to:
  /// **'Rosca Martelo'**
  String get exHammerCurl;

  /// No description provided for @exSquat.
  ///
  /// In pt, this message translates to:
  /// **'Agachamento Livre'**
  String get exSquat;

  /// No description provided for @exHipThrust.
  ///
  /// In pt, this message translates to:
  /// **'Elevação Pélvica'**
  String get exHipThrust;

  /// No description provided for @exLegPress.
  ///
  /// In pt, this message translates to:
  /// **'Leg Press'**
  String get exLegPress;

  /// No description provided for @exLegExtension.
  ///
  /// In pt, this message translates to:
  /// **'Cadeira Extensora'**
  String get exLegExtension;

  /// No description provided for @exLegAbduction.
  ///
  /// In pt, this message translates to:
  /// **'Cadeira Abdutora'**
  String get exLegAbduction;

  /// No description provided for @exLegCurl.
  ///
  /// In pt, this message translates to:
  /// **'Cadeira Flexora'**
  String get exLegCurl;

  /// No description provided for @exStiff.
  ///
  /// In pt, this message translates to:
  /// **'Stiff'**
  String get exStiff;

  /// No description provided for @exLateralRaise.
  ///
  /// In pt, this message translates to:
  /// **'Elevação Lateral'**
  String get exLateralRaise;

  /// No description provided for @exCrunch.
  ///
  /// In pt, this message translates to:
  /// **'Abdominal Supra'**
  String get exCrunch;

  /// No description provided for @evolutionUpper.
  ///
  /// In pt, this message translates to:
  /// **'EVOLUÇÃO'**
  String get evolutionUpper;

  /// No description provided for @noRecordsUpper.
  ///
  /// In pt, this message translates to:
  /// **'SEM RECORDES.'**
  String get noRecordsUpper;

  /// No description provided for @startLiftingUpper.
  ///
  /// In pt, this message translates to:
  /// **'COMECE A TREINAR PARA CONSTRUIR SEU LEGADO.'**
  String get startLiftingUpper;

  /// No description provided for @maxLoadUpper.
  ///
  /// In pt, this message translates to:
  /// **'CARGA MÁX.'**
  String get maxLoadUpper;

  /// No description provided for @kg.
  ///
  /// In pt, this message translates to:
  /// **'KG'**
  String get kg;

  /// No description provided for @progressUpper.
  ///
  /// In pt, this message translates to:
  /// **'PROGRESSO: {completed} / {total}'**
  String progressUpper(int completed, int total);

  /// No description provided for @bodywtUpper.
  ///
  /// In pt, this message translates to:
  /// **'CORPO'**
  String get bodywtUpper;

  /// No description provided for @weightUpper.
  ///
  /// In pt, this message translates to:
  /// **'CARGA'**
  String get weightUpper;

  /// No description provided for @lastRecordUpper.
  ///
  /// In pt, this message translates to:
  /// **'ÚLT: {weight}KG x {reps}'**
  String lastRecordUpper(String weight, int reps);

  /// No description provided for @typeUpper.
  ///
  /// In pt, this message translates to:
  /// **'TIPO'**
  String get typeUpper;

  /// No description provided for @repsUpper.
  ///
  /// In pt, this message translates to:
  /// **'REPS'**
  String get repsUpper;

  /// No description provided for @addSetUpper.
  ///
  /// In pt, this message translates to:
  /// **'+ ADICIONAR SÉRIE'**
  String get addSetUpper;

  /// No description provided for @bodyUpper.
  ///
  /// In pt, this message translates to:
  /// **'CORPO'**
  String get bodyUpper;

  /// No description provided for @doUpper.
  ///
  /// In pt, this message translates to:
  /// **'FEITO'**
  String get doUpper;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
