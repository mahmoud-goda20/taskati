import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati/core/extentions/extentions.dart';
import 'package:taskati/core/model/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/core/widgets/custom_button.dart';
import 'package:taskati/feature/addTask/widget/add_task_fields.dart';
import 'package:taskati/feature/home/page/home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();
  TextEditingController dateControler = TextEditingController();
  TextEditingController startTimeControler = TextEditingController();
  TextEditingController endTimeControler = TextEditingController();
  int selectedColor = 0;
  @override
  void initState() {
    super.initState();
    dateControler.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    startTimeControler.text = DateFormat("hh:mm a").format(DateTime.now());
    endTimeControler.text = DateFormat("hh:mm a").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pushTo(const HomeScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Task",
          style: getTitleTextStyle(context,
              color: AppColors.primaryColor, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Title",
                  style:
                      getTitleTextStyle(context, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                  controller: titleControler,
                  decoration: InputDecoration(
                      hintText: "Enter title here",
                      hintStyle: getSmallTextStyle(context)),
                ),
                const Gap(20),
                AddTaskFields(
                  controller: descriptionControler,
                  title: "Description",
                  hint: "Enter note here",
                  maxlines: 3,
                ),
                AddTaskFields(
                  controller: dateControler,
                  readOnlyBool: true,
                  onTap: () async {
                    var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050));
                    if (pickedDate != null) {
                      dateControler.text =
                          DateFormat("dd/MM/yyyy").format(pickedDate);
                    }
                  },
                  title: "Date",
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: AddTaskFields(
                      readOnlyBool: true,
                      onTap: () async {
                        var pickedStartTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (pickedStartTime != null) {
                          startTimeControler.text =
                              pickedStartTime.format(context);
                        }
                      },
                      title: "Srart Time",
                      controller: startTimeControler,
                      icon: Icon(
                        Icons.watch_later_outlined,
                        color: AppColors.primaryColor,
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: AddTaskFields(
                            readOnlyBool: true,
                            onTap: () async {
                              var pickedEndTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickedEndTime != null) {
                                endTimeControler.text =
                                    pickedEndTime.format(context);
                              }
                            },
                            title: "End Time",
                            controller: endTimeControler,
                            icon: Icon(
                              Icons.watch_later_outlined,
                              color: AppColors.primaryColor,
                            ))),
                  ],
                ),
                const Gap(5),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = index;
                                });
                              },
                              child: CircleAvatar(
                                  backgroundColor: index == 0
                                      ? AppColors.primaryColor
                                      : index == 1
                                          ? AppColors.orangeColor
                                          : AppColors.redColor,
                                  child: selectedColor == index
                                      ? Icon(
                                          Icons.check,
                                          color: AppColors.whiteColor,
                                        )
                                      : null),
                            ),
                          );
                        }),
                      ),
                    ),
                    CustomButton(
                        width: 133,
                        text: "Create Task",
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var key = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString() +
                                titleControler.text;
                            await AppLocalStorage.cacheTask(
                                key,
                                TaskModel(
                                    id: key,
                                    title: titleControler.text,
                                    description: descriptionControler.text,
                                    date: dateControler.text,
                                    startTime: startTimeControler.text,
                                    endTime: endTimeControler.text,
                                    isCompleted: false,
                                    color: selectedColor));

                            context.pushReplacement(const HomeScreen());
                          }
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
