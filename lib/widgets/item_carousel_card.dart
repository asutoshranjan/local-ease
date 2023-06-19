import 'package:flutter/material.dart';
import 'package:local_ease/utils/sizeConfig.dart';

import '../theme/app-theme.dart';
import '../theme/colors.dart';

class ItemCarouselCard extends StatefulWidget {
  final String name;
  final String photo;
  final String desc;
  final bool flag;
  const ItemCarouselCard({Key? key, required this.name, required this.flag, required this.photo, required this.desc}) : super(key: key);

  @override
  State<ItemCarouselCard> createState() => _ItemCarouselCardState();
}

class _ItemCarouselCardState extends State<ItemCarouselCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.safeBlockHorizontal! * 92,
        margin: const EdgeInsets.symmetric(horizontal: 3.6, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundDecoration: widget.flag ? const BoxDecoration(
          color: Colors.grey,
          backgroundBlendMode: BlendMode.saturation,
        ):  const BoxDecoration(),
        child: Row(
          children: [
            Container(
              width: SizeConfig.safeBlockHorizontal! * 28,
              height: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft:  Radius.circular(8),),
                  ),
              child: Image.network(
                widget.photo ??'https://kinsta.com/wp-content/uploads/2020/09/imag-file-types-1024x512.png',
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Container(
              width: SizeConfig.safeBlockHorizontal!* 40,
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.6),
                  ),
                  const SizedBox(height: 3,),
                  Text(
                    widget.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.displayMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*3.7),
                  ),
                  const Spacer(),
                  Text(
                    widget.flag ? "Out Stock" : "In Stock",
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: SizeConfig.safeBlockHorizontal!*4.4,
                      color: widget.flag
                          ? AppColors.orange
                          : AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ));
  }
}
