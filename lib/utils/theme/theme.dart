import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/appbar_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/bottom_sheet_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/checkbox_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/chip_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/elevated_button_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/outlined_button_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/text_field_theme.dart';
import 'package:flutter_application_1/utils/theme/custom-themes/text_theme.dart';

class TAppTheme {
  TAppTheme._(); //constructor privado para que no sea accesible desde todos lados

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}