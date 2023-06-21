import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xff003559),
  primaryColorLight: const Color.fromARGB(255, 185, 214, 242),
  primaryColorDark: const Color(0xffFFF4E6),
  canvasColor: const Color(0xffB9D6F2),
  scaffoldBackgroundColor: const Color(0xffC3D6E7),
  secondaryHeaderColor: const Color(0xfffdf4e7),
  dialogBackgroundColor: const Color(0xffffffff),
  indicatorColor: const Color(0xff003559),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff003559),
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    minWidth: 88,
    height: 36,
    buttonColor: Color(0xff003559),
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xff000000),
        width: 0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    colorScheme: ColorScheme(
      primary: Color(0xff003559),
      secondary: Color(0xff006DAA),
      surface: Color(0xffffffff),
      background: Color(0xfff8d4a0),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xff000000),
      onSecondary: Color(0xff000000),
      onSurface: Color(0xff000000),
      onBackground: Color(0xff000000),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xffffffff)),
);