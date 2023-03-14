import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/pages/chat/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatState state = ChatState();
  final db = FirebaseFirestore.instance;
  final textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  var doc_id = null;
  ChatController();

  @override
  void onInit() {
    super.onInit();

    var data = Get.parameters;
    doc_id = data['doc_id'];
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data["to_name"] ?? "";
    state.to_avatar.value = data["to_avatar"] ?? "";
    state.to_location.value = data["to_location"] ?? "";
  }

  sendMessage() async {
    String sendContent = textEditingController.text;
    final content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgContent, options) =>
                msgContent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print("Document added with id:  ${doc_id} : ${content}");
      // textEditingController.clear();
      // Get.focusScope?.unfocus();
    });
    await db
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": sendContent, "last_time": Timestamp.now()});
  }
}
