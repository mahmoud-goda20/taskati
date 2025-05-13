import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati/core/extentions/extentions.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/core/widgets/custom_button.dart';
import 'package:taskati/feature/home/page/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? path;
  TextEditingController nameController = TextEditingController();
  String? name;
  bool isDrarkTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (path != null) {
              AppLocalStorage.cacheData(AppLocalStorage.imagKey, path);
            }

            context.pushReplacement(const HomeScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                isDrarkTheme = AppLocalStorage.getCachedData(
                        AppLocalStorage.isDarkTheme) ??
                    false;
                AppLocalStorage.cacheData(
                    AppLocalStorage.isDarkTheme, !isDrarkTheme);

                setState(() {
                  isDrarkTheme = !isDrarkTheme;
                });
              },
              icon: Icon(
                isDrarkTheme ? Icons.light_mode : Icons.dark_mode,
                color: AppColors.primaryColor,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: path == null
                        ? FileImage(
                            File(
                              AppLocalStorage.getCachedData(
                                  AppLocalStorage.imagKey),
                            ),
                          )
                        : FileImage(File(path!)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isDrarkTheme
                            ? AppColors.darkColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomButton(
                                                width: double.infinity,
                                                text: "Upload from Camera",
                                                onPressed: () {
                                                  uploadImage(true);
                                                }),
                                            const Gap(20),
                                            CustomButton(
                                                width: double.infinity,
                                                text: "Upload from Gallery",
                                                onPressed: () {
                                                  uploadImage(false);
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColors.primaryColor,
                            size: 20,
                          )),
                    ),
                  )
                ],
              ),
              const Gap(40),
              Divider(
                color: AppColors.primaryColor,
                indent: 30,
                endIndent: 30,
              ),
              const Gap(40),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name == null
                          ? AppLocalStorage.getCachedData(
                              AppLocalStorage.nameKey)
                          : name!,
                      style: getTitleTextStyle(context,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: isDrarkTheme
                                ? AppColors.darkColor
                                : AppColors.whiteColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(30),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  AppLocalStorage.getCachedData(
                                                      AppLocalStorage.nameKey),
                                              hintStyle: getBodyTextStyle(
                                                  context,
                                                  color: isDrarkTheme
                                                      ? AppColors.whiteColor
                                                      : AppColors.darkColor)),
                                        ),
                                        const Gap(20),
                                        CustomButton(
                                            width: double.infinity,
                                            text: "Update Your Name",
                                            onPressed: () {
                                              AppLocalStorage.cacheData(
                                                  AppLocalStorage.nameKey,
                                                  nameController.text);
                                              setState(() {
                                                name = nameController.text;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.primaryColor,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  uploadImage(bool isCamera) async {
    XFile? pickedImage = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        path = pickedImage.path;
      });
    }
  }
}
