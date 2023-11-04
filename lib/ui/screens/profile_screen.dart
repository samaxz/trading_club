import 'dart:io';

import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> saveImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    await ref.read(userInfoSharedPrefsNP.notifier).setImagePath(image.path);
  }

  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoSharedPrefsNP);
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.chevron_back,
                color: Helper.greySecondary,
                // size: isTablet ? 12.sp : 28,
                size: 27.r,
                // size: 12.sp,
              ),
              Text(
                'Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Helper.greySecondary,
                  // fontSize: 20,
                  // fontSize: isTablet ? 9.sp : 18,
                  fontSize: 15.sp,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.41,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Text(
          'Edit profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 22,
            // not sure i need this bool
            // fontSize: isTablet ? 10.sp : 19,
            fontSize: 19.sp,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w600,
            // letterSpacing: -0.41,
          ),
        ),
        backgroundColor: Helper.greyTile,
      ),
      body: Center(
        child: SizedBox(
          width: isTablet ? 350 : MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 40.h),
              GestureDetector(
                onTap: () async => await saveImage(),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 65.r,
                      backgroundColor: Helper.greyTile,
                      backgroundImage: userInfo.imagePath == null
                          ? null
                          : !File(userInfo.imagePath!).existsSync()
                              ? null
                              : FileImage(
                                  File(userInfo.imagePath!),
                                ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Helper.yellow,
                          child: Image.asset(
                            Helper.camera,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 60,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Name should be at least 2 characters long';
                      }

                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-z A-Z]+$'),
                      ),
                    ],
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: userInfo.name ?? 'Name',
                      hintStyle: TextStyle(
                        color: Helper.greySecondary,
                        // fontSize: isTablet ? 9.sp : 18,
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0.1,
                        letterSpacing: -0.10,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Helper.greySecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await ref.read(userInfoSharedPrefsNP.notifier).setName(controller.text);
                  }
                },
                child: FittedBox(
                  child: Container(
                    width: isTablet ? 60.w : MediaQuery.of(context).size.width - 50,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Helper.yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: const Color(0xFF070808),
                        // fontSize: isTablet ? 9.sp : 18,
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
