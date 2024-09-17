import 'package:flutter/material.dart';

import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';

import '../../ressources/assets_manager.dart';

class ProfileHeader extends StatelessWidget {
  final LoggedUser loggedUser;

  const ProfileHeader({Key? key, required this.loggedUser}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const CircleAvatar(
          radius: 50,
          backgroundImage:AssetImage(ImageAssets.profile)
        ),
        const SizedBox(height: 16),
        //text avec EducationApp
         Text(
          'EducationApp',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25,color: ColorManager.primary),
        ),
        Text(
          loggedUser.userId,
          textAlign: TextAlign.center,
          style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: ColorManager.primary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}