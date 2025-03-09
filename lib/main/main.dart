import 'package:app_builder/app/app.dart';
import 'package:app_builder/main/bootstrap.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:task_builder/task_builder.dart';
import 'package:task_repository/task_repository.dart';

void main() {
  bootstrap((sharedPreferences) async {
    final persistentStorage = PersistentStorage(
      sharedPreferences: sharedPreferences,
    );

    final taskRepository = TaskRepository(storage: persistentStorage);

    final preferencesRepository = PreferencesRepository(
      storage: persistentStorage,
    );

    final taskBuilderService = TaskBuilderService();

    return App(
      taskRepository: taskRepository,
      preferencesRepository: preferencesRepository,
      taskBuilderService: taskBuilderService,
    );
  });
}
