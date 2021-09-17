import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/widgets/feeds_dialoge.dart';

class FeedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productsAttributes = Provider.of<Product>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed('Product Details', arguments: _productsAttributes.id);
        },
        child: Container(
          width: 250,
          height: 290,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: themeState.darkTheme
                  ? Colors.grey.shade100
                  : Colors.blueGrey.shade500),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          _productsAttributes.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Badge(
                      toAnimate: true,
                      shape: BadgeShape.square,
                      badgeColor: Colors.pink,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(8)),
                      badgeContent:
                          Text('NEW', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _productsAttributes.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15,
                            // ignore: deprecated_member_use
                            color: themeState.darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '\$ ${_productsAttributes.price}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              // ignore: deprecated_member_use
                              color: themeState.darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ${_productsAttributes.quantity}',
                            style: TextStyle(
                                fontSize: 12,
                                color:
                                    themeState.darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                                fontWeight: FontWeight.w600),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        FeedDialog(
                                      productId: _productsAttributes.id,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(18.0),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
