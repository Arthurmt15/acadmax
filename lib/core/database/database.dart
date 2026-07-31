import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/workout/domain/models.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          ExerciseSchema,
          WorkoutRoutineSchema,
          WorkoutSessionSchema,
          SetRecordSchema,
        ],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
