import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';

// ignore: must_be_immutable
class CategoryWidget extends StatefulWidget {
  CategoryWidget({Key key, this.index}) : super(key: key);

  final int index;
  

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  List<Map<String, Object>> brandsCategory = [
    {
      'categoryName': 'Phones',
      'categoryImagesPath': 'lib/assets/CatPhones.png',
    },
    {
      'categoryName': 'Clothes',
      'categoryImagesPath': 'lib/assets/CatClothes.jpg',
    },
    {
      'categoryName': 'Shoes',
      'categoryImagesPath': 'lib/assets/CatShoes.jpg',
    },
    {
      'categoryName': 'Beauty&Health',
      'categoryImagesPath': 'lib/assets/CatBeauty.jpg',
    },
    {
      'categoryName': 'Laptops',
      'categoryImagesPath': 'lib/assets/CatLaptops.png',
    },
    {
      'categoryName': 'Furniture',
      'categoryImagesPath': 'lib/assets/CatFurniture.jpg',
    },
    {
      'categoryName': 'Watches',
      'categoryImagesPath': 'lib/assets/CatWatches.jpg',
    },
  ];
  

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('CategoriesFeeds', arguments: '${brandsCategory[widget.index]['categoryName']}');
          },
          child: Container(
            child: Padding(
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage(
                    brandsCategory[widget.index]['categoryImagesPath']),
              ),
              padding: const EdgeInsets.all(5),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
          bottom: -7,
          left: 10,
          right: 10,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // ignore: deprecated_member_use
            child: Text(
              brandsCategory[widget.index]['categoryName'],
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).textSelectionColor),
            ),
            color: themeState.darkTheme ? Colors.black : Colors.grey.shade200,
          ),
        )
      ],
    );
  }
}
