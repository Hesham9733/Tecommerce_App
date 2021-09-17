import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';
import 'package:shop_app/widgets/searchby_header.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchTextController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uId;
  String _imageUrl;

  final FocusNode _node = FocusNode();
  void initState() {
    super.initState();
    getData();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _searchTextController.dispose();
  }

  List<Product> _searchList = [];

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

  Future<void> onRefresh() async {
    _searchTextController.clear();
    _node.unfocus();
    final productsData = Provider.of<Products>(context);
    await productsData.fetchProducts();
    await getData();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productsList = productsData.products;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: SearchByHeader(
                imageUrl: _imageUrl,
                stackPaddingTop: 175,
                titlePaddingTop: 50,
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Search",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsConsts.title,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                stackChild: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchTextController,
                    minLines: 1,
                    focusNode: _node,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      suffixIcon: IconButton(
                        onPressed: _searchTextController.text.isEmpty
                            ? null
                            : () {
                                _searchTextController.clear();
                                _node.unfocus();
                              },
                        icon: Icon(Feather.x,
                            color: _searchTextController.text.isNotEmpty
                                ? Colors.red
                                : Colors.grey),
                      ),
                    ),
                    onChanged: (value) {
                      _searchTextController.text.toLowerCase();
                      setState(() {
                        _searchList = productsData.searchQuery(value);
                      });
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child:
                  _searchTextController.text.isNotEmpty && _searchList.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 150,
                              child: Image(
                                image: AssetImage(
                                    'lib/assets/no_result_found_image.png'),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              'No results found',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      : GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 240 / 420,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: List.generate(
                              _searchTextController.text.isEmpty
                                  ? productsList.length
                                  : _searchList.length, (index) {
                            return ChangeNotifierProvider.value(
                              value: _searchTextController.text.isEmpty
                                  ? productsList[index]
                                  : _searchList[index],
                              child: FeedProducts(),
                            );
                          }),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
