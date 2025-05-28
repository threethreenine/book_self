import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String label;
  final int index;

  const MenuItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}

class MenuButton extends StatelessWidget {
  final MenuItem item;
  final int currentIndex;
  final PageController pageController;

  const MenuButton({
    super.key,
    required this.item,
    required this.currentIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentIndex == item.index;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final iconColor = isActive ? colorScheme.primary : colorScheme.onSurface.withAlpha(150);
    final labelColor = isActive  ? colorScheme.primary : colorScheme.onSurface.withAlpha(150);

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: 24,
            ),
            child: IconButton(
              icon: Icon(item.icon),
              splashRadius: 20,
              onPressed: _switchPage,
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: textTheme.labelSmall!.copyWith(
              color: labelColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }

  void _switchPage() {
    pageController.animateToPage(
      item.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

