import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/theme_data.dart';
import 'package:shop_app/inner_screens/brands_navigation_rail.dart';
import 'package:shop_app/inner_screens/categories_feeds.dart';
import 'package:shop_app/inner_screens/product_details.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/screens/authentication/forget_password.dart';
import 'package:shop_app/screens/orders/order_screen.dart';
import 'package:shop_app/screens/upload_product_form.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/provider/fav_provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/authentication/login_screen.dart';
import 'package:shop_app/screens/authentication/signup_screen.dart';
import 'package:shop_app/screens/bottom_bar.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/feeds_screen.dart';
import 'package:shop_app/screens/landing_screen.dart';
import 'package:shop_app/screens/main_screen.dart';
import 'package:shop_app/screens/user_screen.dart';
import 'package:shop_app/screens/user_state.dart';
import 'package:shop_app/screens/wishlist/wishlist_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePrefernces.getTheme();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => FavProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrderProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeData, child) {
                return MaterialApp(
                  title: 'Tecommerce',
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: UserState(),
                  routes: {
                    'Feeds': (ctx) => FeedsScreen(),
                    'Forget Password': (ctx) => ForgetPassword(),
                    'Landing': (ctx) => LandingScreen(),
                    'Main': (ctx) => MainScreen(),
                    'Upload Product': (ctx) => UploadProductForm(),
                    'Login': (ctx) => LoginScreen(),
                    'Signup': (ctx) => SignupScreen(),
                    'BottomBar': (ctx) => BottomBarScreen(),
                    'User': (ctx) => UserScreen(),
                    'Cart': (ctx) => CartScreen(),
                    'Wishlist': (ctx) => WishlistScreen(),
                    'Order': (ctx) => OrderScreen(),
                    'Product Details': (ctx) => ProductDetails(),
                    'CategoriesFeeds': (ctx) => CategoriesFeeds(),
                    'BrandNavigationRailScreen': (ctx) =>
                        BrandNavigationRailScreen(),
                  },
                );
              }));
        });
  }
}
