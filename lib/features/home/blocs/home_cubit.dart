import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/home/networking/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';
 
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepository)
      : super(const HomeState.loading());

  final HomeRepository _homeRepository;
}
