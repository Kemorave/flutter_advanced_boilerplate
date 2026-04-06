import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/permission_helper.dart';
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

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent({super.key});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children:
              [
                    Text('Home Screen is here'),
                    Row(
                      spacing: 10,
                      children: [
                        TextButton(
                          onPressed: () => authCubit.logOut(),
                          child: Text('Logout'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              appRouter.go( homeRoute + informationRoute),
                          child: Text('Go to /home/information'),
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
                    Divider(),
                    
                    ElevatedButton(
                      onPressed: () => showSuccessSnackbar(
                        message: context.t.core.test.succeded,
                      ),
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
                      onPressed: () => showWarningSnackbar(
                        message: "context.t.core.test.warning",
                      ),
                      child: Text('Warning'),
                    ),
                    Divider (),
                    ElevatedButton(child:  Text('Photo permission (${PermissionsHelper.instance.photosPermissionState.name})'),onPressed: () async{
                    await  PermissionsHelper.instance.requestPhotos();
                    setState(() {
                    });
                    },),
                    ElevatedButton(child:  Text('Camera permission (${PermissionsHelper.instance.cameraPermissionState.name})'),onPressed: () async{
                    await  PermissionsHelper.instance.requestCamera();
                    setState(() {
                    });
                    },),
                    ElevatedButton(child:  Text('Microphone permission (${PermissionsHelper.instance.microphonePermissionState.name})', textAlign:  TextAlign.center,),onPressed: () async{
                    await  PermissionsHelper.instance.requestMicrophone();
                    setState(() {
                    });
                    },),
                    ElevatedButton(child:  Text('Storage permission (${PermissionsHelper.instance.storagePermissionState.name})'),onPressed: () async{
                    await  PermissionsHelper.instance.requestStorage();
                    setState(() {
                    });
                    },),
                    ElevatedButton(child:  Text('Location permission (${PermissionsHelper.instance.locationPermissionState.name})'),onPressed: () async{
                    await  PermissionsHelper.instance.requestLocation();
                    setState(() {
                    });
                    },),
                  ]
                  .map(
                    (e) => Center(
                      child: Padding(padding: EdgeInsets.all(8), child: e),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
