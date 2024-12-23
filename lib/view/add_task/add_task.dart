import 'package:agua_task/common_widgets/custom_button.dart';
import 'package:agua_task/common_widgets/custom_dropdown.dart';
import 'package:agua_task/common_widgets/custom_text_field.dart';
import 'package:agua_task/core/colors.dart';
import 'package:agua_task/core/constants.dart';
import 'package:agua_task/helpers/sddb_helper.dart';
import 'package:agua_task/models/task_model.dart';
import 'package:agua_task/vm/task_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AddTask extends HookWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final task = useState(TaskModel());
    final _formKey = GlobalKey<FormState>(); // Form key for validation

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assigning the form key
          child: Column(
            children: [
              SizedBox(
                height: context.height() - 200,
                child: Column(
                  children: [
                    CustomTextField(
                      height: 70,
                      controller: titleController,
                      hintText: "Title",
                      hintTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffA8B1BE),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is mandatory';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      color: Colors.white54,
                    ),
                    10.height,
                    CustomTextField(
                      maxLines: 6,
                      controller: descriptionController,
                      hintText: "Description",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is mandatory';
                        }
                        return null;
                      },
                    ),
                    5.height,
                    CustomDropdown(
                      initialValue: task.value.category,
                      hint: "Category",
                      items: ConstantData.taskCategoryList,
                      onChanged: (value) {
                        task.value = task.value.copyWith(category: value);
                      },
                    ),
                    20.height,
                    Container(
                      width: context.width(),
                      height: 70,
                      decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatusSelectionCard(value: TaskStatus.pending, task: task),
                          StatusSelectionCard(value: TaskStatus.inProgress, task: task),
                          StatusSelectionCard(value: TaskStatus.completed, task: task),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    height: 50,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorCode.colorList(context).customTextColor,
                        ),
                    width: context.width() - 160,
                    text: "Save",
                    type: Buttontype.primary,
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        task.value = task.value.copyWith(
                          title: titleController.text,
                          description: descriptionController.text,
                        );
                        bool res = await taskVM.saveTask(task.value);
                        if (res == true) {
                          titleController.clear();
                          descriptionController.clear();
                          task.dispose();
                          GoRouter.of(context).pop();
                        }
                      }
                    },
                  ),
                  CustomButton(
                    height: 50,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorCode.colorList(context).customTextColor,
                        ),
                    width: 100,
                    text: "Cancel",
                    type: Buttontype.secondary,
                    onTap: () {
                      titleController.clear();
                      descriptionController.clear();
                      task.dispose();
                      GoRouter.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StatusSelectionCard extends StatelessWidget {
  final String value;
  final ValueNotifier<TaskModel> task;
  const StatusSelectionCard({super.key, required this.value, required this.task});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          task.value = task.value.copyWith(status: value);
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: task.value.status == value ? ColorCode.colorList(context).bgColor : null,
          ),
          child: Center(
            child: Text(value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: task.value.status == value ? FontWeight.w500 : FontWeight.w400,
                      color: ColorCode.colorList(context).customTextColor,
                    )),
          ),
        ),
      ),
    );
  }
}
