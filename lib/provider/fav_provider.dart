import 'package:flutter/material.dart';
import 'package:shop_app/models/fav_attributes.dart';

class FavProvider with ChangeNotifier {
  Map<String, FavAttr> _favItems = {};
  Map<String, FavAttr> get getFavItems {
    return _favItems;
  }

  void addOrRemoveFromFav(
      String productId, String title, String imageUrl, double price) {
    if (_favItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _favItems.putIfAbsent(
        productId,
        () => FavAttr(
          id: DateTime.now().toString(),
          title: title,
          imageUrl: imageUrl,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _favItems.remove(productId);
    notifyListeners();
  }

  void clearFav() {
    _favItems.clear();
    notifyListeners();
  }
}
