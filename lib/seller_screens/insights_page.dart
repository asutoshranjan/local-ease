import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({Key? key}) : super(key: key);

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helpful Insights"),
      ),
      body: Column(
        children: [
          Text("128 Subscribed have subscribed to "),
          ElevatedButton(onPressed: (){}, child: Text("View Subscription")),
        ],
      ),
    );
  }
}
