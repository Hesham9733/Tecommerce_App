import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderAttr with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String title;
  final String price;
  final String quantity;
  final String imageUrl;
  final Timestamp orderDate;

  OrderAttr({this.orderId, this.userId, this.productId, this.title, this.price, this.quantity, this.imageUrl, this.orderDate});

}
