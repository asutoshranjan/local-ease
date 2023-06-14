import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_ease/helpers/dialogs.dart';
import 'package:local_ease/models/notification.model.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';
import 'package:local_ease/widgets/notification_card.dart';
import 'package:local_ease/widgets/textfields.dart';

import '../apis/APIs.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({Key? key}) : super(key: key);

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  void updateUI() {
    setState(() {
      //You can also make changes to your state here.
    });
  }

  ValueNotifier<bool> reset = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helpful Insights"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6,
            ),

            FutureBuilder(
              future: APIs.instance.getShopNotifications(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    List<NotificationModel> myNotifs = snapshot.data ?? [];
                    if (myNotifs.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        height: SizeConfig.safeBlockVertical! * 20,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 13),
                            itemCount: myNotifs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child:
                                    NotificationCard(myNotif: myNotifs[index]),
                              );
                            }),
                      );
                    } else {
                      return Text(
                        "No notifications to show!",
                        style: textTheme.displayLarge!
                            .copyWith(color: AppColors.orange),
                      );
                    }
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),

            // NotificationCard(),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    String name = "";
                    String desc = "";
                    String photo = "";

                    // passIt( NotificationModel myNotif) async {
                    //   await APIs.instance
                    //       .createNotification(myNotif)
                    //       .then((value) {
                    //     btn = true;
                    //     setState(() {});
                    //     updateUI();
                    //   });
                    //
                    // }

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        bool clk2 = false;
                        return Material(
                          child: Container(
                            color: AppColors.scaffoldBackGround,
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 20,
                                ),
                                TextFieldInput(
                                  title: 'Title',
                                  hintText: 'Enter notification title',
                                  onChanged: (val) {
                                    name = val;
                                  },
                                ),
                                Container(
                                  height: 10,
                                ),
                                TextFieldInput(
                                  title: 'Description',
                                  hintText: 'Notification description',
                                  maxLines: 4,
                                  maxLength: 200,
                                  onChanged: (val) {
                                    desc = val;
                                  },
                                ),
                                Container(
                                  height: 5,
                                ),
                                TextFieldInput(
                                  title: 'Photo Link',
                                  hintText:
                                      'Paste link of notification image here',
                                  onChanged: (val) {
                                    photo = val;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: <Widget>[
                                    Spacer(),
                                    TextButton(
                                        child: Text('Discard'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    TextButton(
                                      child: Text('Send Notification'),
                                      onPressed: () async {
                                        NotificationModel myNotif =
                                            NotificationModel(
                                          title: name,
                                          description: desc,
                                          photo: photo,
                                        );
                                        await APIs.instance
                                            .createNotification(myNotif)
                                            .then((value) {
                                          Navigator.pop(context);
                                          Dialogs.notificationSentDialog(context: context, onBtnClk: () {
                                            setState(() {});
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    reset.addListener(() {
                      log("there is change");
                      reset.value = false;
                      setState(() {});
                    });
                  },
                  child: const Text("Send Notification"),
                ),
              ],
            ),
            SizedBox(height: 6),
            FutureBuilder(
              future: APIs.instance.getSubscribedUsers(),
              builder: (context, snapshot) {
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
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as List<MyUserModel>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "${data.length} LocalEase Users",
                          style: textTheme.titleLarge!.copyWith(
                              color: AppColors.pink,
                              fontSize: SizeConfig.safeBlockHorizontal! * 5.3),
                        ),
                        Text(
                          "have subscribed to your store!",
                          style: textTheme.titleMedium!.copyWith(
                              fontSize: SizeConfig.safeBlockHorizontal! * 5),
                        ),
                        data.isNotEmpty
                            ? SizedBox(
                                height: SizeConfig.safeBlockVertical! * 45.4,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Text(data[index].name!);
                                    }),
                              )
                            : Center(
                                child: Text(
                                  "Waiting for users to join",
                                  style: textTheme.displayLarge!.copyWith(
                                      color: AppColors.orange,
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal! *
                                              4.5),
                                ),
                              )
                      ],
                    );
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
