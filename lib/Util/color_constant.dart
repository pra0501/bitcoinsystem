import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray5001 = fromHex('#f8f9ff');

  static Color indigo300E0 = fromHex('#e06b7ac5');

  static Color gray90087 = fromHex('#871a1a1a');

  static Color gray900 = fromHex('#171717');

  static Color whiteA70090 = fromHex('#90ffffff');

  static Color black9000c = fromHex('#0c000000');

  static Color gray50 = fromHex('#fbfbfb');

  static Color black9001e = fromHex('#1e000000');

  static Color indigo400 = fromHex('#586cd0');

  static Color gray9007e = fromHex('#7e171717');

  static Color black900 = fromHex('#000000');

  static Color gray9008701 = fromHex('#87171717');

  static Color whiteA70019 = fromHex('#19ffffff');

  static Color blue200 = fromHex('#a4b2fa');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray90090 = fromHex('#90171717');

  static Color indigo500 = fromHex('#485ab1');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
