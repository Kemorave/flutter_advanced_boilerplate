import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
        
          children: [
            Text('Home Screen is here'),
            Row(
              children: [
                FilledButton(
                  onPressed: () => authCubit.logOut(),
                  child: Text('Logout'),
                ),
                FilledButton(
                  onPressed: () =>  appRouter.go(homeRoute + informationRoute),
                  child: Text('Information'),
                )
              ],
            ),
            Builder(
              builder: (context) {
                final t = Translations.of(context);
                print(t.core.file_picker.no_permission);
                return DropdownButton(
                  items: [
                    ...appCubit.getSupportedLocales().map(
                      (e) => DropdownMenuItem(
                        value: e.languageCode,
                        child: Text(e.languageCode),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    appCubit.setCurrentLanguage(
                      AppLocale.values.firstWhere(
                        (element) => element.languageCode == value!,
                      ),
                    );
                  },
                  value: appCubit.getCurrentLanguage().languageCode,
                );
              },
            ),
          ElevatedButton(
            onPressed: () => showSuccessSnackbar(message: context.t.core.test.succeded),
            child: Text('Success'),
          ),
          ElevatedButton(
                      onPressed: () => showErrorSnackbar(
                        message: context.t.core.test.failed,
                      ),
                      child: Text('Error'),
                    ),
           ElevatedButton(
                      onPressed: () =>
                          showInfoSnackbar(message: "context.t.core.test.info"),
                      child: Text('Info'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          showWarningSnackbar(message: "context.t.core.test.warning"),
                      child: Text('Warning'),
                    ),
          
          ].map((e) => Center(child: Padding(padding: EdgeInsets.all(8), child: e))).toList(),
        ),
      ),
    );
  }
}
