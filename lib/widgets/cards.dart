import 'package:flutter/material.dart';
import 'package:local_ease/customer_screens/full_shop_page.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

class MyCards extends StatefulWidget {
  final Map<String, dynamic> current_obj;
  const MyCards({Key? key, required this.current_obj}) : super(key: key);

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
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.grey,
            ),
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
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange),
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
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Text(
                                    item,
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
                        color: AppColors.grey,
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

                    subscribers.contains('id1')
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey, ),
                      onPressed: () {},
                      child: Text("Subscribed"),
                    )
                        : ElevatedButton(
                      onPressed: () {},
                      child: Text("Subscribe"),
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
