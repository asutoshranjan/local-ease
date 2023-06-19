
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/helpers/distanceCalculator.dart';
import 'package:local_ease/main.dart';
import 'package:appwrite/appwrite.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/utils/credentials.dart';
import 'package:local_ease/utils/sizeConfig.dart';
import 'package:local_ease/widgets/textfields.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../helpers/dialogs.dart';
import '../models/notification.model.dart';
import '../theme/colors.dart';
import '../widgets/cards.dart';

class NearYouPage extends StatefulWidget {
  const NearYouPage({Key? key}) : super(key: key);

  @override
  State<NearYouPage> createState() => _NearYouPageState();
}

class _NearYouPageState extends State<NearYouPage> {
  Databases databases = Databases(client);
  String txtQuery = "";
  String lat = "";
  String long = "";
  String currentAddress = "Pick Location";
  MyUserModel? currentUser;

  String databaseId = Credentials.DatabaseId;
  String collectionId = Credentials.ShopsCollectionId;
  late RealtimeSubscription subscription;

  /// Notif subscription

  String notifCollectionId = Credentials.NotificationCollectionId;
  late RealtimeSubscription notifSubscription;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    currentUserCall();
    loadItems();
    subscribe();
    notif();
  }

  currentUserCall() async {
    currentUser = await APIs.instance.getUser();

    if (currentUser != null) {
      currentAddress = currentUser!.address ?? "";
      lat = currentUser!.lat ?? "";
      long = currentUser!.long ?? "";
      setState(() {});
    }
  }

  loadItems() async {
    try {
      currentUser = await APIs.instance.getUser();
      await databases
          .listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: currentUser != null && currentUser!.country != null
            ? [
                Query.equal("country", currentUser!.country!),
                Query.equal("pincode", currentUser!.pincode!),
                Query.equal("isopen", true),
              ]
            : [Query.equal("isopen", true)],
      )
          .then((value) {
        var currentDocs = value.documents;
        setState(() {
          items = currentDocs.map((e) => e.data).toList();
        });
      });

      for (var i in items) {
        log(i.toString());
      }
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  void subscribe() {
    final realtime = Realtime(client);

    subscription = realtime.subscribe(
        ['databases.$databaseId.collections.$collectionId.documents']);

    // listen to changes
    subscription.stream.listen((data) {
      log("there is some change");
      // data will consist of `events` and a `payload`
      if (data.payload.isNotEmpty) {
        log("there is some change");
        if (data.events
            .contains("databases.*.collections.*.documents.*.create")) {
          var item = data.payload;

          ShopModel shop = ShopModel.fromJson(item);
          if (currentUser != null &&
              currentUser!.country != null &&
              shop.isOpen == true) {
            if (currentUser!.country! == shop.country &&
                currentUser!.pincode == shop.pincode) {
              log("Item Added");
              items.add(item);
            }
          } else if (shop.isOpen == true) {
            log("Item Added but not of exact location");
            items.add(item);
          }
          // log("Item Added");
          // items.add(item);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.delete")) {
          var item = data.payload;
          log("item deleted");
          items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.update")) {
          var item = data.payload;
          log("item update");
          int idx = items.indexWhere((it) => it['\$id'] == item['\$id']);
          log("${idx} is the index");
          items[idx] = item;
          setState(() {});
        }
      }
    });


  }

  void notif() async{
    final myId = await APIs.instance.getUserID();

    Realtime realtime2 = Realtime(client);

    notifSubscription = realtime2.subscribe(
        ['databases.$databaseId.collections.$notifCollectionId.documents']);

    // listen to changes
    notifSubscription.stream.listen((data) {
      log("there is some change");
      // data will consist of `events` and a `payload`
      if (data.payload.isNotEmpty) {
        log("there is some change");
        if (data.events
            .contains("databases.*.collections.*.documents.*.create")) {
          var item = NotificationModel.fromJson(data.payload);
          log("Item Added");
          if (item.users!.contains(myId)) {
            Dialogs.showNotificationDialog(context, item.title!, item.description!);
          }

          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.delete")) {
          var item = data.payload;
          log("item deleted");
          //items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.update")) {
          var item = data.payload;
          log("item update");
        }
      }
    });

  }

  @override
  void dispose() {
    subscription.close();
    notifSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // title: Text("LocalEase"),
        title: RichText(
          text: TextSpan(
            text: 'Local',
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
                color: AppColors.black,),
            /*defining default style is optional */
            children: const <TextSpan>[
              TextSpan(
                text: 'Ease',
                style: TextStyle(color: AppColors.pink),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Padding(
            padding:  const EdgeInsets.only(left: 12, right: 12, bottom: 11),
            child: TextFieldInput(
              hintText: 'Search for any store here..',
              suffixIcon: txtQuery == ""
                  ? const SizedBox()
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        txtQuery = "";
                        setState(() {});
                      },
                    ),
              onChanged: (val) {
                txtQuery = val;
                setState(() {});
              },
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Material(
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          width: screenWidth,
                          height: screenWidth * 2,
                          child: OpenStreetMapSearchAndPick(
                              center: LatLong(
                                  19.357640790268235, 84.97573036558032),
                              buttonTextColor: AppColors.white,
                              buttonColor: AppColors.pink,
                              zoomInIcon: CupertinoIcons.zoom_in,
                              zoomOutIcon: CupertinoIcons.zoom_out,
                              locationPinIconColor: AppColors.pink,
                              buttonText: 'Set This Location',
                              onPicked: (pickedData) async {
                                print(pickedData.latLong.latitude);
                                print(pickedData.latLong.longitude);
                                print(pickedData.address);

                                lat = pickedData.latLong.latitude.toString();
                                long = pickedData.latLong.longitude.toString();
                                currentAddress = pickedData.address;

                                List arr = currentAddress.split(", ");

                                if (currentUser != null) {
                                  currentUser!.country = arr[arr.length - 1];
                                  currentUser!.pincode = arr[arr.length - 2];
                                  currentUser!.district = arr[arr.length - 3];
                                  currentUser!.address = currentAddress;
                                  currentUser!.lat = lat;
                                  currentUser!.long = long;

                                  await APIs.instance
                                      .updateUserInfo(currentUser!)
                                      .then((value) {
                                    setState(() {});
                                    loadItems();
                                    Navigator.pop(context);
                                  });
                                }
                                setState(() {});
                              }),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: SizeConfig.safeBlockVertical! * 4.7,
                  width: SizeConfig.safeBlockHorizontal! * 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 2.5,
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                      )
                    ],
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                      ),
                      const SizedBox(width: 3),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal! * 34.5,
                        child: Text(
                          currentAddress,
                          style: textTheme.displaySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
      body: txtQuery == ""
          ? items.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> current_obj = items[index];
                    ShopModel shop = ShopModel.fromJson(current_obj);
                    return MyCards(
                      current_obj: current_obj,
                      dis: lat == ""
                          ? ""
                          : """${DistanceCalculator.calculateDistance(lat, long, shop.lat!, shop.long!).toStringAsFixed(1)}Km""",
                    );
                  })
              : Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Oops! No stores to show",
                    style: textTheme.titleMedium!
                        .copyWith(fontSize: 18, color: AppColors.orange),
                  ),
                )
          : FutureBuilder(
              future: databases.listDocuments(
                databaseId: databaseId,
                collectionId: collectionId,
                queries: [Query.search("name", txtQuery)],
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    List<ShopModel> resultShops = snapshot.data!.documents
                            .map((e) => ShopModel.fromJson(e.data))
                            .toList() ?? [];

                    if (resultShops.isNotEmpty) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: resultShops.length,
                        itemBuilder: (context, index) {
                          ShopModel shop = resultShops[index];
                          return  MyCards(
                            current_obj: shop.toJson(),
                            dis: lat == ""
                                ? ""
                                : """${DistanceCalculator.calculateDistance(lat, long, shop.lat!, shop.long!).toStringAsFixed(1)}Km""",
                          );

                          // return MySubscriptionCard(current_obj: shop.toJson());

                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Sorry! Cannot find any relevant result", style: textTheme.titleMedium!.copyWith( fontSize: 18, color: AppColors.orange),),
                      );
                    }
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  }
}
