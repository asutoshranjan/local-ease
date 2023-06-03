import 'package:flutter/material.dart';
import 'package:local_ease/auth/login_screen.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';

import '../../apis/APIs.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String? name;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signing you up...')));
                try {
                  await APIs.instance.signUpEmailPassword(
                    email!,
                    password!,
                    name!,
                  ).then((result) {
                    if(result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New Account Created..')));
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
              child: Text("Sign Up"),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
