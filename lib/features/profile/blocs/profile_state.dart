part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = _ProfileLoadingState;
  const factory ProfileState.failed({required AlertModel alert}) = _ProfileFailedState;
}
