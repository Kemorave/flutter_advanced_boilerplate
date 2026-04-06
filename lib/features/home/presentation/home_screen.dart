import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_boilerplate/features/home/blocs/home_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {

    return   Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize:  MainAxisSize.min,
        children: [
          Text('Home Screen'),
          ElevatedButton(
            onPressed: ()=>authCubit.logOut(),
            child: Text('Logout'),
          ),
          Builder(
            builder: (context) {

        final t = Translations.of(context);
                print(t.core.file_picker.no_permission);
              return DropdownButton (
                items: [
                  ...appCubit.getSupportedLocales().map((e) => DropdownMenuItem(value: e.languageCode, child: Text(e.languageCode)))
                ],
                onChanged: (value) {
                   appCubit.setCurrentLanguage(AppLocale.values.firstWhere((element) => element.languageCode == value!));
              
                },
                value: appCubit.getCurrentLanguage().languageCode,
              );
            },
          )
        ],
      )),
    );
  }
}
