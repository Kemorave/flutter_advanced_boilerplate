part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _HomeLoadingState;
  const factory HomeState.failed({required AlertModel alert}) = _HomeFailedState;
}
