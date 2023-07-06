import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

TextStyle style = TextStyle(fontFamily: 'Montserrat' , fontSize: 14.0);



Text getTextWidgetMaxLines(String text, double fontSize, Color fontColor,
    FontWeight weight, TextAlign textAlign, String fontFamily, int maxLines) {
  return Text(
    text,
    textAlign: textAlign,
    style: style.copyWith(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: fontColor,
      fontWeight: weight,
    ),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
  );
}

Text getTextWidgetMaxLinesSpaces(String text, double fontSize, Color fontColor,
    FontWeight weight, TextAlign textAlign, String fontFamily, int maxLines, double letterSpacing) {
  return Text(
    text,
    textAlign: textAlign,
    style: style.copyWith(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: fontColor,
      fontWeight: weight,
      letterSpacing: letterSpacing
    ),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
  );
}

Text getTextWidgetMaxLinesVerSpaces(String text, double fontSize, Color fontColor,
    FontWeight weight, TextAlign textAlign, String fontFamily, int maxLines, double heightSpacing) {
  return Text(
    text,
    textAlign: textAlign,
    style: style.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: fontColor,
        fontWeight: weight,
        height: heightSpacing
    ),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
  );
}


Text getTextWidget(String text, double fontSize, Color fontColor) {
  return Text(
    text,
    style: style.copyWith(
      fontSize: fontSize,
      color: fontColor,
    ),
    overflow: TextOverflow.ellipsis,
  );
}





Text getTextWidgetWithUnderLine(
    String text, double fontSize, Color fontColor, FontWeight weight) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: style.copyWith(
        fontFamily: 'Rubik',
        fontSize: fontSize,
      color: fontColor,
      decoration: TextDecoration.underline,
      fontWeight: weight
    ),
  );
}



Stack getDeviderWithTextWidget(String text, double fontSize, Color fontColor, FontWeight weight) {
  return Stack(
    children: [
      Text(
        text,
        textAlign: TextAlign.center,
        style: style.copyWith(
            fontFamily: 'Rubik',
            fontSize: fontSize,
            color: fontColor,
            fontWeight: weight
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 5 , left: 2),
        height: 1,
        width: 40,
        color: fontColor,
        // NeumorphicTheme.isUsingDark(context) ? getColorFromHex('#9b9b9b') : getColorFromHex('#a4a5a7'),
      ),
    ],
  );
}

