import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati/core/extentions/extentions.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/core/widgets/custom_button.dart';
import 'package:taskati/feature/addTask/psge/add_task_screen.dart';

class Today extends StatelessWidget {
  const Today({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMEd().format(DateTime.now()),
              style: getTitleTextStyle(context, fontWeight: FontWeight.w600),
            ),
            const Gap(5),
            Text(
              "Today",
              style: getTitleTextStyle(context, fontWeight: FontWeight.w600),
            ),
          ],
        )),
        CustomButton(
            width: 126,
            text: "+ Add Task",
            onPressed: () {
              context.pushTo(const AddTaskScreen());
            })
      ],
    );
  }
}
