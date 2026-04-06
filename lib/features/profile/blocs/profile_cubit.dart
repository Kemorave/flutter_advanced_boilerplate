import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; 
import 'package:flutter_advanced_boilerplate/features/profile/networking/profile_repository.dart'; 

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';
 
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepository)
      : super(const ProfileState.loading());

  final ProfileRepository _profileRepository;
}
