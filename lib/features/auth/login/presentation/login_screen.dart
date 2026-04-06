import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/utils/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/app/widgets/customs/custom_image_view.dart';
import 'package:flutter_advanced_boilerplate/features/app/widgets/utils/keyboard_dismisser.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/presentation/components/intro_widget.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, @visibleForTesting this.cubit});

  final AuthCubit? cubit;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: widget.cubit ?? context.read<AuthCubit>(),
      listener: (context, state) {
        state.maybeWhen(
          loading: () {
            setState(() => _isLoading = true);
          },
          failed: (alert) {
            setState(() => _isLoading = false);
            showErrorSnackbar(message: alert.message);
          },
          authenticated: (_) {
            _formKey.currentState?.reset();
            setState(() => _isLoading = false);

            if (widget.cubit != null) {
              showSuccessSnackbar(message: context.t.core.test.succeded);
            }
          },
          orElse: () {
            setState(() => _isLoading = false);
          },
        );
      },
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, s) {
          if (!s.introViewed) {
            return const IntroWidget();
          }
          return _buildFormWidget(context);
        },
      ),
    );
  }

  Widget _buildFormWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول')),
      body: KeyboardDismisserWidget(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: $constants.insets.md),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  FormBuilderTextField(
                    name: 'username',
                    decoration: InputDecoration(
                      labelText: context.t.core.form.username.label,
                      hintText: context.t.core.form.username.hint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${context.t.core.form.username.label} ${context.t.core.errors.form.required(field: context.t.core.form.username.label)}';
                      }
                      if (value.length < 4) {
                        return context.t.core.errors.form.minLength(
                          field: context.t.core.form.username.label,
                          count: 4,
                        );
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                  ),
                  10.verticalSpace,
                  FormBuilderTextField(
                    name: 'password',
                    decoration: InputDecoration(
                      labelText: context.t.core.form.password.label,
                      hintText: context.t.core.form.password.hint,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${context.t.core.form.password.label} ${context.t.core.errors.form.required(field: context.t.core.form.password.label)}';
                      }
                      if (value.length < 4) {
                        return context.t.core.errors.form.minLength(
                          field: context.t.core.form.password.label,
                          count: 4,
                        );
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        _handleLogin(context);
                      }
                    },
                    enabled: !_isLoading,
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : () {},
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                  SizedBox(height: $constants.insets.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                _handleLogin(context);
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.t.login.login_button),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: CustomImageView(
                        imagePath: Assets.images.handwave.path,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    final formData = _formKey.currentState?.value;
    if (formData != null) {
      context.read<AuthCubit>().login(
        username: formData['username'] as String,
        password: formData['password'] as String,
      );
    }
  }
}
