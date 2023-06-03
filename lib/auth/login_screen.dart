import 'package:flutter/material.dart';
import 'package:local_ease/auth/signup_screen.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';

import '../../apis/APIs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging in...')));
                try {
                  await APIs.instance.loginEmailPassword(
                    email!,
                    password!,
                  ).then((result) {
                    if(result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in')));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChooseAccountType(),
                        ),
                      );
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
                }
              },
              child: Text("Login"),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignUpPage(),
                  ),
                );
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
