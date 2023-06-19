import 'package:flutter/material.dart';
import 'package:local_ease/auth/login_screen.dart';
import 'package:local_ease/helpers/dialogs.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';
import 'package:local_ease/widgets/textfields.dart';

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
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
              height: 16,
            ),
            TextFieldInput(
              title: 'Password',
              hintText: '8 character at least',
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
              height: 16,
            ),
            TextFieldInput(
              title: 'Name',
              hintText: 'Name',
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                Dialogs.showSnackbar(context, 'Signing you up...');
                try {
                  await APIs.instance.signUpEmailPassword(
                    email!,
                    password!,
                    name!,
                  ).then((result) {
                    if(result) {
                      Dialogs.showSnackbar(context, 'New Account Created..');
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
              child: const Text("Sign Up"),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
