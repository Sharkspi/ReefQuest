import 'package:flutter/foundation.dart';
import 'package:reefquest/utils/result.dart';

import '../../../data/models/task.dart';
import '../../../data/use_cases/DailyTasksUseCase.dart';
import '../../../utils/command.dart';

class DailyTasksViewModel extends ChangeNotifier {
  final DailyTasksUseCase _dailyTasksUseCase;

  late final Command0 load;

  late Task? _importantTask;
  late Task? _selfCareTask;
  late int? _importantRollCount;
  late int? _selfCareRollCount;

  Task? get importantTask => _importantTask;

  Task? get selfCareTask => _selfCareTask;

  int? get importantRollCount => _importantRollCount;

  int? get selfCareRollCount => _selfCareRollCount;

  DailyTasksViewModel({required DailyTasksUseCase dailyTasksUseCase})
      : _dailyTasksUseCase = dailyTasksUseCase {
    load = Command0(_load)..execute();
  }

  Future<Result> _load() async {
    //TODO implement the method by calling the useCase
    try {
      final importantTaskResult =
          await _dailyTasksUseCase.getDailyImportantTask();
      switch (importantTaskResult) {
        case Error<Task?>():
          return importantTaskResult;
        case Ok<Task?>():
      }
      _importantTask = importantTaskResult.value;

      final selfCareTaskResult =
          await _dailyTasksUseCase.getDailySelfCareTask();
      switch (selfCareTaskResult) {
        case Error<Task?>():
          return selfCareTaskResult;
        case Ok<Task?>():
      }
      _selfCareTask = selfCareTaskResult.value;

      final importantRollResult =
          await _dailyTasksUseCase.getImportantRollCount();
      switch (importantRollResult) {
        case Error<int?>():
          return importantRollResult;
        case Ok<int?>():
      }
      _importantRollCount = importantRollResult.value;

      final selfCareRollResult =
          await _dailyTasksUseCase.getSelfCareRollCount();
      switch (selfCareRollResult) {
        case Error<int?>():
          return selfCareRollResult;
        case Ok<int?>():
      }
      _selfCareRollCount = selfCareRollResult.value;
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }
}
