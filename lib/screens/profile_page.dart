import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/utils/credentials.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Databases databases = Databases(client);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LocalEase Profile"),
      ),
      body: FutureBuilder(
        future: databases.getDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.UsersCollectonId,
            documentId: '647766be1f5b8da450ae',
        ),

        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null
              ?  ListTile(
                  leading: Text(snapshot.data!.data['name'].toString()),
                  // title: Text(snapshot.data!.data['following'].toString()),
                  trailing: Text(snapshot.data!.data['notifications'].toString()),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
