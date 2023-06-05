import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../theme/colors.dart';

class ChooseShopFromMap extends StatefulWidget {
  const ChooseShopFromMap({Key? key}) : super(key: key);

  @override
  State<ChooseShopFromMap> createState() => _ChooseShopFromMapState();
}

class _ChooseShopFromMapState extends State<ChooseShopFromMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
          center: LatLong(19.357640790268235, 84.97573036558032),
          buttonTextColor: AppColors.white,
          buttonColor: AppColors.pink,
          zoomInIcon: CupertinoIcons.zoom_in,
          zoomOutIcon: CupertinoIcons.zoom_out,
          locationPinIconColor: AppColors.green,
          buttonText: 'Set This Location',
          onPicked: (pickedData) {
            print(pickedData.latLong.latitude);
            print(pickedData.latLong.longitude);
            print(pickedData.address);
          }),
    );
  }
}
