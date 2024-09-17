import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';
import 'package:testeur/presentation/setting/widgets/user_info_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: UserInfoCard(
                infoThemeColour: ColorManager.physicsTileColour,
                infoIcon: Icon(
                  IconlyLight.document,
                  size: 24,
                  color: Color(0xFF767DFF),
                ),
                infoTitle: 'Courses',
                infoValue: '10', // Valeur statique
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: UserInfoCard(
                infoThemeColour: ColorManager.biologyTileColour,
                infoIcon: Icon(
                  IconlyLight.user,
                  color: Color(0xFF56AEFF),
                  size: 24,
                ),
                infoTitle: 'Instructors',
                infoValue: '5', // Valeur statique
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: UserInfoCard(
                infoThemeColour: ColorManager.chemistryTileColour,
                infoIcon: Icon(
                  IconlyLight.user,
                  color: Color(0xFFFF84AA),
                  size: 24,
                ),
                infoTitle: 'Students',
                infoValue: '8', // Valeur statique
              ),
            ),
          ],
        ),
      ],
    );
  }
}