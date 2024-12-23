import 'package:agua_task/helpers/local_storage.dart';
import 'package:agua_task/models/task_model.dart';

class TaskRepository {
  static Future<List<TaskModel>> getTask() async {
    List<TaskModel> taskList = [];
    List<Map<String, dynamic>> data = await LocalStorage.get(DBTable.task);
    taskList = data.map((e) => TaskModel.fromJson(e)).toList();
    return taskList;
  }

  static Future<bool> saveTask(TaskModel model) async {
    try {
      await LocalStorage.save(DBTable.task, model.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTask(TaskModel model) async {
    try {
      await LocalStorage.update(DBTable.task, model.toJson(), where: {"id": model.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTask(TaskModel model) async {
    try {
      await LocalStorage.delete(DBTable.task, where: {"id": model.id});
      return true;
    } catch (e) {
      return false;
    }
  }
}
