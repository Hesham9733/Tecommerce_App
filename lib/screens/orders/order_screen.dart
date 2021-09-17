import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/screens/orders/order_empty.dart';
import 'package:shop_app/screens/orders/order_full.dart';
import 'package:shop_app/services/global_methods.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalMethods _globalMethods = GlobalMethods();
    final orderProvider = Provider.of<OrderProvider>(context);
    return FutureBuilder(
        future: orderProvider.fetchOrders(context),
        builder: (context, snapshot) {
          return orderProvider.getOrderItems.isEmpty
              ? Scaffold(body: OrderEmpty())
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    title: Text(
                      'Orders ( ${orderProvider.getOrderItems.length.toString()} )',
                      style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionColor),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(MyAppIcons.trash),
                          onPressed: () {
                            _globalMethods.showMeDialoug(context, 'Clear Cart',
                                "Your Cart will be Cleared!", () {});
                          })
                    ],
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: RefreshIndicator(
                      onRefresh: () {
                        return orderProvider.fetchOrders(context);
                      },
                      child: ListView.builder(
                          itemCount: orderProvider.getOrderItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: orderProvider.getOrderItems[index],
                                child: OrderFull());
                          }),
                    ),
                  ),
                );
        });
  }

  Widget checkoutSection(BuildContext ctx, double subTotal) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
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
