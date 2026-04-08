import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:flutter_advanced_boilerplate/utils/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/theme_builder_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:statsfl/statsfl.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      // ignore: avoid_redundant_argument_values
      designSize: ScreenUtil.defaultSize,
      builder: (context, child) {
        ScreenUtil.configure(data: MediaQuery.of(context));
        return StatsFl(
          maxFps: 120,
          align: Alignment.bottomRight,
          isEnabled: env.debug,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AppCubit>()),
              BlocProvider(create: (context) => getIt<AuthCubit>()),
            ],
            child: MaterialApp.router(
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: ThemeBuilderHelper.buildTheme(
                brightness: Brightness.light,
              ),
              title: $constants.appTitle,
              debugShowCheckedModeBanner: env.debugShowCheckedModeBanner,
              debugShowMaterialGrid: env.debugShowMaterialGrid,

              /// AutoRouter configuration.
              routerConfig: appRouter,

              /// EasyLocalization configuration.
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          ),
        );
      },
    );
  }
}
