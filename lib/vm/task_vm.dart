import 'package:agua_task/helpers/sddb_helper.dart';
import 'package:agua_task/models/task_model.dart';
import 'package:agua_task/vm/repositories/task_repository.dart';
import 'package:get/get.dart';

class TaskVM extends GetxController {
  Rx<TaskModel> task = TaskModel().obs;
  RxList<TaskModel> taskList = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTask();
  }

  Future<void> getTask() async {
    taskList.value = await TaskRepository.getTask();
  }

  Future<bool> saveTask(TaskModel model) async {
    qp(model);
    bool res = await TaskRepository.saveTask(model);
    await getTask();
    return res;
  }

  Future<bool> updateTask(TaskModel model) async {
    qp(model);
    model = model.copyWith(status: TaskStatus.completed);
    bool res = await TaskRepository.updateTask(model);
    await getTask();
    return res;
  }

  Future<bool> deleteTask(TaskModel model) async {
    qp(model);
    bool res = await TaskRepository.deleteTask(model);
    await getTask();
    return res;
  }
}

final TaskVM taskVM = Get.put(TaskVM());
