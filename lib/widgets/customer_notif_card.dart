import 'package:flutter/material.dart';
import 'package:local_ease/models/notification.model.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/theme/app-theme.dart';

import '../apis/APIs.dart';
import '../customer_screens/full_shop_page.dart';
import '../theme/colors.dart';
import '../utils/sizeConfig.dart';

class CustomerNotifCard extends StatefulWidget {
  final NotificationModel myNotif;
  const CustomerNotifCard({Key? key, required this.myNotif}) : super(key: key);

  @override
  State<CustomerNotifCard> createState() => _CustomerNotifCardState();
}

class _CustomerNotifCardState extends State<CustomerNotifCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
      child: Container(
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
              width: SizeConfig.safeBlockHorizontal! *60,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.myNotif.title ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.titleMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.2, color: AppColors.orange),),
                    Text(widget.myNotif.description ?? "",maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.displayMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 3.8,),),
                    Spacer(),
                    FutureBuilder(
                      future: APIs.instance.getStoreById(widget.myNotif.shopid!),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data != null) {
                            ShopModel myShop = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullShopViewPage(
                                        current_obj: myShop.toJson(),
                                      ),
                                    ));
                              },
                              child: Container(
                                width:  SizeConfig.safeBlockHorizontal! *50,
                                decoration: BoxDecoration(
                                  color: AppColors.tabGrey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            height: SizeConfig.safeBlockVertical! * 3.6,
                                            width: SizeConfig.safeBlockVertical! * 3.6,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical! * 1.8,),
                                              color: AppColors.white,
                                            ),
                                            child: Image.network(myShop.photo!, fit: BoxFit.cover,),
                                          ),
                                          const SizedBox(width: 6,),
                                          Container(
                                            width: SizeConfig.safeBlockHorizontal! *40,
                                            child: Text(myShop.name!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        return SizedBox();
                      },
                    ),

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
      ),
    );
  }
}
