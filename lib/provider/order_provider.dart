import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/order_attribute.dart';
import 'package:shop_app/services/global_methods.dart';

class OrderProvider with ChangeNotifier {
  List<OrderAttr> _orderItems = [];
  List<OrderAttr> get getOrderItems {
    return _orderItems;
  }

  Future<void> fetchOrders(BuildContext ctx) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GlobalMethods _globalMethods = GlobalMethods();
    User _user = _auth.currentUser;
    var _uid = _user.uid;
    try {
      await FirebaseFirestore.instance
          .collection('order')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orderItems.clear();
        ordersSnapshot.docs.forEach((element) {
          _orderItems.insert(
              0,
              OrderAttr(
                  orderId: element.get('orderId'),
                  userId: element.get('userId'),
                  productId: element.get('productId'),
                  title: element.get('title'),
                  price: element.get('price').toString(),
                  quantity: element.get('quantity').toString(),
                  imageUrl: element.get('imageUrl'),
                  orderDate: element.get('orderDate')));
        });
      });
    } catch (error) {
      _globalMethods.authErrorHandle(error.message, ctx);
    }
    notifyListeners();
  }

  void clearOrders() {
    _orderItems.clear();
    notifyListeners();
  }
}
