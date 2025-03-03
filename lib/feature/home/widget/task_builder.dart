import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati/core/model/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';

class TaskBuilder extends StatelessWidget {
  const TaskBuilder({
    super.key,
    required this.selectedDate,
  });

  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: AppLocalStorage.taskBox!.listenable(),
        builder: (context, box, child) {
          List<TaskModel> tasks =
              box.values.where((e) => e.date == selectedDate).toList();
          if (tasks.isEmpty) {
            return Center(child: Lottie.asset("assets/images/empty.json"));
          }
          return ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  secondaryBackground: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: AppColors.whiteColor,
                        ),
                        const Gap(10),
                        Text(
                          "Delete",
                          style: TextStyle(color: AppColors.whiteColor),
                        )
                      ],
                    ),
                  ),
                  background: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.done,
                          color: AppColors.whiteColor,
                        ),
                        const Gap(10),
                        Text(
                          "Complete",
                          style: TextStyle(color: AppColors.whiteColor),
                        )
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      box.delete(tasks[index].id);
                    } else {
                      box.put(tasks[index].id,
                          tasks[index].copyWith(isCompleted: true));
                    }
                  },
                  child: TaskItem(
                    task: tasks[index],
                  ),
                );
              },
              itemCount: tasks.length);
        },
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
  });
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: task.isCompleted
              ? Colors.green
              : task.color == 0
                  ? AppColors.primaryColor
                  : task.color == 1
                      ? AppColors.orangeColor
                      : AppColors.redColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: getBodyTextStyle(context,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor),
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: AppColors.whiteColor,
                        size: 18,
                      ),
                      const Gap(5),
                      Text(
                        "${task.startTime} - ${task.endTime}",
                        style: getSmallTextStyle(context,
                            fontSize: 12, color: AppColors.whiteColor),
                      )
                    ],
                  ),
                  const Gap(5),
                  Text(
                    task.description,
                    style:
                        getSmallTextStyle(context, color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            Container(
              width: 0.5,
              height: 60,
              color: AppColors.whiteColor,
            ),
            const Gap(5),
            RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  task.isCompleted ? "COMPLETED" : "TO DO",
                  style: getTitleTextStyle(context,
                      fontSize: 12,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
