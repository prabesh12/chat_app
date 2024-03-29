import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/contact/index.dart';
import '../../pages/messages/chat/index.dart';
import '../../pages/signin/index.dart';
import '../../pages/welcome/index.dart';
import '../../pages/application/index.dart';
import '../middlewares/router_welcome.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),

    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),
    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      // middlewares: [
      //   RouteAuthMiddleware(priority: 1),
      // ],
    ),

    GetPage(
        name: AppRoutes.Contact,
        page: () => ContactPage(),
        binding: ContactBinding()),

    // GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding()),
    // //profile
    // GetPage(name: AppRoutes.Me, page: () => MePage(), binding: MeBinding()),
    //chat page
    GetPage(
        name: AppRoutes.Chat, page: () => ChatPage(), binding: ChatBinding()),

    // GetPage(name: AppRoutes.Photoimgview, page: () => PhotoImgViewPage(), binding: PhotoImgViewBinding()),*/
  ];
}
