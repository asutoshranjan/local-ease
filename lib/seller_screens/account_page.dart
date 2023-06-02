import 'package:flutter/material.dart';

class SellerAccountPage extends StatefulWidget {
  const SellerAccountPage({Key? key}) : super(key: key);

  @override
  State<SellerAccountPage> createState() => _SellerAccountPageState();
}

class _SellerAccountPageState extends State<SellerAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppName Profile"),
      ),
      body: Column(
        children: [
          Text("Subscribed"),
          ElevatedButton(onPressed: (){}, child: Text("View Subscription")),
        ],
      ),
    );
  }
}
