import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/provider/fav_provider.dart';

class PopularProducts extends StatefulWidget {
  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    final _favProvider = Provider.of<FavProvider>(context);
    final _productsAttributes = Provider.of<Product>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
            color: themeState.darkTheme ? Colors.black : Colors.grey.shade200,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('Product Details',
                  arguments: _productsAttributes.id);
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(_productsAttributes.imageUrl),
                              fit: BoxFit.contain)),
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Icon(
                        Entypo.star,
                        color: _favProvider.getFavItems
                                .containsKey(_productsAttributes.id)
                            ? Colors.red
                            : Colors.grey.shade400,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 8,
                      child: Icon(
                        Entypo.star_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 32,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).backgroundColor,
                        // ignore: deprecated_member_use
                        child: Text(
                          '\$ ${_productsAttributes.price}',
                          style:
                              // ignore: deprecated_member_use
                              TextStyle(
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context).textSelectionColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _productsAttributes.title,
                        maxLines: 1,
                        style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              _productsAttributes.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onDoubleTap: () {
                                  Navigator.of(context).pushNamed('Cart');
                                },
                                onTap: _cartProvider.getCartItems
                                        .containsKey(_productsAttributes.id)
                                    ? () {}
                                    : () {
                                        _cartProvider.addProductToCart(
                                            _productsAttributes.id,
                                            _productsAttributes.title,
                                            _productsAttributes.imageUrl,
                                            _productsAttributes.price);
                                      },
                                borderRadius: BorderRadius.circular(30.0),
                                child: Icon(
                                  _cartProvider.getCartItems
                                          .containsKey(_productsAttributes.id)
                                      ? MaterialCommunityIcons.check_all
                                      : MaterialCommunityIcons.cart_plus,
                                  size: 25,
                                  color: themeState.darkTheme ? ColorsConsts.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
