import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/utils/credentials.dart';

enum Event { increment, decrement }

 class storesController {
  late List<Map<String, dynamic>> items;

  Databases databases = Databases(client);

  String databaseId = Credentials.DatabaseId;
  String collectionId = Credentials.ShopsCollectionId;
  late RealtimeSubscription subscription;

  // this will handle the change the change in value of Stores
 final StreamController StoresController = StreamController();
  StreamSink get StoresSink => StoresController.sink;
  Stream get StoresStream => StoresController.stream;

  final StreamController<Event> _eventController = StreamController<Event>();
  StreamSink<Event> get eventSink => _eventController.sink;
  Stream<Event> get eventStream => _eventController.stream;

  // NOTE: here we will use listener to listen the _eventController
  StreamSubscription? listener;
  storesController() {
    loadItems();

    final realtime = Realtime(client);

    subscription = realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents'
    ]);

    // listen to changes
    listener = subscription.stream.listen((data) {
      log("there is some change");
      if (data.events.contains("databases.*.collections.*.documents.*.create")) {
        var item = data.payload;
        log("Item Added");
        items.add(item);
      } else if (data.events.contains("databases.*.collections.*.documents.*.delete")) {
        var item = data.payload;
        log("item deleted");
        items.removeWhere((it) => it['\$id'] == item['\$id']);
      } else if (data.events.contains("databases.*.collections.*.documents.*.update")) {
        var item = data.payload;
        log("item update");
        int idx = items.indexWhere((it) => it['\$id'] == item['\$id']);
        log("$idx is the index");
        items[idx] = item;
      }
      StoresSink.add(items);
    }
    );
  }


  loadItems() async {
    try {
      await databases.listDocuments(databaseId: databaseId,collectionId: collectionId).then((value) {
        var currentDocs = value.documents;
        items = currentDocs.map((e) => e.data).toList();
        StoresSink.add(items);
      });

      for (var i in items) {
        log(i.toString());
      }

    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
  }




  // dispose the listener to eliminate memory leak
  dispose() {
    listener?.cancel();
    StoresController.close();
    _eventController.close();
  }
}