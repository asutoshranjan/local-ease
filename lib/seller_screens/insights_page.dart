import 'package:flutter/material.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "128 Subscribed",
              style: textTheme.titleLarge!.copyWith(color: AppColors.pink, fontSize: 22),
            ),
            Text(
              "have subscribed to your store!",
              style: textTheme.titleMedium,
            ),
            SizedBox(height: 22,),
            ElevatedButton(onPressed: (){}, child: Text("View All Subscribers")),
          ],
        ),
      ),
    );
  }
}
