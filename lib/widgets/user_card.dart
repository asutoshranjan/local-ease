import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_ease/helpers/dateTimeHelper.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/utils/sizeConfig.dart';

import '../theme/colors.dart';

class UserCard extends StatefulWidget {
  final MyUserModel myUser;
  const UserCard({Key? key, required this.myUser}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    log (widget.myUser.createdAt!);
    return Container(
      width: double.infinity,
      height: SizeConfig.safeBlockVertical! * 18,
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: SizeConfig.safeBlockHorizontal! * 20,
              height: SizeConfig.safeBlockHorizontal! * 20,
              decoration: BoxDecoration(
                color: AppColors.tabGrey,
                borderRadius:
                    BorderRadius.circular(SizeConfig.safeBlockHorizontal! * 10),
              ),
              child: Image.network(
                widget.myUser.photo!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.myUser.name!, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(widget.myUser.email!, style: textTheme.displaySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text( "Created on: ${DateTimeHelper.utcFormatDate(widget.myUser.createdAt!)}", style: textTheme.displaySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Text("Account Type: ", style: textTheme.displaySmall!.copyWith( fontSize: SizeConfig.safeBlockHorizontal! * 4.2),),
                    Text(widget.myUser.type!, style: textTheme.displaySmall!.copyWith(color: AppColors.pink, fontWeight: FontWeight.w600, fontSize: SizeConfig.safeBlockHorizontal! * 4.2, ),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
