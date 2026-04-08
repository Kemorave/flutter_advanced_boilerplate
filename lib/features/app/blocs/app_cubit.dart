import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
// import 'package:flutter_advanced_boilerplate/assets.dart';
import 'package:flutter_advanced_boilerplate/utils/gen/assets.gen.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit() : super(AppState.initial());

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    final introViewed = json['introViewed'] as bool? ?? false;
    final themePath = json['themePath'] as String? ?? '';
    final localeCode = json['locale'] as String? ?? '';
    final locale = AppLocale.values.where((e) => e.languageCode == localeCode).firstOrNull ;
    if(locale!=null) {
      LocaleSettings.instance.setLocaleRaw(locale.languageCode);
    }
    return AppState(
      pageIndex: 0,
      introViewed: introViewed,
      themePath: themePath,
      locale: localeCode,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return <String, dynamic>{
      'themePath': state.themePath,
      'introViewed': state.introViewed,
      'locale': state.locale,
    };
  }

  void setIntroViewed({required bool introViewed}) =>
      emit(state.copyWith(introViewed: introViewed));
  void changePageIndex({required int index}) =>
      emit(state.copyWith(pageIndex: index));

  Future<void> setThemePath(
    BuildContext context, {
    required String themePath,
  }) async {
    emit(state.copyWith(themePath: themePath));
  }

   AppLocale getCurrentLanguage() {
  return  LocaleSettings.instance.currentLocale;
  }
  List<Locale> getSupportedLocales() {
    return LocaleSettings.instance.supportedLocales;
  }
  void setCurrentLanguage(AppLocale locale) {
  LocaleSettings.instance.setLocale(locale);
    emit(state.copyWith(locale: locale.languageCode));
  }
}
