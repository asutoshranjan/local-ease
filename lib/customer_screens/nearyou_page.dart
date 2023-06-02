
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/customer_screens/notification_page.dart';
import 'package:local_ease/main.dart';
import 'package:appwrite/appwrite.dart';
import 'package:local_ease/utils/credentials.dart';

import '../widgets/cards.dart';

class NearYouPage extends StatefulWidget {
  const NearYouPage({Key? key}) : super(key: key);

  @override
  State<NearYouPage> createState() => _NearYouPageState();
}

class _NearYouPageState extends State<NearYouPage> {
  Databases databases = Databases(client);

  String databaseId = Credentials.DatabaseId;
  String collectionId = Credentials.ShopsCollectionId;
  late RealtimeSubscription subscription;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
    subscribe();
  }



  loadItems() async {
    try {
      await databases.listDocuments(databaseId: databaseId,collectionId: collectionId).then((value) {
        var currentDocs = value.documents;
        setState(() {
          items = currentDocs.map((e) => e.data).toList();
        });
      });

      for (var i in items) {
        log(i.toString());
      }

    } on AppwriteException catch (e) {
      print(e.message);
    }
  }




  void subscribe() {
    final realtime = Realtime(client);

    subscription = realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents'
    ]);

    // listen to changes
    subscription.stream.listen((data) {
      log("there is some change");
      // data will consist of `events` and a `payload`
      if (data.payload.isNotEmpty) {
        log("there is some change");
        if (data.events.contains("databases.*.collections.*.documents.*.create")) {
          var item = data.payload;
          log("Item Added");
            items.add(item);
            setState(() {});
        } else if (data.events.contains("databases.*.collections.*.documents.*.delete")) {
          var item = data.payload;
          log("item deleted");
          items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        } else if (data.events.contains("databases.*.collections.*.documents.*.update")) {
          var item = data.payload;
          log("item update");
          int idx = items.indexWhere((it) => it['\$id'] == item['\$id']);
          log("${idx} is the index");
          items[idx] = item;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    subscription.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ));
            },
            icon: const Icon(CupertinoIcons.bell),
          ),
        ],
      ),



      body:  ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> current_obj = items[index];
            return MyCards(name: current_obj['name'], about: current_obj['about']);
          }),


    );
  }
}
