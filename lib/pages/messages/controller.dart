import 'dart:html';

import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/pages/messages/bindings.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import "package:location/location.dart";
import '../../common/entities/msg.dart';

class MessageController extends GetxController {
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();

  var listener;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

void onRefresh(){
  asyncLoadAllData().then((_){
    refreshController.refreshCompleted(resetFooterState: true);
  }).catchError((_){
    refreshController.refreshFailed();
  });
}

void onLoading(){
  asyncLoadAllData().then((_){
    refreshController.loadComplete();
  }).catchError((_){
    refreshController.loadFailed();
  });
}
  asyncLoadAllData() async {
 var from_message =   await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .get();
  
   var to_message =   await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: token)
        .get();
         state.msgList.clear();
        if(from_message.docs.isNotEmpty){
          state.msgList.assignAll(  from_message.docs);
        }
        if(to_message.docs.isNotEmpty){
          state.msgList.assignAll(to_message.docs);
        }
  }

  getUserLocation() async{
    try{
         final location = await Location().getLocation();
         String address  = "${location.latitude}, ${location.longitude}";

         String url = "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key";
    }catch(e){
      print("getting error $e");
    }
  }
}
