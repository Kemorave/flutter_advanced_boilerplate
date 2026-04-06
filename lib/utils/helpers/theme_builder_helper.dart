import 'package:flutter/material.dart';
 
class ThemeBuilderOptions {

  const ThemeBuilderOptions({
    this.bigFontSize = 20,
    this.mediumFontSize = 16,
    this.smallFontSize = 14,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.inputPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.iconSize = 24,
  });
  /// Font sizes
  final double bigFontSize;
  final double mediumFontSize;
  final double smallFontSize;

  /// Button padding
  final EdgeInsetsGeometry buttonPadding;

  /// Input field padding
  final EdgeInsetsGeometry inputPadding;

  /// Icon size
  final double iconSize;
}

class ThemeBuilderHelper {
  ThemeBuilderHelper._();

  /// Build a full ThemeData
  static ThemeData buildTheme({
    required Brightness brightness,
    Color? primaryColor,
    Color? secondaryColor,
    Color? scaffoldBackgroundColor,
    Color? cardColor,
    Color? buttonColor,
    Color? textColor,
    Color? hintColor,
    Color? errorColor,
    InputDecorationTheme? inputDecorationTheme,
    TextTheme? textTheme,
    AppBarTheme? appBarTheme,
    FloatingActionButtonThemeData? fabTheme,
    IconThemeData? iconTheme,
    BottomNavigationBarThemeData? bottomNavTheme,
    CheckboxThemeData? checkboxTheme,
    RadioThemeData? radioTheme,
    SwitchThemeData? switchTheme,
    SliderThemeData? sliderTheme,
    Map<String, String>? languageFonts,
    Locale? locale,
    ThemeBuilderOptions options = const ThemeBuilderOptions(),
  }) {
    final isDark = brightness == Brightness.dark;
    final fontFamily = (locale != null && languageFonts != null)
        ? languageFonts[locale.languageCode]
        : null;

    final baseTextTheme = (textTheme ??
            (isDark ? Typography.whiteMountainView : Typography.blackMountainView))
        .apply(fontFamily: fontFamily)
        .copyWith(
          titleLarge: TextStyle(
              fontWeight: FontWeight.bold, fontSize: options.bigFontSize),
          titleMedium: TextStyle(
              fontWeight: FontWeight.w600, fontSize: options.mediumFontSize),
          bodySmall: TextStyle(fontSize: options.smallFontSize),
        );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor ?? (isDark ? Colors.tealAccent : Colors.blue),
      onPrimary: textColor ?? Colors.white,
      secondary: secondaryColor ?? (isDark ? Colors.cyanAccent : Colors.orange),
      onSecondary: textColor ?? Colors.white,
      background: scaffoldBackgroundColor ?? (isDark ? Colors.black : Colors.white),
      onBackground: textColor ?? (isDark ? Colors.white : Colors.black),
      surface: cardColor ?? (isDark ? Colors.grey[800]! : Colors.white),
      onSurface: textColor ?? (isDark ? Colors.white : Colors.black),
      error: errorColor ?? Colors.red,
      onError: Colors.white,
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      hintColor: hintColor ?? Colors.grey,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      appBarTheme: appBarTheme ??
          AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            titleTextStyle: baseTextTheme.titleLarge,
          ),
      inputDecorationTheme: inputDecorationTheme ??
          InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
            contentPadding: options.inputPadding,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: options.buttonPadding,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              TextStyle(fontSize: options.mediumFontSize, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: TextStyle(fontSize: options.mediumFontSize),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(    
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ),
      floatingActionButtonTheme: fabTheme ??
          FloatingActionButtonThemeData(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
          ),
      iconTheme: iconTheme ?? IconThemeData(color: colorScheme.onBackground, size: options.iconSize),
      bottomNavigationBarTheme: bottomNavTheme ??
          BottomNavigationBarThemeData(
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
          ),
      checkboxTheme: checkboxTheme ??
          CheckboxThemeData(
            fillColor: MaterialStateProperty.all(colorScheme.primary),
          ),
      radioTheme: radioTheme ??
          RadioThemeData(
            fillColor: MaterialStateProperty.all(colorScheme.primary),
          ),
      switchTheme: switchTheme ??
          SwitchThemeData(
            thumbColor: MaterialStateProperty.all(colorScheme.primary),
            trackColor:
                MaterialStateProperty.all(colorScheme.primary.withOpacity(0.5)),
          ),
      sliderTheme: sliderTheme ??
          SliderThemeData(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
            thumbColor: colorScheme.primary,
          ),
    );
  }

  //=============================
  // UI HELPERS
  //=============================

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  static TextStyle bigLabel(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge?.copyWith(
          color: color ?? theme.colorScheme.onBackground,
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: color ?? theme.colorScheme.onBackground,
        );
  }

  static TextStyle mediumLabel(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.titleMedium?.copyWith(
          color: color ?? theme.colorScheme.onBackground,
        ) ??
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: color ?? theme.colorScheme.onBackground,
        );
  }

  static TextStyle smallLabel(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodySmall?.copyWith(
          color: color ?? theme.colorScheme.onBackground,
        ) ??
        TextStyle(
          fontSize: 14,
          color: color ?? theme.colorScheme.onBackground,
        );
  }
}
