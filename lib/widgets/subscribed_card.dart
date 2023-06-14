import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/customer_screens/full_shop_page.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

import '../helpers/dialogs.dart';

class MySubscriptionCard extends StatefulWidget {
  final Map<String, dynamic> current_obj;
  const MySubscriptionCard({Key? key, required this.current_obj}) : super(key: key);

  @override
  State<MySubscriptionCard> createState() => _MySubscriptionCardState();
}

class _MySubscriptionCardState extends State<MySubscriptionCard> {

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.current_obj['name'],
                        style: textTheme.displayLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.current_obj['about'],
                        style: textTheme.displaySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: AppColors.tabGrey,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Image.network(
                        widget.current_obj['photo'] ??
                            'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    widget.current_obj['isopen'] ? TextButton(
                      onPressed: () {},
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 11),
                        child: Text("Opened"),
                      ),
                    ): TextButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.tabGrey, foregroundColor:  AppColors.grey),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 11),
                        child: Text("Closed"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
