import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/provider/fav_provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final _favsProvider = Provider.of<FavProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);
    final _productsProvider = Provider.of<Products>(context);
    final _productsListS = _productsProvider.products;
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final prodAtt = _productsProvider.findById(_productId);
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail'.toUpperCase(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
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
                    navigateTo(context, 'Wishlist');
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
                  navigateTo(context, 'Cart');
                }),
          ),),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.network(prodAtt.imageUrl),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.purple.shade200,
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.save,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.purple.shade200,
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            prodAtt.title,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'US \$ ${prodAtt.price}',
                          style: TextStyle(
                              color: themeState.darkTheme
                                  ? Theme.of(context).disabledColor
                                  : ColorsConsts.subTitle,
                              fontWeight: FontWeight.bold,
                              fontSize: 21),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            prodAtt.description,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: themeState.darkTheme
                                  ? Theme.of(context).disabledColor
                                  : ColorsConsts.subTitle,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                        _details(
                            themeState.darkTheme, 'Brand: ', prodAtt.brand),
                        _details(themeState.darkTheme, 'Quantity: ',
                            '${prodAtt.quantity} Left'),
                        _details(themeState.darkTheme, 'Category: ',
                            '${prodAtt.productCategoryName}'),
                        _details(themeState.darkTheme, 'Popularity: ',
                            prodAtt.isPopular ? 'Popular' : 'Barely Known'),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No Reviews Yet',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context).textSelectionColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Be The First Review !',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: themeState.darkTheme
                                        ? Theme.of(context).disabledColor
                                        : ColorsConsts.subTitle,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    'Suggested Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Material(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                            value: _productsListS[index],
                            child: FeedProducts());
                      },
                      itemCount: _productsListS.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onLongPress: () {
                        Navigator.of(context).pushNamed('Cart');
                      },
                      onPressed:
                          _cartProvider.getCartItems.containsKey(_productId)
                              ? () {}
                              : () {
                                  _cartProvider.addProductToCart(
                                      _productId,
                                      prodAtt.title,
                                      prodAtt.imageUrl,
                                      prodAtt.price);
                                },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: _cartProvider.getCartItems.containsKey(_productId)
                          ? Colors.redAccent.shade100
                          : Colors.redAccent.shade400,
                      child: Text(
                        _cartProvider.getCartItems.containsKey(_productId)
                            ? 'in cart'.toUpperCase()
                            : 'add to cart'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Theme.of(context).backgroundColor,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Buy now'.toUpperCase(),
                              // ignore: deprecated_member_use
                              style: TextStyle(
                                  fontSize: 13,
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context).textSelectionColor),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.payment,
                              size: 19,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    child: Container(
                      color: themeState.darkTheme
                          ? Theme.of(context).canvasColor
                          : ColorsConsts.backgroundColor,
                      height: 50,
                      child: InkWell(
                        splashColor: ColorsConsts.favColor,
                        onTap: () {
                          _favsProvider.addOrRemoveFromFav(_productId,
                              prodAtt.title, prodAtt.imageUrl, prodAtt.price);
                        },
                        child: Icon(
                          _favsProvider.getFavItems.containsKey(_productId)
                              ? Icons.favorite
                              : MyAppIcons.wishlist,
                          color:
                              _favsProvider.getFavItems.containsKey(_productId)
                                  ? Colors.red
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget _details(bool themeState, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionColor,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              // ignore: deprecated_member_use
              color: themeState
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
