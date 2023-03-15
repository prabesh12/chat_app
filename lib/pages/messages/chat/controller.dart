import 'dart:io';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/common/utils/security.dart';
import 'package:firebase_chat/pages/messages/chat/state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final ChatState state = ChatState();
  final db = FirebaseFirestore.instance;
  final textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  var doc_id = null;
  var listener;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ChatController();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("no image selected");
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = getRandomString(15) + extension(_photo!.path);

    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
       ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;

          case TaskState.paused:
            break;

          case TaskState.success:
            String imageUrl = await getImageUrl(fileName);
            sendImageMessageUrl(imageUrl);
            break;

          
        }
      });
    } catch (e) {
      print("There is an error $e");
    }
  }

  sendImageMessageUrl(String url) async {
    final content = Msgcontent(
        uid: user_id, content: url, type: "image", addtime: Timestamp.now());
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
      textEditingController.clear();
      Get.focusScope?.unfocus();
    });
    await db
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": "[image]", "last_time": Timestamp.now()});
  }

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
      textEditingController.clear();
      Get.focusScope?.unfocus();
    });
    await db
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": sendContent, "last_time": Timestamp.now()});
  }

  @override
  void onReady() {
    super.onReady();
    var messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgContent, options) =>
                msgContent.toFirestore())
        .orderBy("addtime", descending: false);
    state.msgContentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.msgContentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            if (change.doc.data() != null) {
              state.msgContentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.removed:
            if (change.doc.data() != null) {
              state.msgContentList.insert(0, change.doc.data()!);
            }
            break;
        }
      }
    }, onError: (error) => print("Listen failed : $error"));
  }

  @override
  void dispose() {
    scrollController.dispose();
    listener.cancel();
    super.dispose();
  }

  Future getImageUrl(String fileName) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(fileName);
    var str = await spaceRef.getDownloadURL(); // provide path of the image
    return str ?? "";
  }
}
