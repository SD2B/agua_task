import 'dart:ui';

import 'package:agua_task/helpers/sddb_helper.dart';
import 'package:agua_task/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskTile extends HookWidget {
  final TaskModel model;
  final VoidCallback onSlideToRight;
  final VoidCallback onSlideToLeft;

  const TaskTile({
    super.key,
    required this.model,
    required this.onSlideToRight,
    required this.onSlideToLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<TaskModel>(model),
      onDismissed: (direction) {
        qp("hiiiiiiiiiii");
        if (direction == DismissDirection.startToEnd) {
          onSlideToRight();
        } else if (direction == DismissDirection.endToStart) {
          onSlideToLeft();
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        // Show the Snackbar
        bool isDismissed = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: direction == DismissDirection.startToEnd ? const Text("Task deleted.") : const Text("Task updated."),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                isDismissed = false;
              },
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        return isDismissed;
      },
      background: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 45,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              SizedBox(width: 10),
              Icon(Icons.delete, color: Colors.red),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 45,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: model.status == TaskStatus.completed ? Colors.green[100] : Colors.white,
        ),
        margin: const EdgeInsets.only(top: 10),
        height: 65,
        constraints: BoxConstraints(maxHeight: 70, minHeight: 50),
        width: context.width(),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model.title}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: model.status == TaskStatus.completed ? context.width() - 105 : context.width() - 80,
                  height: 30,
                  child: Text(
                    "${model.description}",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            if (model.status == TaskStatus.completed)
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
