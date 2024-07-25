// import 'package:flutter/material.dart';
// import 'package:pitchme/screen/home_screen.dart';
// import 'package:pitchme/screen/profile_screen.dart';
// import 'package:pitchme/screen/setting_screen.dart';
// import 'package:pitchme/screen/create_ptch_screen.dart';
// import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

// class HiddenDrawer extends StatefulWidget {
//   const HiddenDrawer({super.key});

//   @override
//   State<HiddenDrawer> createState() => _HiddenDrawerState();
// }

// class _HiddenDrawerState extends State<HiddenDrawer> {
//   List<ScreenHiddenDrawer> _page = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _page = [
//       ScreenHiddenDrawer(
//           ItemHiddenMenu(
//               colorLineSelected: Colors.white,
//               name: 'Home',
//               baseStyle: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//               selectedStyle: TextStyle(color: Colors.white)),
//           HomeScreen()),
//       ScreenHiddenDrawer(
//           ItemHiddenMenu(
//               colorLineSelected: Colors.white,
//               name: 'Profile',
//               baseStyle: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//               selectedStyle: TextStyle()),
//           ProfileScreen()),
//       ScreenHiddenDrawer(
//           ItemHiddenMenu(
//               colorLineSelected: Colors.white,
//               name: 'Create pitch',
//               baseStyle: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//               selectedStyle: TextStyle()),
//           CreatePitchScreen()),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HiddenDrawerMenu(
//       boxShadow: [
//         BoxShadow(color: Colors.white, offset: Offset(5, 4), blurRadius: 5)
//       ],
//       screens: _page,
//       backgroundColorMenu: Colors.black,
//       initPositionSelected: 0,
//       slidePercent: 60,
//       contentCornerRadius: 10,
//     );
//   }
// }
