import 'package:flutter/material.dart';
import 'page_manager.dart';
import '../instance.dart';

class SquareDetailWidget extends StatelessWidget {
  const SquareDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.url,
      builder: (_, value, __) {
        return Image.network(value);
      },
    );
  }

}