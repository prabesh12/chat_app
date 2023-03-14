import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/pages/contact/state.dart';
import 'package:get/get.dart';
import '../../common/routes/names.dart';

class ContactController extends GetxController {
  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  ContactController();

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData to_userData) async {
    var from_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("form_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: to_userData.id)
        .get();
    var to_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("form_uid", isEqualTo: to_userData.id)
        .where("to_uid", isEqualTo: token)
        .get();

    if (from_message.docs.isEmpty && to_message.docs.isEmpty) {
      String profile = await UserStore.to.getProfile();

      UserLoginResponseEntity userData =
          UserLoginResponseEntity.fromJson(jsonDecode(profile));

      var msgData = Msg(
          from_uid: userData.accessToken,
          to_uid: to_userData.id,
          from_name: userData.displayName,
          to_name: to_userData.name,
          from_avatar: userData.photoUrl,
          to_avatar: to_userData.photourl,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);
      db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgData)
          .then((value) {
        Get.toNamed("/chat", parameters: {
          "doc_id": value.id,
          "to_uid": to_userData.id ?? "",
          "to_name": to_userData.name ?? "",
          "to_avatar": to_userData.photourl ?? ""
        });
      });
    } else {
      if (from_message.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": from_message.docs.first.id,
          "to_uid": to_userData.id ?? "",
          "to_name": to_userData.name ?? "",
          "to_avatar": to_userData.photourl ?? ""
        });
      }
      if (to_message.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": to_message.docs.first.id,
          "to_uid": to_userData.id ?? "",
          "to_name": to_userData.name ?? "",
          "to_avatar": to_userData.photourl ?? ""
        });
      }
    }
  }

  asyncLoadAllData() async {
    var userBase = await db
        .collection("users")
        .where("id", isNotEqualTo: token)
        .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, options) => userData.toFirestore())
        .get();

    for (var doc in userBase.docs) {
      state.contactList.add(doc.data());
      print("data ${doc.toString()}");
    }
  }
}
