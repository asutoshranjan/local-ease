import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/helpers/dialogs.dart';
import 'package:local_ease/main.dart';
import 'package:local_ease/models/notification.model.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:uuid/uuid.dart';

import '../auth/login_screen.dart';
import '../models/user_model.dart';
import '../theme/app-theme.dart';
import '../utils/credentials.dart';
import '../utils/sizeConfig.dart';
import '../widgets/textfields.dart';
import '../widgets/user_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController photoController = TextEditingController();

  Databases databases = Databases(client);

  String databaseId = Credentials.DatabaseId;
  String collectionId = Credentials.NotificationCollectionId;
  late RealtimeSubscription subscription;
  String? photoUrl;
  var uuid = Uuid();
  final storage = Storage(client);

  @override
  void initState() {
    super.initState();
    subscribe();
  }

  void subscribe() async {
    final myId = await APIs.instance.getUserID();

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
          var item = NotificationModel.fromJson(data.payload);
          log("Item Added");
          //items.add(item);  current as '648532544505f9fa08ea'
          if (item.users!.contains(myId)) {
            Dialogs.showNotificationDialog(context, item.title!, item.description!);
          }

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
        // title: Text("LocalEase Profile"),

        title: RichText(
          text: TextSpan(
            text: 'LocalEase ',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,),
            /*defining default style is optional */
            children: const <TextSpan>[
              TextSpan(
                text: 'Profile',
                style: TextStyle(color: AppColors.pink),
              ),
            ],
          ),
        ),
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
        physics: BouncingScrollPhysics(),
        child: Padding(
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
                      MyUserModel currentUser = snapshot.data!;
                      nameController =
                          TextEditingController(text: currentUser.name);
                      photoController =
                          TextEditingController(text: currentUser.photo);
                      photoUrl = currentUser.photo;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserCard(myUser: snapshot.data!),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 4,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.tabPink,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "Edit Profile",
                                style: textTheme.titleSmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Email: ${currentUser.email}",
                            style: textTheme.titleMedium!.copyWith(
                                fontSize:
                                SizeConfig.safeBlockHorizontal! * 4.5),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFieldInput(
                            controller: nameController,
                            title: 'Store Name',
                            hintText: 'Enter Store Name',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Photo',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),

                          photoUrl != null ? Center(
                            child: Container(
                                height: 120,
                                width: 120,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(
                                  photoUrl ?? 'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg' ,
                                  fit: BoxFit.cover,
                                )),
                          ): Text("Photo not selected yet"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tabGrey,
                            ),
                            onPressed: () async{

                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'gif'],
                              );

                              String id = uuid.v1();

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                log(file.path);
                                String fileName = result.files.single.name;

                                Future result2 = storage.createFile(
                                  bucketId: Credentials.PhotosBucketId,
                                  fileId: id,
                                  file: InputFile(
                                    path: file.path,
                                  ),
                                );

                                result2.then((response) async{
                                  log("Pic Uploaded");
                                  photoUrl = 'https://cloud.appwrite.io/v1/storage/buckets/${Credentials.PhotosBucketId}/files/${id}/view?project=${Credentials.ProjectID}';
                                  currentUser.photo = photoUrl;
                                  Dialogs.showLoaderDialog(context, "Saving Photo");
                                  await APIs.instance
                                      .updateUserInfo(currentUser)
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() {});
                                  });
                                }).catchError((error) {
                                  print(error.response);
                                  Dialogs.showSnackbar(context, "${error}");
                                });
                              } else {
                                // User canceled the picker
                                Dialogs.showSnackbar(context, "Unable to upload canceled in between");
                              }
                            },
                            child: Text("Upload Image", style: textTheme.titleSmall!.copyWith(color: AppColors.grey),),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: () async {
                                  currentUser.name = nameController.text;
                                  currentUser.photo = photoUrl;
                                  Dialogs.showLoaderDialog(context, "Saving");
                                  await APIs.instance
                                      .updateUserInfo(currentUser)
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() {});
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Text("Save Changes"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
