import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/utils/credentials.dart';


Client client = Client();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  client.setEndpoint(Credentials.APIEndpoint).setProject(Credentials.ProjectID).setSelfSigned(status: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocalEase',
      theme: AppTheme.lightTheme,
      home: ChooseAccountType(),
    );
  }
}

