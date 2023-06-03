import 'package:flutter/material.dart';
import 'package:local_ease/auth/signup_screen.dart';
import 'package:local_ease/helpers/dialogs.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';

import '../../apis/APIs.dart';
import '../widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? email;
  String? password;
  bool obscureText = true;

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
            TextFieldInput(
              title: 'Email',
              hintText: 'Email',
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            const SizedBox(
              height: 25,
            ),
            TextFieldInput(
              title: 'Password',
              hintText: 'Password',
              obscureText: obscureText,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                Dialogs.showSnackbar(context, 'Logging in...');
                try {
                  await APIs.instance.loginEmailPassword(
                    email!,
                    password!,
                  ).then((result) {
                    if(result) {
                      Dialogs.showSnackbar(context, 'Logged in!');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChooseAccountType(),
                        ),
                      );
                    }
                  });
                } catch (e) {
                  Dialogs.showSnackbar(context, e.toString());
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
