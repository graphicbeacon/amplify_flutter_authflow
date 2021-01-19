import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData _data;
  bool _isSignedIn = false;

  Future<String> _onLogin(LoginData data) async {
    try {
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
    } on AuthError catch (e) {
      for (final err in e.exceptionList) {
        if (err.exception == 'NOT_AUTHORIZED') {
          return err.detail;
        }

        if (err.exception == 'INVALID_STATE') {
          if (err.detail.contains('already a user which is signed in')) {
            await Amplify.Auth.signOut();
            return 'Problem logging in. Please try again.';
          }

          return err.detail;
        }
      }

      return 'There was a problem signing up. Please try again.';
    }
  }

  Future<String> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthError catch (e) {
      for (final err in e.exceptionList) {
        if (err.exception == 'INVALID_PARAMETER') {
          return err.detail;
        }
      }
      return e.cause;
    }
  }

  Future<String> _onSignup(LoginData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );

      _data = data;
    } on AuthError catch (e) {
      for (final err in e.exceptionList) {
        if (err.exception == 'USERNAME_EXISTS') {
          return err.detail;
        }
      }

      return 'There was a problem signing up. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Welcome',
      onLogin: _onLogin,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSignup: _onSignup,
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
          _isSignedIn ? '/dashboard' : '/confirm',
          arguments: _data,
        );
      },
    );
  }
}
