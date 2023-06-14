import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/widgets/cards.dart';

import '../widgets/subscribed_card.dart';

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
      body: FutureBuilder(
        future: APIs.instance.getSubscribedStore(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData ) {
              // Extracting data from snapshot object
              final data = snapshot.data as List<ShopModel>;
              if(data.isNotEmpty) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return MySubscriptionCard(current_obj:  data[index].toJson(),);
                    }
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text("You haven't subscribed to store yet!", style: textTheme.titleMedium!.copyWith( fontSize: 18, color: AppColors.orange),),
                );
              }

            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
