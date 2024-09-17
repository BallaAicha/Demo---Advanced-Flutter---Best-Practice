import 'package:flutter/material.dart';


class ColorManager {

  static Color primary = HexColor.fromHex("#ED9728");//primary est une couleur orange
  static Color gradientStart = HexColor.fromHex("#F21A2B"); //gradientStart est une couleur rouge
  static Color gradientEnd = HexColor.fromHex("#E787F2"); //gradientEnd est une couleur rose
  static Color darkGrey = HexColor.fromHex("#525252"); //darkGrey est une couleur gris foncé
  static Color grey = HexColor.fromHex("#737477"); //grey est une couleur gris
  static Color lightGrey = HexColor.fromHex("#9E9E9E"); //lightGrey est une couleur gris clair
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728"); //primaryOpacity70 est une couleur orange avec une opacité de 70%

  static Color darkPrimary = HexColor.fromHex("#d17d11"); //darkPrimary est une couleur orange foncé
  static Color grey1 = HexColor.fromHex("#707070"); //grey1 est une couleur gris
  static Color grey2 = HexColor.fromHex("#797979"); //grey2 est une couleur gris
  static Color white = HexColor.fromHex("#FFFFFF"); //white est une couleur blanche
  static Color error = HexColor.fromHex("#e61f34"); //error est une couleur rouge
  static Color black= HexColor.fromHex("#000000");  //black est une couleur noire
  static const physicsTileColour = Color(0xFFD3D5FE);
  static const languageTileColour = Color(0xFFDAFFD6);
  /// #458CFF
  static const primaryColour = Color(0xFF458CFF);

  /// #757C8E
  static const neutralTextColour = Color(0xFF757C8E);

  /// #D3D5FE


  /// #FFEFDA
  static const scienceTileColour = Color(0xFFFFEFDA);

  /// #FFE4F1
  static const chemistryTileColour = Color(0xFFFFE4F1);

  /// #CFE5FC
  static const biologyTileColour = Color(0xFFCFE5FC);

  /// #FFCECA
  static const mathTileColour = Color(0xFFFFCECA);



  /// #D5BEFB
  static const literatureTileColour = Color(0xFFD5BEFB);

  /// #FF5C5C
  static const redColour = Color(0xFFFF5C5C);

  /// #28CA6C
  static const greenColour = Color(0xFF28CA6C);

  /// #F4F5F6
  static const chatFieldColour = Color(0xFFF4F5F6);

  /// #E8E9EA
  static const chatFieldColourDarker = Color(0xFFE8E9EA);

  static const currentUserChatBubbleColour = Color(0xFF2196F3);

  static const otherUserChatBubbleColour = Color(0xFFEEEEEE);

  static const currentUserChatBubbleColourDarker = Color(0xFF1976D2);

  static const otherUserChatBubbleColourDarker = Color(0xFFE0E0E0);

}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}