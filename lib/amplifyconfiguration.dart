const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "2e7db0df97554738a039ddd3f25c80ef",
                    "region": "eu-central-1"
                },
                "pinpointTargeting": {
                    "region": "eu-central-1"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "eu-central-1:339b38d6-d25d-4636-a672-026441bd0eae",
                            "Region": "eu-central-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-central-1_L6vgPDiRM",
                        "AppClientId": "7q3rgoir9g66vs92lr4da7roo0",
                        "AppClientSecret": "1bdvkqnv0nbt61i732ohkug9fu1for4b175fb292ive9ebkdch4c",
                        "Region": "eu-central-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "2e7db0df97554738a039ddd3f25c80ef",
                        "Region": "eu-central-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "eu-central-1"
                    }
                }
            }
        }
    }
}''';