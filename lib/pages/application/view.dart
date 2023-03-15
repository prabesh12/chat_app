import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/pages/contact/view.dart';
import 'package:firebase_chat/pages/messages/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildPageView() {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handlePageChange,
        children: const [
          MessagePage(),
          ContactPage(),
          Center(child: Text("Profile")),
        ],
      );
    }

    Widget _buildBottomNavigationBar() {
      return Obx(() => BottomNavigationBar(
            items: controller.bottomTabs,
            currentIndex: controller.state.page,
            type: BottomNavigationBarType.fixed,
            onTap: controller.handleNavBarTap,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: AppColors.tabBarElement,
            selectedItemColor: AppColors.thirdElement,
          ));
    }

    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
