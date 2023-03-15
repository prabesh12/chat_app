import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/common/widgets/widgets.dart';
import 'package:firebase_chat/pages/messages/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat/widgets/message_list.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});
  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text(
      "Message",
      style: TextStyle(
          color: AppColors.primaryBackground,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body:const MessageList(),
    );
  }
}
