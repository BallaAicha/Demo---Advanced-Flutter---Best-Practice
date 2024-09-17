import 'package:flutter/material.dart';
import 'package:testeur/app/manager/token_manager.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';
import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/presentation/student-courses/widgets/student_modal.dart';

import '../../instructor-courses/widgets/InstructorModale.dart';
import '../../instructor/widgets/instructor_modal.dart';
import '../../ressources/routes_manager.dart';
import '../popup_item.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LoggedUser loggedUser;

  const ProfileAppBar({super.key, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    final TokenManager tokenManager = TokenManager();

    void removeUserData() {
      tokenManager.clearTokens();
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.loginRoute,
              (route) => false);
    }

    void getModal(BuildContext context) {
      if (loggedUser.roles.contains('INSTRUCTOR')) {
        showDialog(
          context: context,
          builder: (context) => InstructorModale(
            instructor: loggedUser.instructor,
            loggedUser: loggedUser,
          ),
        );
      } else if (loggedUser.roles.contains('STUDENT')) {
        showDialog(
          context: context,
          builder: (context) => StudentModal(student: loggedUser.student, loggedUser: loggedUser),
        );
      }
    }

    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: Icon(Icons.more_horiz, color: ColorManager.black,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) => [
            if (!loggedUser.roles.contains('ADMIN'))
              PopupMenuItem<void>(
                child: PopupItem(
                  title: 'Edit Profile',
                  icon: Icon(
                    Icons.edit_outlined,
                    color: ColorManager.black,
                  ),
                ),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    getModal(context);
                  });
                },
              ),
            PopupMenuItem<void>(
              child: PopupItem(
                title: 'Help',
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: ColorManager.black,
                ),
              ),
            ),
            PopupMenuItem<void>(
              height: 1,
              padding: EdgeInsets.zero,
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                endIndent: 16,
                indent: 16,
              ),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Logout',
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                removeUserData();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}