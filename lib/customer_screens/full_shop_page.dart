import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/helpers/dateTimeHelper.dart';
import 'package:local_ease/helpers/dialogs.dart';
import 'package:local_ease/helpers/mapHelper.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';
import 'package:local_ease/widgets/item_carousel_card.dart';
import 'package:local_ease/widgets/itemstag.dart';

import '../apis/APIs.dart';

class FullShopViewPage extends StatefulWidget {
  final Map<String, dynamic> current_obj;
  const FullShopViewPage({Key? key, required this.current_obj})
      : super(key: key);

  @override
  State<FullShopViewPage> createState() => _FullShopViewPageState();
}

class _FullShopViewPageState extends State<FullShopViewPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    List items = widget.current_obj['items'] ?? [];
    List outStock = widget.current_obj['outstock'] ?? [];
    List subscribers = widget.current_obj['subscribers'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.current_obj['name']),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            foregroundDecoration: widget.current_obj['isopen'] ? const BoxDecoration() : const BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 250,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      widget.current_obj['photo'] ??
                          'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.current_obj['isopen'] ? "Open" : "Closed",
                      style: textTheme.titleMedium!.copyWith(
                        color: widget.current_obj['isopen']
                            ? AppColors.green
                            : AppColors.red,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                        ),
                        GestureDetector(
                          onTap: () {
                            LaunchMaps.launchInMaps(
                                lat: widget.current_obj['lat'],
                                long: widget.current_obj['long']);
                          },
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              widget.current_obj['address'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.displaySmall!.copyWith(
                                  // color: AppColors.grey,
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal! * 4.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "About",
                  style: textTheme.titleMedium,
                ),
                Text(
                  widget.current_obj['about'],
                  style: textTheme.displaySmall!
                      .copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.5),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Products",
                  style: textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 2.0, // gap between lines
                  children: <Widget>[
                    for (String item in widget.current_obj['items'])
                      MyTag(flag: outStock.contains(item), name: item)
                  ],
                ),

                // Carousel Card for Items

                widget.current_obj['isopen'] ? Column(
                  children: [
                    CarouselSlider(
                      items: items.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ItemCarouselCard(name: i, flag: outStock.contains(i), photo: widget.current_obj['photo'], desc:  widget.current_obj['about'],);
                          },
                        );
                      }).toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(milliseconds: 2500),
                          autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 6.7,
                          enlargeFactor: 0.24,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: items.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.pink)
                                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ) : const Text("This store is closed now subscribe to know when it opens!"),


                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Timings",
                  style: textTheme.titleMedium,
                ),
                Text(
                  "Opens at: ${DateTimeHelper.formatDateTime(widget.current_obj['opens'].toString())}",
                  style: textTheme.displaySmall!.copyWith(
                    fontSize: SizeConfig.safeBlockHorizontal! * 4.3,
                  ),
                ),
                Text(
                  "Closes at: ${DateTimeHelper.formatDateTime(widget.current_obj['closes'].toString())}",
                  style: textTheme.displaySmall!.copyWith(
                      fontSize: SizeConfig.safeBlockHorizontal! * 4.3,
                      color: AppColors.orange),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Contact Us",
                  style: textTheme.titleMedium,
                ),
                Text(
                  "Phone: ${widget.current_obj['phone']}",
                  style: textTheme.displaySmall!
                      .copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.3),
                ),
                Text(
                  "Email:  ${widget.current_obj['email']}",
                  style: textTheme.displaySmall!
                      .copyWith(fontSize: SizeConfig.safeBlockHorizontal! * 4.3),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Spacer(),
                    FutureBuilder(
                        future: APIs.instance.getUserID(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return subscribers.contains(snapshot.data)
                                ? TextButton(
                                    onPressed: () {
                                      Dialogs.showOpenCloseDialog(
                                        context: context,
                                        title: "Are you sure?",
                                        description:
                                            "Confirm that you want to unsubscribe ${widget.current_obj['name']} you won't be receiving any updates as notification",
                                        onBtnClk: () async {
                                          List subs =
                                              widget.current_obj['subscribers'];
                                          String shopId =
                                              widget.current_obj['ownerid'];
                                          await APIs.instance
                                              .unSubscribe(shopId, subs)
                                              .then((value) {
                                            setState(() {});
                                            Navigator.pop(context);
                                          });
                                        },
                                        icon: Icons.notifications_off_outlined,
                                      );
                                    },
                                    child: Text("Unsubscribe"),
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.red,
                                    ),
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
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: Text("Subscribe"),
                                    ),
                                  );
                          }
                          return SizedBox();
                        }),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
