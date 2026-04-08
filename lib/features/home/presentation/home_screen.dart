import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/home/blocs/home_cubit.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/permission_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children:
              [
                    const Text('Home Screen is here'),
                    Row(
                      spacing: 10,
                      children: [
                        TextButton(
                          onPressed: () => authCubit.logOut(),
                          child: const Text('Logout'),
                        ),
                        FilledButton(
                          onPressed: () => appRouter.go(informationRoute),
                          child: const Text('Go to /home/information'),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        Translations.of(context);
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
                    const Divider(),

                    ElevatedButton(
                      onPressed: () => showSuccessSnackbar(
                        message: context.t.core.test.succeded,
                      ),
                      child: const Text('Success'),
                    ),
                    ElevatedButton(
                      onPressed: () => showErrorSnackbar(
                        message: context.t.core.test.failed,
                      ),
                      child: const Text('Error'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          showInfoSnackbar(message: 'context.t.core.test.info'),
                      child: const Text('Info'),
                    ),
                    ElevatedButton(
                      onPressed: () => showWarningSnackbar(
                        message: 'context.t.core.test.warning',
                      ),
                      child: const Text('Warning'),
                    ),
                    const Divider(),
                    ElevatedButton(
                      child: Text(
                        'Photo permission (${PermissionsHelper.instance.photosPermissionState.name})',
                      ),
                      onPressed: () async {
                        await PermissionsHelper.instance.requestPhotos();
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Camera permission (${PermissionsHelper.instance.cameraPermissionState.name})',
                      ),
                      onPressed: () async {
                        await PermissionsHelper.instance.requestCamera();
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Microphone permission (${PermissionsHelper.instance.microphonePermissionState.name})',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        await PermissionsHelper.instance.requestMicrophone();
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Storage permission (${PermissionsHelper.instance.storagePermissionState.name})',
                      ),
                      onPressed: () async {
                        await PermissionsHelper.instance.requestStorage();
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Location permission (${PermissionsHelper.instance.locationPermissionState.name})',
                      ),
                      onPressed: () async {
                        await PermissionsHelper.instance.requestLocation();
                        setState(() {});
                      },
                    ),
                  ]
                  .map(
                    (e) => Center(
                      child: Padding(padding: const EdgeInsets.all(8), child: e),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
