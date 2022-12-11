import 'package:flutter/material.dart';
import 'image_generator.dart';


class PageManager {

  final squarePosition = ValueNotifier<Offset?>(null);
  final url = ValueNotifier<String>(ImageUrl.randomPictureUrl());

  void setSquarePosition(Offset offset) {
    squarePosition.value = offset;
    squarePosition.notifyListeners();
  }

  void changeImage(){
    url.value = ImageUrl.randomPictureUrl();
    url.notifyListeners();
  }

}
