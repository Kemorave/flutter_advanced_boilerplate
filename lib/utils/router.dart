import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/app_wrapper.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/presentation/login_screen.dart';
import 'package:flutter_advanced_boilerplate/features/home/presentation/home_screen.dart';
import 'package:flutter_advanced_boilerplate/features/profile/presentation/profile_screen.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
 
const String homeRoute = '/home';
const String profileRoute = '/profile';
const String loginRoute = '/login';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<StatefulNavigationShellState> rootShellKey =
    GlobalKey<StatefulNavigationShellState>();

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

GoRouter initGoRouter() => GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [SentryNavigatorObserver()],
  initialLocation: loginRoute,
  routes: [
    
    GoRoute(path: loginRoute, builder: (context, state) => const LoginScreen()),
    _buildHomeShell(),
  ],
  redirect: (context, state) async {
     
    // Using `of` method creates a dependency of StreamAuthScope. It will
    // cause go_router to reparse current route if StreamAuth has new sign-in
    // information.
    final loggedIn = await context.read<AuthCubit>().isAuthenticated();
    final loggingIn = state.matchedLocation == loginRoute;
    if (!loggedIn) {
      return loginRoute;
    }

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggingIn) {
      return homeRoute;
    }

    // no need to redirect at all
    return null;
  },
);

StatefulShellRoute _buildHomeShell() => StatefulShellRoute.indexedStack(
  key: rootShellKey,
  builder: (context, state, navigationShell) {
    return AppWrapper(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: homeRoute,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: profileRoute,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

void showSnackbar({
  Widget? content,
  String? title,
  String? message,
  Widget? icon,
  Color? titleColor,
  Color? messageColor,
  AnimationStyle? animationStyle,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  double? width,
  ShapeBorder? shape,
  HitTestBehavior? hitTestBehavior,
  SnackBarBehavior? behavior,
  SnackBarAction? action,
  double? actionOverflowThreshold,
  bool? showCloseIcon,
  Color? closeIconColor,
  Duration duration = const Duration(seconds: 4),
  bool? persist,
  Animation<double>? animation,
  void Function()? onVisible,
  DismissDirection? dismissDirection,
  Clip clipBehavior = Clip.hardEdge,
}) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      hitTestBehavior: hitTestBehavior,
      behavior: behavior,
      action: action,
      actionOverflowThreshold: actionOverflowThreshold,
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor,
      duration: duration,
      persist: persist,
      animation: animation,
      onVisible: onVisible,
      dismissDirection: dismissDirection,
      clipBehavior: clipBehavior,
      content:
          content ??
          Row(
            children: [
              if (icon != null) ...[icon, 10.horizontalSpace],
              Column(
                children: [
                  if (title != null) ...[
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                  ],
                  if (message != null)
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: messageColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
    ),
    snackBarAnimationStyle: animationStyle,
  );
}

/// Shows an error snackbar with predefined error styling
void showErrorSnackbar({
  required String message,
  String? title = 'Error',
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  showSnackbar(
    title: title,
    message: message,
    backgroundColor: const Color(0xFFE53935),
    titleColor: Colors.white,
    messageColor: Colors.white,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    icon: const Icon(Icons.error_outline, color: Colors.white),
    duration: duration,
    action: action,
  );
}

/// Shows a success snackbar with predefined success styling
void showSuccessSnackbar({
  required String message,
  String? title = 'Success',
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  showSnackbar(
    title: title,
    message: message,
    backgroundColor: const Color(0xFF43A047),
    titleColor: Colors.white,
    messageColor: Colors.white,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    duration: duration,
    action: action,
  );
}

/// Shows an info snackbar with predefined info styling
void showInfoSnackbar({
  required String message,
  String? title = 'Info',
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  showSnackbar(
    title: title,
    message: message,
    backgroundColor: const Color(0xFF1E88E5),
    titleColor: Colors.white,
    messageColor: Colors.white,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    icon: const Icon(Icons.info_outline, color: Colors.white),
    duration: duration,
    action: action,
  );
}

/// Shows a warning snackbar with predefined warning styling
void showWarningSnackbar({
  required String message,
  String? title = 'Warning',
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  showSnackbar(
    title: title,
    message: message,
    backgroundColor: const Color(0xFFFB8C00),
    titleColor: Colors.white,
    messageColor: Colors.white,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    icon: const Icon(Icons.warning_outlined, color: Colors.white),
    duration: duration,
    action: action,
  );
}
