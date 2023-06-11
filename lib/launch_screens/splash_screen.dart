import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/customer_screens/home_page.dart';
import 'package:local_ease/launch_screens/choose_account_type.dart';
import 'package:local_ease/seller_screens/home_page.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

import '../auth/login_screen.dart';
import '../utils/sizeConfig.dart';

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
      getUserStatus();
    });
  }


  void getUserStatus() async {
    await APIs.instance.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {

        APIs.instance.getUser().then((currentUser) {
          if (currentUser == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ChooseAccountType(),
              ),
            );
          } else if (currentUser.type == "Consumer") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          } else if (currentUser.type == "Seller") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const SellerHomePage(),
              ),
            );
          }
        });

      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(),

            Column(
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

            Padding(
              padding:  EdgeInsets.only(bottom: 15),
              child: Text("#Built with Appwrite"),
            ),

          ],
        ),
      ),
    );
  }
}
