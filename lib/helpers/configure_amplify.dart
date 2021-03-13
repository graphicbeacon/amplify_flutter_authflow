import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';

import '../amplifyconfiguration.dart';

Future<void> configureAmplify() async {
  final auth = AmplifyAuthCognito();
  final analytics = AmplifyAnalyticsPinpoint();

  try {
    Amplify.addPlugins([auth, analytics]);

    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException catch (e) {
    print(e);
  }
}
