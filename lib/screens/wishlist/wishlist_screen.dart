import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/provider/fav_provider.dart';
import 'package:shop_app/screens/wishlist/wishlist_empty.dart';
import 'package:shop_app/screens/wishlist/wishlist_full.dart';
import 'package:shop_app/services/global_methods.dart';


class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();

    final _favsProvider = Provider.of<FavProvider>(context);
    // ignore: prefer_is_not_empty
    return _favsProvider.getFavItems.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              actions: [
                IconButton(
                    icon: Icon(MyAppIcons.trash),
                    onPressed: () {
                      globalMethods.showMeDialoug(context, 'Clear Wishlist',
                          "Your Wishlist will be Cleared!", () {
                        _favsProvider.clearFav();
                      });
                    })
              ],
              // ignore: deprecated_member_use
              title: Text('Wishlist (${_favsProvider.getFavItems.length})', style: TextStyle(color: Theme.of(context).textSelectionColor),),
            ),
            body: Container(
              margin: EdgeInsets.only(top: 10, bottom: 60),
              child: ListView.builder(
                itemCount: _favsProvider.getFavItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                      value: _favsProvider.getFavItems.values.toList()[index],
                      child: WishlistFull(
                        productId:
                            _favsProvider.getFavItems.keys.toList()[index],
                      ));
                },
              ),
            ),
          );
  }
}
