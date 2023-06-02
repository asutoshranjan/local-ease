import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../main.dart';
import '../utils/credentials.dart';

class SellerAccountPage extends StatefulWidget {
  const SellerAccountPage({Key? key}) : super(key: key);

  @override
  State<SellerAccountPage> createState() => _SellerAccountPageState();
}

class _SellerAccountPageState extends State<SellerAccountPage> {
  Databases databases = Databases(client);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppName Profile"),
      ),
      body: Column(
        children: [
          const Text("Your Account Information"),
          FutureBuilder(
            future: databases.getDocument(
              databaseId: Credentials.DatabaseId,
              collectionId: Credentials.UsersCollectonId,
              documentId: '647766be1f5b8da450ae',
            ),
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data != null
                  ? ListTile(
                      leading: Text(snapshot.data!.data['name'].toString()),
                      // title: Text(snapshot.data!.data['following'].toString()),
                      trailing:
                          Text(snapshot.data!.data['notifications'].toString()),
                    )
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
