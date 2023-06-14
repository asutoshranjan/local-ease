import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/customer_screens/full_shop_page.dart';
import 'package:local_ease/helpers/dateTimeHelper.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';

import '../helpers/dialogs.dart';

class MyCards extends StatefulWidget {
  final String dis;
  final Map<String, dynamic> current_obj;
  const MyCards({Key? key, required this.current_obj, required this.dis}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {

  @override
  Widget build(BuildContext context) {
    List subscribers = widget.current_obj['subscribers'] ?? [];
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullShopViewPage(
                  current_obj: widget.current_obj,
                ),
              ));
        },
        child: Container(
          foregroundDecoration: widget.current_obj['isopen'] ? BoxDecoration() :BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
            borderRadius: BorderRadius.circular(15),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,

            boxShadow: [
              BoxShadow(
              offset: Offset(2, 2),
          blurRadius: 12,
          color: Color.fromRGBO(0, 0, 0, 0.16),
        )
        ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical! * 16.9,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                foregroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.5, 10],
                  ),
                ),
                decoration: const BoxDecoration(
                  color: AppColors.tabGrey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15) ),
                ),
                child: Image.network(
                  widget.current_obj['photo'] ??
                      'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: SizeConfig.safeBlockHorizontal! * 49,
                            child: Text(
                              widget.current_obj['name'],
                              style: textTheme.displayLarge!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.4, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal! * 49,
                            child: Text(
                              widget.current_obj['about'],
                              style: textTheme.displaySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal! * 49,
                            child: Row(
                              children: [
                                Icon(Icons.directions_walk, size: 18.8, color: AppColors.grey,),
                                Text("${widget.dis}", style: textTheme.titleSmall!.copyWith(color: AppColors.green, fontSize: SizeConfig.safeBlockHorizontal! * 4,),),
                                Spacer(),
                                Text("Closes: ", style: textTheme.displaySmall!.copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 3.97, color: AppColors.grey),),
                                Text(DateTimeHelper.closingTime(widget.current_obj['closes']) , style: textTheme.titleSmall!.copyWith(color: AppColors.orange, fontSize: SizeConfig.safeBlockHorizontal! * 4,),),
                              ],
                            ),
                          ),
                          Text(
                            "Items",
                            style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 65,
                            width: SizeConfig.safeBlockHorizontal! * 65,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(),
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 6.0, // gap between lines
                              children: <Widget>[
                                for (String item in widget.current_obj['items'])
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(color: AppColors.grey),
                                        color: AppColors.tabGrey,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Text(
                                        item.trim(),
                                        style: textTheme.displaySmall,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: SizeConfig.safeBlockVertical! * 2.2,
                child: FutureBuilder(
                    future: APIs.instance.getUserID(),
                    builder: (context, snapshot){
                      if(snapshot.hasData && snapshot.data != null) {
                        return subscribers.contains(snapshot.data)
                            ? TextButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.tabGrey, foregroundColor:  AppColors.grey),
                          onPressed: () {},
                          child: Text("Subscribed"),
                        )
                            : TextButton(
                          onPressed: () async {
                            Dialogs.showOpenCloseDialog(
                              context: context,
                              title: "Notifications on the go!",
                              description:
                              "Confirm that you want to subscribe ${widget.current_obj['name']} you will be get updates as notification from store",
                              onBtnClk: () async {
                                List subs =
                                widget.current_obj['subscribers'];
                                String shopId =
                                widget.current_obj['ownerid'];
                                await APIs.instance
                                    .subscribe(shopId, subs).then((value) {
                                  setState(() {});
                                  Navigator.pop(context);
                                });
                              },
                              icon: Icons.notifications_active_outlined,
                            );
                          },
                          child: const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 4.5),
                            child: Text("Subscribe"),
                          ),
                        );
                      }
                      return SizedBox();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
