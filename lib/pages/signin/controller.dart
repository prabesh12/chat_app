import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/common/widgets/toast.dart';
import 'package:firebase_chat/pages/signin/state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/routes/names.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  final state = SignInState();

  SignInController();
  final db = FirebaseFirestore.instance;
  Future<void> handleSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        final _googleAuth = await user.authentication;
    final _credential =    GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
            await FirebaseAuth.instance.signInWithCredential(_credential);
        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? "";
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = email;
        userProfile.accessToken = id;
        userProfile.displayName = displayName;
        userProfile.photoUrl = photoUrl;

        UserStore.to.saveProfile(userProfile);
        var userbase = await db
            .collection("users")
            .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userData, options) =>
                    userData.toFirestore())
            .where("id", isEqualTo: id)
            .get();
        if (userbase.docs.isEmpty) {
          final data = UserData(
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          await db
              .collection("users")
              .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userData, options) =>
                      userData.toFirestore())
              .add(data);
        }
        toastInfo(msg: "Login Successful");
        Get.offAndToNamed(AppRoutes.Application);
      }
    } catch (e) {
      toastInfo(msg: "login error");
      print(e);
    }
  }

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("user is currently logged out");
      } else {
        print("user is currently logged out");
      }
    });
  }
}
