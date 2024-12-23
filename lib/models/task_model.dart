import 'package:freezed_annotation/freezed_annotation.dart';
part '../gen/task_model.freezed.dart';
part '../gen/task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    int? id,
    String? title,
    String? description,
    @Default("Personal") String? category,
    @Default(TaskStatus.pending) String status,
   
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}

class TaskStatus {
  static const String pending = "Pending";
  static const String inProgress = "In Progress";
  static const String completed = "Completed";
}
