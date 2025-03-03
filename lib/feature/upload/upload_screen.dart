import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati/core/extentions/extentions.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/core/widgets/custom_button.dart';
import 'package:taskati/core/widgets/dialog.dart';
import 'package:taskati/feature/home/page/home_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? path;
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (path != null && nameController.text.isNotEmpty) {
                  AppLocalStorage.cacheData(
                      AppLocalStorage.nameKey, nameController.text);
                  AppLocalStorage.cacheData(AppLocalStorage.imagKey, path);
                  AppLocalStorage.cacheData(AppLocalStorage.isUploaded, true);
                  context.pushReplacement(const HomeScreen());
                } else if (path == null && nameController.text.isNotEmpty) {
                  showError(context, "please select your image");
                } else if (path != null && nameController.text.isEmpty) {
                  showError(context, "please enter your name");
                } else {
                  showError(
                      context, "please select your image and enter your name");
                }
              },
              child: Text(
                'Done',
                style: getBodyTextStyle(context, color: AppColors.primaryColor),
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundImage: path != null
                    ? FileImage(File(path!))
                    : const AssetImage("assets/images/OIP.jpg"),
                backgroundColor: AppColors.darkColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: "Upload from Camera",
                onPressed: () {
                  uploadImage(true);
                },
                width: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Upload from Gallery",
                onPressed: () {
                  uploadImage(false);
                },
                width: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: AppColors.primaryColor,
                indent: 30,
                endIndent: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                ),
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
