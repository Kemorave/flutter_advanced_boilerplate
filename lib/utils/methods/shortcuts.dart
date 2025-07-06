import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/bar_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/permission_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/file_type_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_theme/json_theme.dart';

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double getStatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double getSliverBarHeight(BuildContext context) {
  return getStatusBarHeight(context) + kToolbarHeight;
}

double getAppBarHeight() {
  return AppBar().preferredSize.height;
}

double getBottomBarHeight() {
  return kBottomNavigationBarHeight;
}

ColorScheme getTheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

ColorScheme getPrimaryContainer(BuildContext context) {
  return Theme.of(context).colorScheme;
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

ThemeData getCurrentTheme(BuildContext context) {
  return Theme.of(context);
}

Color getPrimaryColor(BuildContext context) {
  return getTheme(context).primary;
}

Color getCustomOnPrimaryColor(BuildContext context) {
  return getTheme(context).primary.withOpacity(0.5);
/*   return ElevationOverlay.colorWithOverlay(
    getTheme(context).primary,
    getTheme(context).background,
    isDarkMode(context) ? 1000 : 500,
  ); */
}

String colorToHex(Color c) {
  return "#${(c.value.toRadixString(16))..padLeft(8, '0').toUpperCase()}";
}

Color hexToColor(String h) {
  return Color(int.parse(h, radix: 16));
}

LinearGradient colorsToGradient(List<Color> colors, {double opacity = 1}) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: colors.map((c) => c.withOpacity(opacity)).toList(),
  );
}

/// Generate app theme data with default values
ThemeData _generateThemeData(ThemeData theme) {
  return theme.copyWith(
    appBarTheme: theme.appBarTheme.copyWith(
      titleTextStyle:
          theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 25),
        ),
        textStyle: WidgetStatePropertyAll(
          theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: theme.outlinedButtonTheme.style?.copyWith(
        minimumSize: const WidgetStatePropertyAll(Size(200, 40)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 25),
        ),
        textStyle: WidgetStatePropertyAll(
          theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    ),
  );
}

Future<ThemeData?> loadThemeData(String themePath) async {
  try {
    final themeStr = await rootBundle.loadString(themePath);
    final themeJson = json.decode(themeStr);
    final theme = ThemeDecoder.decodeThemeData(
      themeJson,
      validate: false,
    )!;
    return _generateThemeData(
      theme.copyWith(textTheme: theme.textTheme),
    );
  } catch (e) {
    return null;
  }
}

Future<List<XFile>> selectMedia(
  BuildContext context,
  ImageSource source, {
  bool video = false,
}) async {
  final hasPermission = await checkPhotosPermission();
  final picker = ImagePicker();
  if (hasPermission) {
    switch (source) {
      case ImageSource.camera:
        final file = video
            ? await picker.pickVideo(
                source: source,
                maxDuration: 10.seconds,
              )
            : await picker.pickImage(source: source, imageQuality: 25);
        if (file == null) {
          return <XFile>[];
        }
        return [file];
      case ImageSource.gallery:
        final files = await picker.pickMultipleMedia(
          imageQuality: 25,
          limit: 20,
        );
        if (files.isEmpty) {
          return [];
        }
        final tasks = <XFile>[];
        for (final file in files) {
          if (file.path.fileType == FileType.other && context.mounted) {
            BarHelper.showAlert(
              context,
              alert: const AlertModel(
                message: 'يسمح برفع الصور والفيديو و الصوت فقط',
                type: AlertType.destructive,
              ),
            );
            continue;
          }
          final sizeInBytes = await file.length();
          final sizeInMb = sizeInBytes / (1024 * 1024);

          if (sizeInMb > 50 && context.mounted) {
            BarHelper.showAlert(
              context,
              alert: AlertModel(
                message: context.t.core.file_picker.size_warning(maxSize: 50),
                type: AlertType.destructive,
              ),
            );
            continue;
          }

          tasks.add(file);
        }

        return tasks;
    }
  } else if (context.mounted) {
    BarHelper.showAlert(
      context,
      alert: AlertModel(
        message: context.t.core.file_picker.no_permission,
        type: AlertType.destructive,
      ),
    );
  }
  return [];
}
