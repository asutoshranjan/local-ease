import 'package:flutter/material.dart';
import 'package:local_ease/customer_screens/full_shop_page.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

class MyCards extends StatefulWidget {
  final String name;
  final String about;
  const MyCards({Key? key, required this.name, required this.about}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullShopViewPage(name: widget.name, about: widget.about),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.grey,),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: textTheme.displayLarge,
                    ),
                    Container(
                      width: 260,
                      child: Text(
                        widget.about,
                        style: textTheme.displaySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 90,
                  height: 90,
                  child: Image.network('https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg', fit: BoxFit.cover,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
