import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
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
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }

      return '${e.message} - ${e.recoverySuggestion}';
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
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
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
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
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
