import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:machine_test/provider/changescreen.dart';

class BottomNav extends StatelessWidget {
  
  const BottomNav({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return SafeArea(
          child: Container(
            // margin: EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  context: context,
                  iconPath: 'assets/icons/home.png',
                  label: 'Home',
                  index: 0,
                  notifier: mainScreenNotifier,
                ),
                _buildNavItem(
                  context: context,
                  iconPath: 'assets/icons/menu.png',
                  label: 'Categories',
                  index: 1,
                  notifier: mainScreenNotifier,
                  iconSize: 27
                ),
                _buildNavItem(
                  context: context,
                  iconPath: 'assets/images/logog.png',
                  label: 'Deals',
                  index: 2,
                  notifier: mainScreenNotifier,
                  iconSize: 35
                  
                ),
                _buildNavItem(
                  context: context,
                  iconPath: 'assets/icons/cart.png',
                  label: 'Cart',
                  index: 3,
                  notifier: mainScreenNotifier,
                ),
                _buildNavItem(
                  context: context,
                  iconPath: 'assets/icons/user.png',
                  label: 'Profile',
                  index: 4,
                  notifier: mainScreenNotifier,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    
    double iconSize=30,
    required BuildContext context,
    required String iconPath,
    required String label,
    required int index,
    required MainScreenNotifier notifier,
  }) {
    return GestureDetector(
      onTap: () {
        notifier.pageIndex = index;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            color: notifier.pageIndex == index ? Colors.red : Colors.grey,
            height: iconSize,
            width: iconSize
          ),
          Text(label,style: TextStyle(color: notifier.pageIndex == index ? Colors.red : Colors.grey, ),),
        ],
      ),
    );
  }
}
