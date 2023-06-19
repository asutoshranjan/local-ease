
import 'package:flutter/material.dart';
import 'package:local_ease/widgets/customer_notif_card.dart';

import '../apis/APIs.dart';
import '../theme/app-theme.dart';
import '../theme/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Notifications"),

        title: RichText(
          text: TextSpan(
            text: 'Store ',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.black,),
            /*defining default style is optional */
            children: const <TextSpan>[
              TextSpan(
                text: 'Notifications',
                style: TextStyle(color: AppColors.pink),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: APIs.instance.getUserNotifications(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              if(snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return CustomerNotifCard(myNotif: snapshot.data![index]);
                  },
                );
              } else {
               return Padding(
                 padding: const EdgeInsets.only(left: 15),
                 child: Text(
                    "No notifications to show!",
                    style: textTheme.displayLarge!
                        .copyWith(color: AppColors.orange),
                  ),
               );
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
