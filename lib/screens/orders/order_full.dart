import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order_attribute.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/services/global_methods.dart';

class OrderFull extends StatefulWidget {
  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final orderAtt = Provider.of<OrderAttr>(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'Product Details',
          arguments: orderAtt.productId),
      child: Container(
        height: 135,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
            color: themeChange.darkTheme
                ? Colors.purple.shade900
                : Colors.pink.shade200),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(orderAtt.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              orderAtt.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32.0),
                              // splashColor: ,
                              onTap: () {
                                globalMethods.showMeDialoug(
                                    context,
                                    'Remove Item',
                                    "This Order will be deleted !", () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('order')
                                      .doc(orderAtt.orderId)
                                      .delete();
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : Icon(
                                        Entypo.cross,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text('Price:'),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${orderAtt.price} \$',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text('Quantity:'),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'x ${orderAtt.quantity}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(child: Text('Order ID:')),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              '${orderAtt.orderId}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
