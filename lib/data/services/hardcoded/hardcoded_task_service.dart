import 'package:reefquest/data/models/task.dart';
import 'package:reefquest/data/services/task_service.dart';
import 'package:reefquest/utils/result.dart';

class HardcodedTaskService extends TaskService {
  Map<int, Task> importantTasks = {
    1: Task.id(1, 'Ranger les courses'),
    2: Task.id(2, 'Mettre à jour mon CV'),
    3: Task.id(3, 'Trouver un putain de taff'),
    4: Task.id(4, 'Devenir millionaire'),
    5: Task.id(5, 'Arrêter d' 'être triste'),
    6: Task.id(6, 'Arrêter d' 'être un sac à merde'),
    7: Task.id(7, 'Arrêter de se faire emmerder par le monde'),
    8: Task.id(8, 'Acheter une maison'),
    9: Task.id(9, 'Très important ! Avoir des cailles'),
    10: Task.id(10, 'Apporter la voiture au garage pour les airbags'),
  };

  Map<int, Task> selfCareTasks = {
    1: Task.id(1, 'P' 'tite branlette'),
    2: Task.id(2, 'Manger un burger'),
    3: Task.id(3, 'P' 'tite sieste'),
    4: Task.id(4, 'Jouer à Neva'),
    5: Task.id(5, 'Jouer 2h à Monster Hunter World'),
    6: Task.id(6, 'Faire un câlin à Chachou'),
    7: Task.id(7, 'Arrêter de se faire emmerder par le monde'),
    8: Task.id(8, 'Faire un terra'),
    9: Task.id(9, 'Donner de l' 'amour aux cailles'),
    10: Task.id(10, 'Faire chier les lapins'),
  };

  HardcodedTaskService();

  @override
  Future<Result<List<Task>>> getImportantTasks() async {
    return Result.ok(importantTasks.values.toList());
  }

  @override
  Future<Result<List<Task>>> getSelfCareTasks() async {
    return Result.ok(selfCareTasks.values.toList());
  }

  @override
  Future<Result<Task?>> getTask(int id) async {
    if (selfCareTasks.containsKey(id)) {
      return Result.ok(selfCareTasks[id]);
    } else if (importantTasks.containsKey(id)) {
      return Result.ok(importantTasks[id]);
    }
    return Result.ok(null);
  }

  @override
  Future<Result<void>> saveImportantTask(Task task) async {
    if (importantTasks.containsValue(task)) {
      return Result.ok(null);
    } else {
      importantTasks[_getNewIndex()] = task;
      return Result.ok(null);
    }
  }

  @override
  Future<Result<void>> saveSelfCareTask(Task task) async {
    if (selfCareTasks.containsValue(task)) {
      return Result.ok(null);
    } else {
      selfCareTasks[_getNewIndex()] = task;
      return Result.ok(null);
    }
  }

  int _getNewIndex() {
    List<int> indexes = importantTasks.keys.toList();
    indexes.addAll(selfCareTasks.keys.toList());
    indexes.sort();
    int newIndex = indexes.last + 1;
    return newIndex;
  }

  @override
  Future<Result<void>> updateImportantTask(Task task) {
    // TODO: implement updateImportantTask
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> updateSelfCareTask(Task task) {
    // TODO: implement updateSelfCareTask
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteImportantTask(Task task) {
    // TODO: implement deleteImportantTask
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteSelfCareTask(Task task) {
    // TODO: implement deleteSelfcareTask
    throw UnimplementedError();
  }
}
