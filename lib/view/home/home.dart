import 'package:agua_task/common_widgets/custom_text_field.dart';
import 'package:agua_task/core/constants.dart';
import 'package:agua_task/helpers/sddb_helper.dart';
import 'package:agua_task/models/task_model.dart';
import 'package:agua_task/view/elements/task_tile.dart';
import 'package:agua_task/vm/task_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final categoryList = useState([...ConstantData.taskCategoryList]);

    // Filtering tasks based on the search query
    final filteredTaskList = useState<List<TaskModel>>(taskVM.taskList);

    // Update the filtered task list when the search query changes
    useEffect(() {
      searchController.addListener(() {
        final query = searchController.text.toLowerCase();
        filteredTaskList.value = taskVM.taskList.where((task) => task.title!.toLowerCase().contains(query)).toList();
      });
      return null;
    }, [searchController]);

    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              CustomTextField(
                height: 50,
                boarderRadius: 12,
                controller: searchController,
                hintText: "Search",
                suffix: Icon(Icons.search),
              ),
              20.height,
              ...categoryList.value.map((category) {
                // Filter and sort tasks for the current category
                final tasks = filteredTaskList.value.where((task) => task.category == category).toList()
                  ..sort((a, b) {
                    // Move tasks with status "Completed" to the bottom
                    if (a.status == "Completed" && b.status != "Completed") {
                      return 1;
                    } else if (a.status != "Completed" && b.status == "Completed") {
                      return -1;
                    } else {
                      return 0;
                    }
                  });

                return tasks.isEmpty
                    ? SizedBox.shrink()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ExpansionTile(
                              backgroundColor: Colors.white54,
                              initiallyExpanded: true,
                              shape: Border(),
                              expansionAnimationStyle: AnimationStyle(
                                curve: Curves.easeInOut,
                                reverseCurve: Curves.easeIn,
                              ),
                              title: Text(category),
                              childrenPadding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                              children: [
                                ...tasks.map(
                                  (task) => TaskTile(
                                    model: task,
                                    onSlideToRight: () async {
                                      qp("awwwww");
                                      await taskVM.deleteTask(task);
                                    },
                                    onSlideToLeft: () async {
                                      qp("yeaaaahhhhhhh");
                                      await taskVM.updateTask(task);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.height,
                        ],
                      );
              }),
              Container(),
            ],
          ),
        );
      },
    );
  }
}
