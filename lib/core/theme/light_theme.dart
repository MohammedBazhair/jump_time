import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    textTheme: const TextTheme(
      labelSmall: TextStyle(color: Color(0xFF41677F), fontSize: 15),
      labelMedium: TextStyle(
        color: Color(0xFF41677F),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),

    appBarTheme: const AppBarThemeData(
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 17,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      actionsPadding: EdgeInsets.symmetric(horizontal: 11),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2094F3),
        foregroundColor: Colors.white,
        fixedSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shadowColor: Colors.transparent,
      ),
    ),

    iconTheme: const IconThemeData(size: 50),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      linearTrackColor: const Color(0xFFDBE1E6),
      color: const Color(0xFF111518),
      borderRadius: BorderRadius.circular(50),
      linearMinHeight: 7,
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFE7EEF4).withOpacity(.5),
      filled: true,
      hintStyle: TextStyle(color: const Color(0xFF41677F).withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      counterStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
    ),

    tabBarTheme: const TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
    ),

    dividerTheme: const DividerThemeData(space: 0, thickness: 0.4),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Color(0xFF41677F),
      selectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.black),
      selectedLabelStyle: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      unselectedIconTheme: IconThemeData(color: Color(0xFF41677F)),
      unselectedLabelStyle: TextStyle(color: Color(0xFF41677F), fontSize: 15),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
