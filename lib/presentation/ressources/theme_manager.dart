

import 'package:flutter/material.dart';
import 'package:testeur/presentation/ressources/style_manager.dart';
import 'package:testeur/presentation/ressources/value_manager.dart';


import 'colors_manager.dart';
import 'font_manager.dart';
// Cette fonction configure et retourne le thème global de l'application.
ThemeData getApplicationTheme() {
  return ThemeData(
    // Couleurs principales de l'application
      primaryColor: ColorManager.primary, // Couleur primaire
      primaryColorLight: ColorManager.primaryOpacity70, // Couleur primaire claire avec opacité
      primaryColorDark: ColorManager.darkPrimary, // Couleur primaire foncée
      disabledColor: ColorManager.grey1, // Couleur pour les éléments désactivés
      splashColor: ColorManager.primaryOpacity70, // Couleur d'effet d'onde pour les interactions
      hintColor: ColorManager.white, // Couleur pour les indices dans les champs de texte

      // Thème pour les Card
      cardTheme: CardTheme(
          color: ColorManager.white, // Couleur de fond des cartes
          shadowColor: ColorManager.grey, // Couleur de l'ombre des cartes
          elevation: AppSize.s4), // Élévation des cartes

      // Thème pour la AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true, // Centrer le titre
        elevation: AppSize.s4, // Élévation de la AppBar
        shadowColor: ColorManager.primaryOpacity70, // Couleur de l'ombre de la AppBar
        titleTextStyle: getRegularStyle(
            color: ColorManager.white, fontSize: FontSize.s16), // Style du texte du titre
        backgroundColor: ColorManager.gradientStart, // Set the background color to gradient start
      ),

      // Thème pour les boutons
      buttonTheme: ButtonThemeData(
          shape: StadiumBorder(), // Forme des boutons
          disabledColor: ColorManager.grey1, // Couleur des boutons désactivés
          buttonColor: ColorManager.primary, // Couleur de fond des boutons
          splashColor: ColorManager.primaryOpacity70), // Couleur d'effet d'onde pour les boutons

      // Thème pour les ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(color: ColorManager.white), // Style du texte des boutons
              backgroundColor: ColorManager.primary, // Couleur de fond des boutons
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12)))), // Forme des boutons

      // Thème pour les textes
      textTheme: TextTheme(
          displayLarge: getSemiBoldStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s16), // Style pour les grands titres
          displayMedium: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s16), // Style pour les titres moyens
          displaySmall:
          getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16), // Style pour les petits titres
          headlineMedium: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s14), // Style pour les sous-titres
          titleMedium: getMediumStyle(
              color: ColorManager.lightGrey, fontSize: FontSize.s14), // Style pour les titres de section
          titleSmall: getMediumStyle(
              color: ColorManager.primary, fontSize: FontSize.s14), // Style pour les petits titres de section
          bodyMedium: getMediumStyle(color: ColorManager.lightGrey), // Style pour le texte principal
          bodySmall: getRegularStyle(color: ColorManager.grey1), // Style pour le texte secondaire
          bodyLarge: getRegularStyle(color: ColorManager.grey)), // Style pour le grand texte

      // Thème pour les champs de formulaire
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(AppPadding.p8),// Marge intérieure des champs
        // hint style
        hintStyle: getRegularStyle(color: ColorManager.white),// Style pour les indices

        // label style
        labelStyle: getMediumStyle(color: ColorManager.white),// Style pour les étiquettes
        // error style
        errorStyle: getRegularStyle(color: ColorManager.white),// Style pour les erreurs

        // enabled border
        enabledBorder: OutlineInputBorder(// Bordure pour les champs activés
            borderSide:
            BorderSide(color: ColorManager.grey, width: AppSize.s1_5),// Couleur et épaisseur de la bordure
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // focused border
        focusedBorder: OutlineInputBorder(// Bordure pour les champs en focus
            borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border
        errorBorder: OutlineInputBorder(//
            borderSide:
            BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
      ));
}