import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class SelectFromMap extends StatefulWidget {
  const SelectFromMap({Key? key}) : super(key: key);

  @override
  State<SelectFromMap> createState() => _SelectFromMapState();
}

class _SelectFromMapState extends State<SelectFromMap> {
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
