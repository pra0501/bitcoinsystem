
import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {

  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return Color(int.parse(hexColor, radix: 16));
}

Color getDarkBackground(){
  return getColorFromHex("#F5F5F5");
}
Color getSecondryColor(){
  return getColorFromHex("#0B52E1");
}
Color getPrimaryColor(){
  return getColorFromHex("#343434");
}

