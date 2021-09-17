import 'package:flutter/material.dart';
import 'package:shop_app/screens/bottom_bar.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        BottomBarScreen(),
      ],
    );
  }
}