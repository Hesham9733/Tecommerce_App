import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/fav_provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';

// ignore: must_be_immutable
class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    final _favsProvider = Provider.of<FavProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);
    final _productsProvider = Provider.of<Products>(context);
    _productsProvider.fetchProducts();
    List<Product> _productsListF = _productsProvider.products;
    Future<void> getProductsRefresh() async {
      await Provider.of<Products>(context, listen: false).fetchProducts();
      setState(() {
        
      });
    }

    final popular = ModalRoute.of(context).settings.arguments as String;
    if (popular == 'popular') {
      _productsListF = _productsProvider.popularProducts;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // ignore: deprecated_member_use
        title: Text(
          'Feeds',
          // ignore: deprecated_member_use
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        actions: [
          Consumer<FavProvider>(
            builder: (_, fav, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              toAnimate: true,
              animationDuration: Duration(milliseconds: 1500),
              animationType: BadgeAnimationType.slide,
              position: BadgePosition.topEnd(top: 5, end: 7),
              // ignore: deprecated_member_use
              badgeContent: Text(
                _favsProvider.getFavItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: Icon(
                    MyAppIcons.wishlist,
                    color: ColorsConsts.favColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('Wishlist');
                  }),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              toAnimate: true,
              animationDuration: Duration(milliseconds: 1500),
              animationType: BadgeAnimationType.slide,
              position: BadgePosition.topEnd(top: 5, end: 7),
              // ignore: deprecated_member_use
              badgeContent: Text(
                _cartProvider.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                  icon: Icon(
                    MyAppIcons.cart,
                    color: ColorsConsts.purple800,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('Cart');
                  }),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getProductsRefresh,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 330,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(
            _productsListF.length,
            (index) {
              return ChangeNotifierProvider.value(
                  value: _productsListF[index], child: FeedProducts());
            },
          ),
        ),
      ),
    );
  }
}
