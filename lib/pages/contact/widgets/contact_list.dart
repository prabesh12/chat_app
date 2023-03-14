import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/pages/contact/controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/entities/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildListItem(UserData item) {
      return Container(
        padding: EdgeInsets.only(
          top: 0.w,
          left: 0.w,
          right: 15.w,
        ),
        child: InkWell(
          onTap: () {
            if (item.id != null) {
              controller.goChat(item);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 0.w,
                  left: 0.w,
                  right: 15.w,
                ),
                child: SizedBox(
                  width: 54.w,
                  height: 54.h,
                  child: CachedNetworkImage(imageUrl: "${item.photourl}"),
                ),
              ),
              Container(
                width: 250.w,
                padding: EdgeInsets.only(
                  top: 15.w,
                  left: 0.w,
                  right: 0.w,
                ),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffe5efe5)))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 200.w,
                      height: 42.h,
                      child: Text(
                        item.name ?? "",
                        style: TextStyle(
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.bold,
                            color: AppColors.thirdElement,
                            fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var item = controller.state.contactList[index];
              return buildListItem(item);
            }, childCount: controller.state.contactList.length)),
          )
        ],
      );
    });
  }
}
