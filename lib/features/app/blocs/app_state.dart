part of 'app_cubit.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    required int pageIndex,
    required bool introViewed,
    required String themePath,
    String? locale,
  }) = _AppState;

  factory AppState.initial() => _AppState(
        pageIndex: 0,
        introViewed: false,
        themePath: Assets.themes.defaultTheme, //Assets.defaultTheme,
      );
}
