// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Gym Tracker';

  @override
  String get myWorkouts => 'Meus Treinos';

  @override
  String get noWorkoutsFound =>
      'Nenhum treino cadastrado.\nClique no + para criar.';

  @override
  String exercisesCount(int count) {
    return '$count exercícios';
  }

  @override
  String get deleteWorkout => 'Excluir treino';

  @override
  String deleteWorkoutConfirm(String name) {
    return 'Deseja excluir \"$name\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get workoutDeletedSuccess => 'Treino excluído com sucesso!';

  @override
  String errorText(String error) {
    return 'Erro: $error';
  }

  @override
  String get morningGrind => 'TREINO MATINAL';

  @override
  String get afternoonShift => 'TURNO DA TARDE';

  @override
  String get nightOperation => 'OPERAÇÃO NOTURNA';

  @override
  String get currentWeek => 'SEMANA ATUAL';

  @override
  String get previousWeek => 'SEMANA ANTERIOR';

  @override
  String get nextWeek => 'PRÓXIMA SEMANA';

  @override
  String get overcome => 'SUPERE-SE.';

  @override
  String get sessions => 'TREINOS';

  @override
  String get routinesLabel => 'ROTINAS';

  @override
  String get noRoutinesBuildOne => 'NENHUMA ROTINA.\nCRIE UMA.';

  @override
  String exercisesCountUpper(int count) {
    return '$count EXERCÍCIOS';
  }

  @override
  String get startWorkout => 'INICIAR';

  @override
  String get loadingUpper => 'CARREGANDO...';

  @override
  String errorUpper(String error) {
    return 'ERRO: $error';
  }

  @override
  String get noRoutinesCreateOne => 'NENHUMA ROTINA.\nCRIE UMA.';

  @override
  String get routineDeletedUpper => 'ROTINA EXCLUÍDA';

  @override
  String daysLabelUpper(String days) {
    return 'DIAS: $days';
  }

  @override
  String get routineCreatedUpper => 'ROTINA CRIADA';

  @override
  String get newExerciseUpper => 'NOVO EXERCÍCIO';

  @override
  String get exerciseNameUpper => 'NOME DO EXERCÍCIO';

  @override
  String get muscleGroupUpper => 'GRUPO MUSCULAR';

  @override
  String get cancelUpper => 'CANCELAR';

  @override
  String get saveUpper => 'SALVAR';

  @override
  String get newRoutineUpper => 'NOVA ROTINA';

  @override
  String get routineNameUpper => 'NOME DA ROTINA';

  @override
  String get requiredUpper => 'OBRIGATÓRIO';

  @override
  String get exercisesUpper => 'EXERCÍCIOS';

  @override
  String get newUpper => 'NOVO';

  @override
  String get searchUpper => 'BUSCAR';

  @override
  String get allUpper => 'TODOS';

  @override
  String get notFoundUpper => 'NÃO ENCONTRADO.';

  @override
  String get routineUpdatedSuccess => 'Treino atualizado com sucesso!';

  @override
  String get selectOneDayAtLeast => 'Selecione ao menos um dia da semana.';

  @override
  String get newExercise => 'Novo Exercício';

  @override
  String get exerciseName => 'Nome do Exercício';

  @override
  String get muscleGroup => 'Grupo Muscular';

  @override
  String get editRoutine => 'Editar Treino';

  @override
  String get routineName => 'Nome do Treino';

  @override
  String get required => 'Obrigatório';

  @override
  String get daysOfWeek => 'Dias da Semana';

  @override
  String get exercises => 'Exercícios';

  @override
  String get createNew => 'Criar Novo';

  @override
  String get searchExercise => 'Pesquisar Exercício';

  @override
  String get all => 'Todos';

  @override
  String get noExercisesFound => 'Nenhum exercício encontrado.';

  @override
  String get finishUpper => 'FINALIZAR';

  @override
  String get emptyUpper => 'VAZIO.';

  @override
  String get addExercisesToContinueUpper =>
      'ADICIONE EXERCÍCIOS PARA CONTINUAR.';

  @override
  String get suggestionsTitle => 'Sugestões';

  @override
  String get forMen => 'Para Homens';

  @override
  String get forWomen => 'Para Mulheres';

  @override
  String get suggestHypertrophyChest => 'Hipertrofia - Peito e Tríceps';

  @override
  String get suggestHypertrophyChestDesc =>
      'Foco em volume para a parte superior frontal.';

  @override
  String get suggestHypertrophyBack => 'Hipertrofia - Costas e Bíceps';

  @override
  String get suggestHypertrophyBackDesc =>
      'Desenvolvimento focado na largura e espessura das costas.';

  @override
  String get suggestGlutesQuads => 'Foco Glúteos e Quadríceps';

  @override
  String get suggestGlutesQuadsDesc =>
      'Treino inferior completo com ênfase em glúteos.';

  @override
  String get suggestHamstringsUpper => 'Posterior e Superiores';

  @override
  String get suggestHamstringsUpperDesc =>
      'Treino de membros superiores com foco no core.';

  @override
  String get exercisesLabel => 'Exercícios:';

  @override
  String get addToMyRoutineUpper => 'ADICIONAR À MINHA ROTINA';

  @override
  String get routineImported =>
      'Treino importado! Vá na aba Treinos para configurá-lo.';

  @override
  String get exBenchPress => 'Supino Reto';

  @override
  String get exInclineBenchPress => 'Supino Inclinado';

  @override
  String get exFly => 'Crucifixo';

  @override
  String get exTricepsPushdown => 'Tríceps Polia';

  @override
  String get exSkullCrusher => 'Tríceps Testa';

  @override
  String get exLatPulldown => 'Puxada Frontal';

  @override
  String get exBentOverRow => 'Remada Curvada';

  @override
  String get exBicepCurl => 'Rosca Direta';

  @override
  String get exHammerCurl => 'Rosca Martelo';

  @override
  String get exSquat => 'Agachamento Livre';

  @override
  String get exHipThrust => 'Elevação Pélvica';

  @override
  String get exLegPress => 'Leg Press';

  @override
  String get exLegExtension => 'Cadeira Extensora';

  @override
  String get exLegAbduction => 'Cadeira Abdutora';

  @override
  String get exLegCurl => 'Cadeira Flexora';

  @override
  String get exStiff => 'Stiff';

  @override
  String get exLateralRaise => 'Elevação Lateral';

  @override
  String get exCrunch => 'Abdominal Supra';

  @override
  String get evolutionUpper => 'EVOLUÇÃO';

  @override
  String get noRecordsUpper => 'SEM RECORDES.';

  @override
  String get startLiftingUpper => 'COMECE A TREINAR PARA CONSTRUIR SEU LEGADO.';

  @override
  String get maxLoadUpper => 'CARGA MÁX.';

  @override
  String get kg => 'KG';

  @override
  String progressUpper(int completed, int total) {
    return 'PROGRESSO: $completed / $total';
  }

  @override
  String get bodywtUpper => 'CORPO';

  @override
  String get weightUpper => 'CARGA';

  @override
  String lastRecordUpper(String weight, int reps) {
    return 'ÚLT: ${weight}KG x $reps';
  }

  @override
  String get typeUpper => 'TIPO';

  @override
  String get repsUpper => 'REPS';

  @override
  String get addSetUpper => '+ ADICIONAR SÉRIE';

  @override
  String get bodyUpper => 'CORPO';

  @override
  String get doUpper => 'FEITO';
}
