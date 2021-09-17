import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/consts/my_icons.dart';

// ignore: must_be_immutable
class BackLayerMenu extends StatefulWidget {
  BackLayerMenu({Key key}) : super(key: key);

  @override
  _BackLayerMenuState createState() => _BackLayerMenuState();
}

class _BackLayerMenuState extends State<BackLayerMenu> {
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.pink,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        Positioned(
          top: -100.0,
          left: 140.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.3)),
              width: 150,
              height: 250,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 100.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.3)),
              width: 150,
              height: 250,
            ),
          ),
        ),
        Positioned(
          top: -50.0,
          left: 60.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.3)),
              width: 150,
              height: 200,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.3)),
              width: 150,
              height: 250,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('User');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: _imageUrl == null
                                ? AssetImage(
                                    'lib/assets/blank-profile-picture-973460_1280-1.png')
                                : NetworkImage(_imageUrl),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                content(context, () {
                  navigateTo(context, 'Feeds');
                }, 'Feeds', 0),
                const SizedBox(
                  height: 5,
                ),
                content(context, () {
                  navigateTo(context, 'Cart');
                }, 'Cart', 1),
                const SizedBox(
                  height: 5,
                ),
                content(context, () {
                  navigateTo(context, 'Wishlist');
                }, 'Wishlist', 2),
                const SizedBox(
                  height: 5,
                ),
                content(context, () {
                  navigateTo(context, 'Upload Product');
                }, 'Uplaod New Product', 3),
              ],
            ),
          ),
        )
      ],
    );
  }

  List _contentIcons = [
    MyAppIcons.rss,
    MyAppIcons.cart,
    MyAppIcons.wishlist,
    MyAppIcons.upload
  ];

  void navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget content(BuildContext context, Function fct, String text, int index) {
    return InkWell(
      onTap: fct,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(_contentIcons[index]),
        ],
      ),
    );
  }
}
