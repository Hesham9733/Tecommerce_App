import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/consts/my_icons.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/feeds_screen.dart';
import 'package:shop_app/screens/home_screen.dart';
import 'package:shop_app/screens/search_screen.dart';
import 'package:shop_app/screens/user_screen.dart';

class BottomBarScreen extends StatefulWidget {
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  List<Map<String, Object>> _pages;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(),
        'title': Text('Home'),
      },
      {
        'page': FeedsScreen(),
        'title': Text('Feeds'),
      },
      {
        'page': SearchScreen(),
        'title': Text('Search'),
      },
      {
        'page': CartScreen(),
        'title': Text('Cart'),
      },
      {
        'page': UserScreen(),
        'title': Text('User'),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Container(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              // ignore: deprecated_member_use
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: Colors.blue,
              currentIndex: _selectedIndex,
              onTap: _onTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    MyAppIcons.home,
                    color: Colors.blue[100],
                  ),
                  label: 'Home',
                  activeIcon: Icon(
                    MyAppIcons.home,
                    color: Colors.blue,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyAppIcons.rss,
                    color: Colors.blue[100],
                  ),
                  label: 'Feeds',
                  activeIcon: Icon(
                    MyAppIcons.rss,
                    color: Colors.blue,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(null), label: 'Search', activeIcon: null),
                BottomNavigationBarItem(
                  icon: Badge(
                    badgeColor: ColorsConsts.cartBadgeColor,
                    toAnimate: true,
                    animationDuration: Duration(milliseconds: 1500),
                    animationType: BadgeAnimationType.slide,
                    position: BadgePosition.topEnd(),
                    // ignore: deprecated_member_use
                    badgeContent: Text(
                      _cartProvider.getCartItems.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      MyAppIcons.cart,
                      color: Colors.blue[100],
                    ),
                  ),
                  label: 'Cart',
                  activeIcon: Badge(
                    badgeColor: ColorsConsts.cartBadgeColor,
                    toAnimate: true,
                    animationDuration: Duration(milliseconds: 1500),
                    animationType: BadgeAnimationType.slide,
                    position: BadgePosition.topEnd(),
                    // ignore: deprecated_member_use
                    badgeContent: Text(
                      _cartProvider.getCartItems.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      MyAppIcons.cart,
                      color: Colors.blue,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyAppIcons.user,
                    color: Colors.blue[100],
                  ),
                  label: 'User',
                  activeIcon: Icon(
                    MyAppIcons.user,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: ColorsConsts.purple800,
          splashColor: Colors.blue[100],
          hoverElevation: 10,
          elevation: 4,
          tooltip: 'Search',
          child: Icon(MyAppIcons.search),
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        ),
      ),
    );
  }
}
