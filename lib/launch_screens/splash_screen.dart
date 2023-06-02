import 'package:flutter/material.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () async {
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChooseAccountType(),
              ),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Local',
                  style: textTheme.titleLarge!.copyWith(
                      fontSize: 32,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600),
                  /*defining default style is optional */
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Ease',
                      style: TextStyle(color: AppColors.pink),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              color: AppColors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
