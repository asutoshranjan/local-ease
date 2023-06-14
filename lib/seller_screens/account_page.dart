import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:local_ease/auth/login_screen.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';
import 'package:local_ease/widgets/user_card.dart';
import '../apis/APIs.dart';
import '../helpers/dialogs.dart';
import '../main.dart';
import '../utils/credentials.dart';
import '../widgets/textfields.dart';

class SellerAccountPage extends StatefulWidget {
  const SellerAccountPage({Key? key}) : super(key: key);

  @override
  State<SellerAccountPage> createState() => _SellerAccountPageState();
}

class _SellerAccountPageState extends State<SellerAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController photoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppName Profile"),
        actions: [
          IconButton(
            onPressed: () {
              APIs.instance.logout();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Logged Out')));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              FutureBuilder(
                future: APIs.instance.getUser(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      MyUserModel currentUser = snapshot.data!;
                      nameController =
                          TextEditingController(text: currentUser.name);
                      photoController =
                          TextEditingController(text: currentUser.photo);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserCard(myUser: snapshot.data!),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 4,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.tabPink,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "Edit Profile",
                                style: textTheme.titleSmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Email: ${currentUser.email}",
                            style: textTheme.titleMedium!.copyWith(
                                fontSize:
                                    SizeConfig.safeBlockHorizontal! * 4.5),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFieldInput(
                            controller: nameController,
                            title: 'Store Name',
                            hintText: 'Enter Store Name',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFieldInput(
                            controller: photoController,
                            title: 'Store Name',
                            hintText: 'Enter Store Name',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: () async {
                                  currentUser.name = nameController.text;
                                  currentUser.photo = photoController.text;
                                  Dialogs.showLoaderDialog(context, "Saving");
                                  await APIs.instance
                                      .updateUserInfo(currentUser)
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() {});
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Text("Save Changes"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
