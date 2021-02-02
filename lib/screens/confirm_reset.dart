import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class ConfirmResetScreen extends StatefulWidget {
  final LoginData data;

  ConfirmResetScreen({@required this.data});

  @override
  _ConfirmResetScreenState createState() => _ConfirmResetScreenState();
}

class _ConfirmResetScreenState extends State<ConfirmResetScreen> {
  final _controller = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
    _newPasswordController.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  void _resetPassword(BuildContext context, LoginData data, String code,
      String password) async {
    try {
      final res = await Amplify.Auth.confirmPassword(
        username: data.name,
        newPassword: password,
        confirmationCode: code,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password changed successfully. Please log in',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );

      Navigator.of(context).pushReplacementNamed('/');
    } on AuthError catch (e) {
      for (final err in e.exceptionList) {
        if (err.exception == 'CODE_MISMATCH') {
          _showError(context, err.detail);
          return null;
        }
      }

      _showError(context, e.cause);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.all(30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Enter new password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Enter confirmation code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        onPressed: _isEnabled
                            ? () {
                                _resetPassword(
                                  context,
                                  widget.data,
                                  _controller.text,
                                  _newPasswordController.text,
                                );
                              }
                            : null,
                        elevation: 4,
                        color: Theme.of(context).primaryColor,
                        disabledColor: Colors.deepPurple.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          'RESET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
