import 'package:amp_awesome/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthUser _user;

  @override
  void initState() {
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
    }).catchError((error) {
      print((error as AuthError).cause);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () async {
              try {
                Amplify.Auth.signOut();
                Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
              } on AuthError catch (e) {
                print(e);
              }
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_user == null)
                Text(
                  'Loading...',
                )
              else ...[
                Text(
                  'Hello 👋🏾',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(_user.username),
                SizedBox(height: 10),
                Text(_user.userId),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
