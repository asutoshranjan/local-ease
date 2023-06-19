import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/customer_screens/home_page.dart';
import 'package:local_ease/seller_screens/home_page.dart';

class ChooseAccountType extends StatefulWidget {
  const ChooseAccountType({Key? key}) : super(key: key);

  @override
  State<ChooseAccountType> createState() => _ChooseAccountTypeState();
}

class _ChooseAccountTypeState extends State<ChooseAccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tell Us About You"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () async{
                   await APIs.instance.createUser(type: "Consumer").then((value) {
                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                           builder: (context) => const HomePage(),
                         ));
                   });
                },
                child: const Text("I want to search shops and items")),
            const SizedBox(height: 15,),
            ElevatedButton(
                onPressed: () async{
                    await APIs.instance.createUser(type: "Seller" ).then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellerHomePage(),
                          ));
                    });
                },
                child: const Text("I want to list my shop")),
          ],
        ),
      ),
    );
  }
}
