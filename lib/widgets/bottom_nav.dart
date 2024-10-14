import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Color selectedIconColor = Color(0xFF034EA2);
  final Color unselectedIconColor = Color(0xFFB0BEC5);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/home.svg', color: widget.selectedIndex == 0 ? selectedIconColor : unselectedIconColor,),
          label: '',

        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/notification.svg' ,color: widget.selectedIndex == 1 ? selectedIconColor : unselectedIconColor,),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/order.svg', color: widget.selectedIndex == 2 ? selectedIconColor : unselectedIconColor,),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('lib/assets/icons/ic_user.svg', color: widget.selectedIndex == 3 ? selectedIconColor : unselectedIconColor,),
          label: '',
        ),
      ],
    );
  }
}
