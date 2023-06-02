import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/theme/colors.dart';
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
      body: Column(
        children: [
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


          DefaultTabController(
            length: 2,
            child: Container(
              width: 400,
              height: 500,
              child: Scaffold(
                appBar: AppBar(
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: AppColors.tabGrey,
                        ),
                        child: TabBar(
                          labelColor: AppColors.white,
                          unselectedLabelColor: AppColors.grey,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: AppColors.tabPink,
                          ),
                          tabs: const [
                            Tab(
                              text: 'Manage Addresses',
                            ),
                            Tab(
                              text: 'Edit Profile',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: const TabBarView(
                  children: [
                    Center(
                      child: Text(
                        'Basic Settings',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Advanced Settings',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
