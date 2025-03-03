import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/feature/home/widget/home_header.dart';
import 'package:taskati/feature/home/widget/task_builder.dart';
import 'package:taskati/feature/home/widget/today.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const HomeHeader(),
              const Gap(20),
              const Today(),
              const Gap(20),
              DatePicker(
                DateTime.now(),
                width: 70,
                height: 100,
                dayTextStyle: getBodyTextStyle(context),
                monthTextStyle: getBodyTextStyle(context),
                dateTextStyle: getBodyTextStyle(context),
                initialSelectedDate: DateTime.now(),
                selectionColor: AppColors.primaryColor,
                selectedTextColor: AppColors.whiteColor,
                onDateChange: (date) {
                  setState(() {
                    selectedDate = DateFormat("dd/MM/yyyy").format(date);
                  });
                },
              ),
              const Gap(20),
              TaskBuilder(
                selectedDate: selectedDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
