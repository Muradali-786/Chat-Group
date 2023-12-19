import 'package:flutter/material.dart';

class AppStyle {
  TextStyle defaultStyle(double size, Color color, FontWeight fw) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }

  TextStyle defaultStyleWithHt(
      double size, Color color, FontWeight fw, double ht) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fw,
      height: ht,
    );
  }

  TextStyle metropolisStyle(double size, Color color, FontWeight fw) {
    return TextStyle(
      fontFamily: 'Metropolis',
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }

  TextStyle metropolisWithHt(
      double size, Color color, FontWeight fw, double ht) {
    return TextStyle(
      fontFamily: 'Metropolis',
      fontSize: size,
      color: color,
      fontWeight: fw,
      height: ht,
    );
  }
}
