import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/utils/extensions/color_extensions.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:fpdart/fpdart.dart';
import 'package:url_launcher/url_launcher.dart';

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
  return getTheme(context).primary.withOpacityFactor(0.5);
  /*   return ElevationOverlay.colorWithOverlay(
    getTheme(context).primary,
    getTheme(context).background,
    isDarkMode(context) ? 1000 : 500,
  ); */
}

String colorToHex(Color c) {
  return "#${(c.toARGB32().toRadixString(16))..padLeft(8, '0').toUpperCase()}";
}

Color hexToColor(String h) {
  return Color(int.parse(h, radix: 16));
}

LinearGradient colorsToGradient(List<Color> colors, {double opacity = 1}) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: colors.map((c) => c.withOpacityFactor(opacity)).toList(),
  );
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

typedef CustomEither<T> = Either<AlertModel, T>;

Future<CustomEither<T>> runSafe<T>(
  Future<T> Function() future, [
  AlertModel Function(Object, StackTrace)? onError,
]) async {
  return TaskEither<AlertModel, T>.tryCatch(
    () => future(),
    onError ?? (e, s) => AlertModel.exception(exception: e, stackTrace: s),
  ).run();
}

Future<CustomEither<T>> runAndReport<T>(
  Future<T> Function() future, {
  AlertModel Function(Object, StackTrace)? onError,
  bool showSnackbar = false,
}) async {
  final result = await runSafe(future, onError);
  await result.match((a) {
    if (a.type == AlertType.quiet) return Future<void>.value();

    return errorReportService.reportException(a.exception, a.stackTrace);
  }, (_) => Future<void>.value());
  return result;
}

CustomEither<T> runSafeSync<T>(
  T Function() function, [
  AlertModel Function(Object, StackTrace)? onError,
]) {
  return Either.tryCatch(
    () => function(),
    onError ?? (e, s) => AlertModel.exception(exception: e, stackTrace: s),
  );
}

CustomEither<T> runAndReportSync<T>(
  T Function() function, {
  AlertModel Function(Object, StackTrace)? onError,
  bool showSnackbar = false,
}) {
  final result = runSafeSync(function, onError)
    ..match((a) {
      if (a.type == AlertType.quiet) return;
      errorReportService.reportException(a.exception, a.stackTrace);
      if (showSnackbar) {
        switch (a.type) {
          case AlertType.destructive:
            showWarningSnackbar(message: a.message);
          case AlertType.constructive:
            showSuccessSnackbar(message: a.message);
          case AlertType.notification:
            showInfoSnackbar(message: a.message);
          case AlertType.error:
            showErrorSnackbar(message: a.message);
          case AlertType.exception:
            showErrorSnackbar(message: a.message);
          default:
        }
      }
    }, (_) => null);
  return result;
}

Future<CustomEither<bool>> openLink(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
  String? webOnlyWindowName,
}) async {
  return runAndReport(
    () => launchUrl(
      Uri.parse(url),
      mode: mode,
      webOnlyWindowName: webOnlyWindowName,
    ),
  );
}
