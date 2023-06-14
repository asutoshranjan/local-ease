import 'package:flutter/material.dart';
import 'package:local_ease/models/notification.model.dart';
import 'package:local_ease/theme/app-theme.dart';

import '../theme/colors.dart';
import '../utils/sizeConfig.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel myNotif;
  const NotificationCard({Key? key, required this.myNotif}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal! * 90,
      height:  SizeConfig.safeBlockVertical! * 18,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 12,
            color: Color.fromRGBO(0, 0, 0, 0.13),
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.safeBlockHorizontal! *55,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(widget.myNotif.title ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.titleMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.8, color: AppColors.orange),),
                  SizedBox(height: 3),
                  Text(widget.myNotif.description ?? "",maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.displayMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.2,),)
                ],
              ),
            ),
          ),
          Container(
            foregroundDecoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white,
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0, 1],
              ),
            ),
            width: SizeConfig.safeBlockHorizontal! *32,
            height:  SizeConfig.safeBlockVertical! * 18,
            color: AppColors.white,
            child: Image.network('https://shorturl.at/yzHZ0', fit: BoxFit.cover,),
          ),
        ],
      ),
    );
  }
}

