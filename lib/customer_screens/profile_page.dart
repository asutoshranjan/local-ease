import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/theme/colors.dart';

import '../auth/login_screen.dart';
import '../utils/credentials.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Databases databases = Databases(client);

  String databaseId = Credentials.DatabaseId;
  String collectionId = Credentials.ShopsCollectionId;
  late RealtimeSubscription subscription;


  void subscribe() {
    final realtime = Realtime(client);

    subscription = realtime.subscribe(
        ['databases.$databaseId.collections.$collectionId.documents']);

    // listen to changes
    subscription.stream.listen((data) {
      log("there is some change");
      // data will consist of `events` and a `payload`
      if (data.payload.isNotEmpty) {
        log("there is some change");
        if (data.events
            .contains("databases.*.collections.*.documents.*.create")) {
          var item = data.payload;
          log("Item Added");
          //items.add(item);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.delete")) {
          var item = data.payload;
          log("item deleted");
          //items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.update")) {
          var item = data.payload;
          log("item update");
         // int idx = items.indexWhere((it) => it['\$id'] == item['\$id']);
          // log("${idx} is the index");
          // items[idx] = item;
          // setState(() {});
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
        title: Text("LocalEase Profile"),
        actions: [
          IconButton(
            onPressed: () {

              APIs.instance.logout();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Logged Out')));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );



            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // FutureBuilder(
            //   future: databases.getDocument(
            //     databaseId: Credentials.DatabaseId,
            //     collectionId: Credentials.UsersCollectonId,
            //     documentId: '647766be1f5b8da450ae',
            //   ),
            //   builder: (context, snapshot) {
            //     return snapshot.hasData && snapshot.data != null
            //         ? ListTile(
            //             leading: Text(snapshot.data!.data['name'].toString()),
            //             // title: Text(snapshot.data!.data['following'].toString()),
            //             trailing:
            //                 Text(snapshot.data!.data['notifications'].toString()),
            //           )
            //         : Center(child: CircularProgressIndicator());
            //   },
            // ),


            FutureBuilder(
              future: APIs.account.get(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!.name,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            snapshot.data!.email,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            snapshot.data!.$id,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),


            // DefaultTabController(
            //   length: 2,
            //   child: Container(
            //     width: 400,
            //     height: 500,
            //     child: Scaffold(
            //       appBar: AppBar(
            //         bottom: PreferredSize(
            //           preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            //           child: Container(
            //             height: 50,
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 20,
            //               vertical: 5,
            //             ),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(
            //                   10,
            //                 ),
            //                 color: AppColors.tabGrey,
            //               ),
            //               child: TabBar(
            //                 labelColor: AppColors.white,
            //                 unselectedLabelColor: AppColors.grey,
            //                 indicator: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(
            //                     10,
            //                   ),
            //                   color: AppColors.tabPink,
            //                 ),
            //                 tabs: const [
            //                   Tab(
            //                     text: 'Manage Addresses',
            //                   ),
            //                   Tab(
            //                     text: 'Edit Profile',
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       body: const TabBarView(
            //         children: [
            //           Center(
            //             child: Text(
            //               'Basic Settings',
            //               style: TextStyle(
            //                 fontSize: 30,
            //               ),
            //             ),
            //           ),
            //           Center(
            //             child: Text(
            //               'Advanced Settings',
            //               style: TextStyle(
            //                 fontSize: 30,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),


          ],
        ),
      ),
    );
  }
}
