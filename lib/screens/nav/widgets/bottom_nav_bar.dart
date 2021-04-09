import 'package:flutter/material.dart';
import '../../../enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  }) : super(key: key);

  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items
          .map(
            (item, icon) => MapEntry(
              item.toString(),
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    icon,
                    size: 30.0,
                  )),
            ),
          )
          .values
          .toList(),
    );
  }
}
