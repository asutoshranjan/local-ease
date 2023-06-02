import 'package:flutter/material.dart';

class SubscribedPage extends StatefulWidget {
  const SubscribedPage({Key? key}) : super(key: key);

  @override
  State<SubscribedPage> createState() => _SubscribedPageState();
}

class _SubscribedPageState extends State<SubscribedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Favorite Picks"),
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
