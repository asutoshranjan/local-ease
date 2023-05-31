import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/screens/notification_page.dart';
import 'package:appwrite/appwrite.dart';
import 'package:local_ease/utils/credentials.dart';

class NearYouPage extends StatefulWidget {
  const NearYouPage({Key? key}) : super(key: key);

  @override
  State<NearYouPage> createState() => _NearYouPageState();
}

class _NearYouPageState extends State<NearYouPage> {
  Databases databases = Databases(client);

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
      body: FutureBuilder(
        future: databases.listDocuments(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
        ), 
        
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null
              ? ListView.builder(
                  itemCount: snapshot.data!.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> current_obj = snapshot.data!.documents[index].data;
                    return ListTile(
                        leading: Text(current_obj['name']),
                        title: Text(current_obj['about']),
                      trailing: Text(current_obj['isopen'].toString()),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
