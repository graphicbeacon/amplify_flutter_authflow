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

  Future<String> _onLogin(BuildContext context, LoginData data) async {
    print(data);
  }

  Future<String> _onSignup(BuildContext context, LoginData data) async {
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
      title: 'AmpAwesome',
      onLogin: (LoginData data) => _onLogin(context, data),
      onRecoverPassword: (_) => Future.value(''),
      onSignup: (LoginData data) => _onSignup(context, data),
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
          '/confirm',
          arguments: _data,
        );
      },
    );
  }
}
