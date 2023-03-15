import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/messages/chat/index.dart';
import 'package:firebase_chat/pages/messages/chat/widgets/receiver_message.dart';
import 'package:firebase_chat/pages/messages/chat/widgets/sender_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
       () {
        return Container(
          color: AppColors.chatbg,
          padding: EdgeInsets.only(bottom: 50.h),
          child: CustomScrollView(
            reverse: true,
            controller: controller.scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                   sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index){
                    var item = controller.state.msgContentList[index];
                    
                    if(controller.user_id== item.uid){
                      return SenderMessage(item);
                    }
                    return ReceiverMessage(item);

                   },
                   childCount: controller.state.msgContentList.length)),
              )
            ],
          ),
        );
      }
    );
  }
}