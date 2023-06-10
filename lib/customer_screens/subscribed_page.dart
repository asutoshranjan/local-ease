import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/widgets/cards.dart';

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
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return MyCards(current_obj:  data[index].toJson());
                }
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
