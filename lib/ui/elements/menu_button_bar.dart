import 'package:flutter/material.dart';
import 'menu_button.dart';


class BottomMenuBar extends StatelessWidget {
  final int currentIndex;
  final PageController pageController;
  final List<MenuItem> items;

  const BottomMenuBar({
    super.key,
    required this.currentIndex,
    required this.pageController,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) =>
          MenuButton(
            item: item,
            currentIndex: currentIndex,
            pageController: pageController,
          ),
      ).toList(),
    );
  }
}