import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keshav_s_application2/presentation/home_screen/home_screen.dart';
import 'package:keshav_s_application2/presentation/log_in_screen/log_in_screen.dart';
import 'package:keshav_s_application2/presentation/otp_screen/models/otp_model.dart';
import 'package:keshav_s_application2/presentation/profile_one_screen/profile_one_screen.dart';
import 'package:keshav_s_application2/presentation/profile_screen/profile_screen.dart';
import 'package:keshav_s_application2/presentation/store_screen/store_screen.dart';
import 'package:keshav_s_application2/screenwithoutlogin/profilescreenwithoutLogin.dart';
import 'package:keshav_s_application2/presentation/cart_screen/models/cart_model.dart'
    as carts;
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'StoreScreen1.dart';
import 'homescreen1.dart';

class landingPage1 extends StatefulWidget {
  @override
  State<landingPage1> createState() => _landingPage1State();
}

class _landingPage1State extends State<landingPage1> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen1(),
      StoreScreen1(),
      ProfileScreenWithoutLogin(),
    ];
  }

  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: Icon(
  //         Icons.home,
  //       ),
  //       title: ("Home".toUpperCase()),
  //       activeColorPrimary: Color(0xff65236A),
  //       inactiveColorPrimary: Color(0xff949494),
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(
  //         Icons.storefront,color: Colors.grey,
  //       ),
  //       title: ("Store"),
  //       activeColorPrimary: Color(0xff65236A),
  //       inactiveColorPrimary: Color(0xff949494),
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(
  //         Icons.person,
  //       ),
  //       title: ("Profile".toUpperCase()),
  //       activeColorPrimary: Color(0xff65236A),
  //       inactiveColorPrimary: Color(0xff949494),
  //     ),
  //   ];
  // }

  Future<bool> _onWillPop(BuildContext? context) async {
    return (await showDialog(
          context: context!,
          builder: (context) => new AlertDialog(
            elevation: 24,
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            title: new Text(
              'Are you sure?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: new Text('Do you want to exit the App',
                style: TextStyle(fontWeight: FontWeight.w400)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No',
                    style: TextStyle(fontWeight: FontWeight.w400)),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes',
                    style: TextStyle(fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen1(),
          item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
              activeForegroundColor: Color(0xff65236A),
              inactiveBackgroundColor: Color(0xff949494)),
        ),
        PersistentTabConfig(
          screen: StoreScreen1(),
          item: ItemConfig(
              icon: Icon(Icons.storefront, color: Colors.grey),
              title: "Store",
              activeForegroundColor: Color(0xff65236A),
              inactiveBackgroundColor: Color(0xff949494)),
        ),
        PersistentTabConfig(
          screen: ProfileScreenWithoutLogin(),
          item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Profile",
              activeForegroundColor: Color(0xff65236A),
              inactiveBackgroundColor: Color(0xff949494)),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style15BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
    // Scaffold(
    // backgroundColor:ColorConstant.purple50,
    // bottomNavigationBar: Container(
    //   margin: EdgeInsets.only(bottom: 0),
    //   child:
    // PersistentTabView(
    //   context,
    //   controller: _controller,
    //   onWillPop: (context) =>
    //       _onWillPop(context!),
    //   screens: _buildScreens(),
    //   items: _navBarsItems(),
    //   confineInSafeArea: true,
    //   backgroundColor: Color(0xffFFFFFF), // Default is Colors.white.
    //   handleAndroidBackButtonPress: true, // Default is true.
    //   resizeToAvoidBottomInset:
    //   true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
    //   stateManagement: true, // Default is true.
    //   hideNavigationBarWhenKeyboardShows:
    //   true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
    //   decoration: NavBarDecoration(
    //     borderRadius: BorderRadius.circular(10.0),
    //     colorBehindNavBar: Colors.white70,
    //   ),
    //   popAllScreensOnTapOfSelectedTab: true,
    //   popActionScreens: PopActionScreensType.all,
    //   itemAnimationProperties: ItemAnimationProperties(
    //     // Navigation Bar's items animation properties.
    //     duration: Duration(milliseconds: 200),
    //     curve: Curves.ease,
    //   ),
    //   screenTransitionAnimation: ScreenTransitionAnimation(
    //     // Screen transition animation on change of selected tab.
    //     animateTabTransition: true,
    //     curve: Curves.ease,
    //     duration: Duration(milliseconds: 200),
    //   ),
    //   navBarStyle:
    //   NavBarStyle.style15, // Choose the nav bar style with this property.
    // );
    //   ),
    // );
  }
}
