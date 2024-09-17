import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/presentation/setting/settingview.dart';

import '../course/courseview.dart';
import '../instructor/instructorview.dart';
import '../ressources/assets_manager.dart';
import '../ressources/colors_manager.dart';
import '../ressources/strings_manager.dart';
import '../ressources/value_manager.dart';
import '../student/studentview.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  LoggedUser? loggedUser;
  late List<Widget> pages;
  late List<String> titles;
  late List<BottomNavigationBarItem> items;
  var _title = AppStrings.courses;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLoggedUser();
  }

  Future<void> _loadLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedUserJson = prefs.getString('loggedUser');
    if (loggedUserJson != null) {
      setState(() {
        loggedUser = LoggedUser.fromJson(jsonDecode(loggedUserJson));
        _initializeNavigation();
      });
    }
  }

  void _initializeNavigation() {
    print('Initializing navigation for MainView');
    pages = [
      Courseview(),
      StudentView(),
      InstructorView(),
      SettingView( loggedUser: loggedUser!),
    ];
    titles = [
      AppStrings.courses,
      AppStrings.student,
      AppStrings.instructor,
      AppStrings.settings,
    ];
    items = [
      BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconAssets.course)), label: AppStrings.courses),
      BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconAssets.student)), label: AppStrings.student),
      BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconAssets.instructor)), label: AppStrings.instructor),
      BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(ImageAssets.profile)), label: AppStrings.settings),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (loggedUser == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    print('Building MainView');
    return Scaffold(
      body: pages.isNotEmpty ? pages[_currentIndex] : Center(child: Text(AppStrings.noRouteFound)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: items,
        ),
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}