import 'package:flutter/cupertino.dart';

class MyAppState extends ChangeNotifier {
  var current = 'pillpal here';


  var favorites = [];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}