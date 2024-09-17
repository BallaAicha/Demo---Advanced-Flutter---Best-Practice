import 'package:flutter/material.dart';
import 'package:testeur/presentation/instructor/instructorview.dart';
import 'package:testeur/presentation/main/main.dart';
import 'package:testeur/presentation/ressources/strings_manager.dart';
import 'package:testeur/presentation/setting/settingview.dart';
import 'package:testeur/presentation/student/studentview.dart';
import '../course/courseview.dart';
import '../instructor-courses/instructor-courses.dart';
import '../login/login.dart';
import '../student-courses/student-courses.dart';
import '../../domain/model/logged_user.dart';

class Routes {
  static const String loginRoute = "/login";
  static const String mainRoute = "/main";
  static const String courseRoute = "/course";
  static const String studentRoute = "/student";
  static const String instructorRoute = "/instructor";
  static const String settingRoute = "/setting";
  static const String studentcourse = "/studentcourse";
  static const String instructorcourse = "/instructorcourse";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    print('Navigating to: ${routeSettings.name}');
    print('Arguments: ${routeSettings.arguments}');

    switch (routeSettings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.studentcourse:
        final args = routeSettings.arguments;
        if (args is String) {
          print('Navigating to StudentCourses with studentId: $args');
          return MaterialPageRoute(builder: (_) => StudentCourses(studentId: args));
        }
        print('Invalid arguments for studentcourse: $args');
        return unDefinedRoute();
      case Routes.instructorcourse:
        final args = routeSettings.arguments;
        if (args is String) {
          print('Navigating to InstructorCourses with instructorId: $args');
          return MaterialPageRoute(builder: (_) => InstructorCourses(instructorId: args));
        }
        print('Invalid arguments for instructorcourse: $args');
        return unDefinedRoute();
      case Routes.courseRoute:
        return MaterialPageRoute(builder: (_) => Courseview());
      case Routes.studentRoute:
        return MaterialPageRoute(builder: (_) => StudentView());
      case Routes.instructorRoute:
        return MaterialPageRoute(builder: (_) => InstructorView());
      case Routes.settingRoute:
        final args = routeSettings.arguments;
        if (args is LoggedUser) {
          print('Navigating to SettingView with LoggedUser: $args');
          return MaterialPageRoute(builder: (_) => SettingView(
            loggedUser: args,
          ));
        }
        print('Invalid arguments for settingRoute: $args');
        return unDefinedRoute();
      default:
        print('No route found for: ${routeSettings.name}');
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound),
        ),
        body: Center(child: Text(AppStrings.noRouteFound)),
      ),
    );
  }
}