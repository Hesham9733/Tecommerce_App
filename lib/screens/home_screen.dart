import 'package:backdrop/backdrop.dart';
import 'package:backdrop/scaffold.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/back_layer_widget.dart';
import 'package:shop_app/widgets/category.dart';
import 'package:shop_app/widgets/popular_products.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uId;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User user = _auth.currentUser;
    _uId = user.uid;
    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uId).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _imageUrl = userDoc.get('imageUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(context);
    _productsData.fetchProducts();
    final _popularItems = _productsData.popularProducts;
    final themeState = Provider.of<DarkThemeProvider>(context);
    Future<void> getProductsRefresh() async {
      await Provider.of<Products>(context, listen: false).fetchProducts();
      setState(() {
        
      });
    }

    return Scaffold(
      body: Center(
        child: BackdropScaffold(
          frontLayerBackgroundColor: themeState.darkTheme
              ? Colors.purple.shade900
              : Colors.grey.shade300,
          headerHeight: MediaQuery.of(context).size.height * 0.25,
          appBar: BackdropAppBar(
            title: Text("Home"),
            leading: BackdropToggleButton(
              icon: AnimatedIcons.home_menu,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.purple,
                Colors.pink,
              ])),
            ),
            actions: [
              IconButton(
                  iconSize: 15,
                  padding: const EdgeInsets.all(10),
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundImage: _imageUrl == null
                          ? AssetImage(
                              'lib/assets/blank-profile-picture-973460_1280-1.png')
                          : NetworkImage(_imageUrl),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('User');
                  })
            ],
          ),
          backLayer: BackLayerMenu(),
          frontLayer: RefreshIndicator(
            onRefresh: getProductsRefresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 190.0,
                    width: double.infinity,
                    child: Carousel(
                      boxFit: BoxFit.contain,
                      autoplay: false,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 2000),
                      dotSize: 5.0,
                      dotIncreasedColor: Colors.purple,
                      dotBgColor: Colors.black.withOpacity(0.2),
                      dotPosition: DotPosition.bottomCenter,
                      showIndicator: true,
                      indicatorBgPadding: 5.0,
                      images: [
                        AssetImage('lib/assets/carousel1.png'),
                        AssetImage('lib/assets/carousel2.jpeg'),
                        AssetImage('lib/assets/carousel3.jpg'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _productsData.brandsCategory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryWidget(
                          index: index,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Popular Brands',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "BrandNavigationRailScreen",
                              arguments: {
                                7,
                              },
                            );
                          },
                          child: Text(
                            'View All...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Swiper(
                      autoplay: true,
                      duration: 1000,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    'BrandNavigationRailScreen',
                                    arguments: {
                                      index,
                                    },
                                  );
                                },
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(5),
                                  child: Image(
                                    image: AssetImage(_brands[index]),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _brands.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Popular Products',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Spacer(),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('Feeds', arguments: 'popular');
                          },
                          child: Text(
                            'View All...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 285,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                          value: _popularItems[index],
                          child: PopularProducts(),
                        );
                      },
                      itemCount: _popularItems.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List _brands = [
    'lib/assets/addidas.jpg',
    'lib/assets/apple.jpg',
    'lib/assets/Dell.jpg',
    'lib/assets/h&m.jpg',
    'lib/assets/nike.jpg',
    'lib/assets/samsung.jpg',
    'lib/assets/Huawei.jpg',
  ];
}
