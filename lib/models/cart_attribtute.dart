import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier{
  final String id;
  final String title;
  final String productId;
  final double price;
  final int quantity;
  final String imageUrl;

CartAttr({this.id, this.title,@required this.productId, this.price, this.quantity, this.imageUrl});
}
