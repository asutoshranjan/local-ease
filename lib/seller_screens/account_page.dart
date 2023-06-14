import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:local_ease/auth/login_screen.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/widgets/user_card.dart';
import '../apis/APIs.dart';
import '../helpers/dialogs.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            FutureBuilder(
              future: APIs.instance.getUser(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return UserCard(myUser: snapshot.data!);
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),

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


            ElevatedButton(
              onPressed: () {
                bool clk = false ;
                Dialogs.showOpenCloseDialog(
                    context: context,
                    title: "Opening Store Now!",
                    description:
                        "Make sure you have set the store time and details correctly as this will send your subscribers a notification",
                    onBtnClk: () {
                      clk = true;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    icon: Icons.check);
                if (clk) {
                  setState(() {});
                }

              },
              child: Text("Pop Notif"),
            ),

            ElevatedButton(
              onPressed: () {
                Dialogs.showLoaderDialog(context, "Saving");

              },
              child: Text("Pop Notif 2 Save"),
            ),
          ],
        ),
      ),
    );
  }
}
