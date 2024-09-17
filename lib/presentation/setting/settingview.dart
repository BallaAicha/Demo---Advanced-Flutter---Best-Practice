import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testeur/presentation/setting/widgets/profile_app_bar.dart';
import 'package:testeur/presentation/setting/widgets/profile_body.dart';
import 'package:testeur/presentation/setting/widgets/profile_header.dart';
import 'package:testeur/domain/model/logged_user.dart';

import '../ressources/colors_manager.dart';

class SettingView extends StatefulWidget {
  final LoggedUser loggedUser;

  const SettingView({Key? key, required this.loggedUser}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(loggedUser: widget.loggedUser),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorManager.gradientStart,
              ColorManager.gradientEnd,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            ProfileHeader(loggedUser: widget.loggedUser),
            ProfileBody()
          ],
        ),
      ),
    );
  }
}