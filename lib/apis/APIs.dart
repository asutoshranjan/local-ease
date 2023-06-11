import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/utils/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class APIs {
  APIs._privateConstructor();
  static final APIs _instance = APIs._privateConstructor();
  static APIs get instance => _instance;
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static final account = Account(client);

  static final databases = Databases(client);

  var uuid = Uuid(); // Generates UniqueIDs

  Future<String?> getUserID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userId');
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', value);
  }

  Future<bool> loginEmailPassword(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    try {
      final models.Session response =
          await account.createEmailSession(email: email, password: password);
      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUpEmailPassword(
      String email, String password, String name) async {
    final SharedPreferences prefs = await _prefs;
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      final models.Session response = await account.createEmailSession(
        email: email,
        password: password,
      );

      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    final SharedPreferences prefs = await _prefs;
    setLoggedIn(false);
    prefs.remove('userId');
    prefs.remove('email');
    prefs.remove('password');
  }

  /// Database CRUD Operation Functions

  // check if store exist and get value

  Future<ShopModel?> getStore() async {
    ShopModel? myShopModel;

    try {
      await getUserID().then((userId) async {
        await databases
            .getDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: userId!,
        )
            .then((value) {
          if (value.data != null) {
            myShopModel = ShopModel.fromJson(value.data);
          }
        });
      });

      return myShopModel;
    } catch(e) {
      return myShopModel; // Returns null
    }
  }
  // if docid == null create else update

  // Create Store
  Future<void> createShop({
    required ShopModel currentShop,
  }) async {
    try {
      await getUserID().then((userId) async {
        String docId = uuid.v1();
        ShopModel myShop = currentShop;
        myShop.ownerId = userId;
        myShop.subscribers = [];
        myShop.isOpen = true;
        await databases.createDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: userId!,
          data: myShop.toJson(),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update Store
  updateShopInfo(ShopModel currentShop) async {
    try {
      await databases.updateDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentShop.ownerId!,
        data: currentShop.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete Account's Store
  deleteShop(ShopModel currentShop) async {
    try {
      await databases.deleteDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentShop.ownerId!,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Subscribe

  subscribe(String shopId, List subscribers) async {
    try {
      // add to shop subscription list
      await getUserID().then((userId) async {
        subscribers.add(userId);
        await databases.updateDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: shopId,
          data: {
            "subscribers": subscribers,
          },
        );

        await getUser().then((value) {
          List subs = value!.following!;
          subs.add(shopId);
          databases.updateDocument(
            databaseId: Credentials.DatabaseId,
            collectionId: Credentials.UsersCollectonId,
            documentId: value.docId!,
            data: {
              "following": subs,
            },
          );
        });
      }
          // add to user subscribed list list
          );
    } catch (e) {
      rethrow;
    }
  }


  // For getting users subscribed stores

  Future<List<ShopModel>> getSubscribedStore() async {
    List<ShopModel> myStores = [];

    MyUserModel? currentUser = await getUser();

    if (currentUser != null) {
      List shops = currentUser.following!;

      for (var shopId in shops) {
        final value = await databases.getDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: shopId,
        );
        ShopModel myShopModel = ShopModel.fromJson(value.data);
        myStores.add(myShopModel);
      }
      return myStores;
    }

    return myStores;
  }

  // For getting subscribed users

  Future<List<MyUserModel>> getSubscribedUsers() async{
    List<MyUserModel> myUsers = [];

    ShopModel? myShop = await getStore();

    if(myShop != null) {
      List users = myShop.subscribers!;
      for(var userId in  users) {
        final result  = await databases.getDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.UsersCollectonId,
          documentId: userId,
        );
        MyUserModel currentUser = MyUserModel.fromJson(result.data);
        myUsers.add(currentUser);
      }
      return myUsers;
    }
    return myUsers;
  }

  // get user

  Future<MyUserModel?> getUser() async {
    MyUserModel? currentUser;
    await getUserID().then((userId) async {
      try {
        await databases
            .getDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.UsersCollectonId,
          documentId: userId!,
        )
            .then((value) {
          if (value.data != null) {
            currentUser = MyUserModel.fromJson(value.data);
          }
        });
      } catch (e) {
        return currentUser;
      }
    });
    return currentUser;
  }

  // Create New User
  Future<void> createUser({
    required String type,
  }) async {
    await account.get().then((user) {
      MyUserModel newUser = MyUserModel(
        name: user.name,
        email: user.email,
        following: [],
        notifications: [],
        photo: "https://cdn-icons-png.flaticon.com/512/266/266033.png",
        type: type,
        docId: user.$id,
      );
      databases.createDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.UsersCollectonId,
        documentId: user.$id,
        data: newUser.toJson(),
      );
    });
  }

  // Update User
  Future<void> updateUserInfo(MyUserModel currentUser) async {
    try {
      await databases.updateDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentUser.docId!,
        data: currentUser.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
