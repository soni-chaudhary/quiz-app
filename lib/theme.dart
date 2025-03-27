import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData customthemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'NunitoSans',
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color(0xFFFAFAFA),
    ),
    brightness: Brightness.light,
    secondaryHeaderColor: const Color(0xFF2C2929),
    primaryColorDark: const Color(0xFF8980B2),
    primaryColor: const Color(0xFF8980B2),
    unselectedWidgetColor: const Color(0xFFB7B9C3),
    indicatorColor: const Color(0xFF8980B2),
    primaryColorLight: const Color(0xFF979797),
    disabledColor: const Color(0xFF595959),
    appBarTheme: Theme.of(context).appBarTheme.copyWith(
        backgroundColor: const Color(0xFF8980B2),
        systemOverlayStyle: SystemUiOverlayStyle.dark),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    textTheme: TextTheme().copyWith(),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: const Color(0xFF8980B2))
        .copyWith(background: const Color(0xFFF1F6FF))
        .copyWith(error: const Color(0xFFD30202)),
  );
}
