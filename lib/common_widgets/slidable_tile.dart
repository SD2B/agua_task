import 'package:agua_task/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SlideableTileWidget extends HookWidget {
  final List<TaskModel> taskList;
  const SlideableTileWidget({super.key, required this.taskList});

  @override
  Widget build(BuildContext context) {
    final itemList = useState(taskList);
    // final items = useState([
    //   "Dart",
    //   "Kotlin",
    //   "Java",
    //   "Swift",
    //   "Python",
    //   "Go",
    //   "Java Script",
    // ]);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemList.value.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        return Dismissible(
          onDismissed: (direction) {
            itemList.value.removeAt(index);
          },
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete"),
                    content: const Text("Are you sure you want to delete this cart?"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No"),
                      ),
                    ],
                  );
                },
              );
            } else {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Save"),
                    content: const Text("Are you sure you want to save this cart?"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          background: Container(
            height: 50,
            color: Colors.red,
            margin: const EdgeInsets.only(top: 10),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Delete',
                textAlign: TextAlign.left,
              ),
            ),
          ),
          secondaryBackground: Container(
            height: 50,
            color: Colors.blue,
            margin: const EdgeInsets.only(top: 10),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Save',
                textAlign: TextAlign.right,
              ),
            ),
          ),
          key: ValueKey<TaskModel>(itemList.value[index]),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 10),
            height: 50,
            child: Center(
              child: Text(
                itemList.value[index].title ?? "",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }
}
