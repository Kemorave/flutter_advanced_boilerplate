import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/profile/blocs/profile_cubit.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/d_i_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_boilerplate/features/profile/blocs/profile_cubit.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}
