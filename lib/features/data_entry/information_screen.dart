import 'dart:io';

import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InformationScreen extends StatefulWidget {
  InformationScreen({super.key});
  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  var picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: 200,
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: buttonPrimaryColor,
                  size: 20,
                ),
                Text(
                  'عودة',
                  style: TextStyle(
                    color: buttonPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'اكمل بياناتك',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: buttonPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: context.height * .05,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: profileImage == null
                            ? NetworkImage(
                                'https://img.freepik.com/premium-photo/handsome-man-with-perfect-muscular-torso-isolated-white-wall_926199-1985034.jpg',
                              )
                            : FileImage(profileImage),
                        radius: 65,
                      ),
                      Container(
                        width: context.width * .111,
                        height: context.height * .05,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 241, 99, 1),
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            getProfileImage();
                          },
                          icon: Icon(
                            color: Colors.black,
                            Icons.edit,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.height * .08,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return ' الرجاء ادخال الاسم';
                      }
                      return null;
                    },
                    label: 'الاسم',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: context.height * .03,
                  ),
                  defaultFormField(
                    controller: ageController,
                    type: TextInputType.number,
                    onSubmit: (value) {
                      if (formKey.currentState!.validate()) {}
                    },
                    validate: (value) {
                      if (value!.isEmpty) {
                        return ' الرجاء ادخال عمرك';
                      }
                      if ((value.compareTo('70') == 1) ||
                          (value.compareTo('18') == -1)) {
                        return 'الرجاء ادخال سن مناسب';
                      }
                      return null;
                    },
                    label: 'العمر',
                    prefix: Icons.calendar_month_sharp,
                  ),
                  SizedBox(
                    height: context.height * .03,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.number,
                    onSubmit: (value) {
                      if (formKey.currentState!.validate()) {}
                    },
                    isPassword: false,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء ادخال رقم الهاتف';
                      }
                      if (value.length != 11 ||
                          value.substring(0, 2) != '01' ||
                          (value[2] != '0' &&
                              value[2] != '1' &&
                              value[2] != '2' &&
                              value[2] != '5')) {
                        return 'الرجاء ادخال رقم هاتف صحيح';
                      }
                      return null;
                    },
                    label: 'رقم الهاتف',
                    prefix: Icons.phone_enabled_rounded,
                  ),
                  SizedBox(
                    height: context.height * .09,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: defaultButton(
                      width: context.width * .444,
                      function: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      text: 'التالي',
                      radius: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
        print(pickedFile.path);
      });
    }
  }
}
