import 'package:flutter/material.dart';

import '../helpers/dateTimeHelper.dart';
import '../models/user_model.dart';
import '../theme/app-theme.dart';
import '../theme/colors.dart';
import '../utils/sizeConfig.dart';

class SubscriberViewCard extends StatefulWidget {
  final MyUserModel myUser;
  const SubscriberViewCard({Key? key, required this.myUser}) : super(key: key);

  @override
  State<SubscriberViewCard> createState() => _SubscriberViewCardState();
}

class _SubscriberViewCardState extends State<SubscriberViewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.safeBlockVertical! * 13.5,
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: SizeConfig.safeBlockHorizontal! * 16,
              height: SizeConfig.safeBlockHorizontal! * 16,
              decoration: BoxDecoration(
                color: AppColors.tabGrey,
                borderRadius:
                BorderRadius.circular(SizeConfig.safeBlockHorizontal! * 8),
              ),
              child: Image.network(
                widget.myUser.photo!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 13,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.myUser.name!, style: textTheme.titleMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.7), maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(widget.myUser.email!, style: textTheme.displaySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text( "Created on: ${DateTimeHelper.utcFormatDate(widget.myUser.createdAt!)}", style: textTheme.displaySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
