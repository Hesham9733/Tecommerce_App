import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/feeds_products.dart';

// ignore: must_be_immutable
class CategoriesFeeds extends StatefulWidget {
  @override
  _CategoriesFeedsState createState() => _CategoriesFeedsState();
}

class _CategoriesFeedsState extends State<CategoriesFeeds> {
  @override
  Widget build(BuildContext context) {
    final _productsProvider = Provider.of<Products>(context);
    final _categoryName = ModalRoute.of(context).settings.arguments as String;
    final _productsListF = _productsProvider.findByCategory(_categoryName);
    return Scaffold(
        appBar: AppBar(),
        body: _productsListF.isEmpty
            ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                        image: NetworkImage(
                            'https://www.novamind.gmbh/images/no_products.png')),
                    Text(
                      'No Products is Related to this Brand',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            )
            : GridView.count(
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
              ));
  }
}
