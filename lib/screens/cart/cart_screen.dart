import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/screens/cart/cart_empty.dart';
import 'package:shop_app/screens/cart/cart_full.dart';
import 'package:shop_app/services/global_methods.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final _cartProvider = Provider.of<CartProvider>(context);

    return _cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, _cartProvider.totalAmount),
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              // ignore: deprecated_member_use
              title: Text(
                'Cart ( ${_cartProvider.getCartItems.length} )',
                // ignore: deprecated_member_use
                style: TextStyle(color: Theme.of(context).textSelectionColor),
              ),
              actions: [
                IconButton(
                    icon: Icon(MyAppIcons.trash),
                    onPressed: () {
                      globalMethods.showMeDialoug(
                          context, 'Clear Cart', "Your Cart will be Cleared!",
                          () {
                        _cartProvider.clearCart();
                      });
                    })
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: _cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                      value: _cartProvider.getCartItems.values.toList()[index],
                      child: CartFull(
                        productId:
                            _cartProvider.getCartItems.keys.toList()[index],
                      ),
                    );
                  }),
            ));
  }

  Widget checkoutSection(BuildContext ctx, double subTotal) {
    var uuId = Uuid();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final _cartProvider = Provider.of<CartProvider>(ctx);
    GlobalMethods _globalMethods = GlobalMethods();
    bool _isLoading = false;

    return Container(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient:
                          LinearGradient(colors: [Colors.pink, Colors.purple]),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          User user = _auth.currentUser;
                          final _uId = user.uid;
                          _cartProvider.getCartItems
                              .forEach((key, orderValue) async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              final orderId = uuId.v4();
                              await FirebaseFirestore.instance
                                  .collection('order')
                                  .doc(orderId)
                                  .set({
                                'orderId': orderId,
                                'userId': _uId,
                                'productId': orderValue.productId,
                                'title': orderValue.title,
                                'price': orderValue.price * orderValue.quantity,
                                'quantity': orderValue.quantity,
                                'imageUrl': orderValue.imageUrl,
                                'orderDate': Timestamp.now(),
                              });
                              _globalMethods.flutterToast(
                                  'The Order Uploaded Successfully');
                              _cartProvider.clearCart();
                              // ignore: unnecessary_statements
                              Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                            } catch (error) {
                              _globalMethods.authErrorHandle(
                                  error.message, ctx);
                            } finally {
                              _isLoading = false;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Checkout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // ignore: deprecated_member_use
                              color: Theme.of(ctx).textSelectionColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        'Total :',
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Theme.of(ctx).textSelectionColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'US \$ ${subTotal.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
    );
  }
}
