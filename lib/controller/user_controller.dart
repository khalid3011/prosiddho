import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:prosiddho/controller/products_controller.dart';
import 'package:prosiddho/controller/wishlist_controller.dart';
import 'package:prosiddho/enum/status.dart';
import 'package:prosiddho/functions/firestore_crud/firestore_read_function.dart';
import 'package:prosiddho/functions/firestore_crud/firestore_update_function.dart';
import 'package:prosiddho/model/user_model/user_model.dart';
import 'package:prosiddho/model/user_model/address_model.dart';
import 'package:prosiddho/views/dashboard_screen.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel.init().obs;

  bool _initSetupFinish = false;

  UserModel get userModel => this._userModel.value;

  set userModel(UserModel user) => this._userModel.value = user;

  void reset() {
    this._userModel.value = UserModel.init();
    _initSetupFinish = false;
  }

  Address getActiveAddress() {
    Address active;
    for (Address address in userModel.address) {
      if (address.active) {
        active = address;
        break;
      }
    }

    return active;
  }

  //start a user stream
  //bacause if user change  phone or address or
  //user used a  free delivery or earn points or
  //make an order then it will update automatically
  void startUserStream(String userID) async {
    FirestoreReadFunction.userStream(userID)
        .listen((DocumentSnapshot document) async {
      //if user already registered and data available
      //update user model and continue

      //check document  exists for sefty
      if (document.exists) {
        UserModel userModel = UserModel.fromFirestore(document);
        this.userModel = userModel;

        //check user status
        if (this.userModel.accountStatus.status == Status.Active.value) {
          //set initial setup
          if (!_initSetupFinish) {
            _initSetupFinish = true;

            //check last sign in
            //if user back from long time (date available in adimn settings)
            //check offer and update database;

            await FirestoreUpdateFunction.offerUpdate();

            //update last signin
            await FirestoreUpdateFunction.lastLogin();

            //collect all products initially ;
            //so that categorize all products easily
            ProductController _productController = Get.put(ProductController());
            await _productController.fetchProduct();

            //collect wishlist
            WishlistController _wishlistController =
                Get.put(WishlistController());
            await _wishlistController.startStream();

            print("hello");

            //go to homne page
            Get.to(DashboardScreen());
          }
        } else {
          Get.defaultDialog(
            title: "Your account is ${this.userModel.accountStatus.status}",
          );
          // await FirestoreUpdateFunction.lastLogin(userID);

        }
      }
    });
  }
}
