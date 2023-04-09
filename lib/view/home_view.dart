import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/view/create_post_view.dart';
import 'package:feedmedia/view/messages_view.dart';
import 'package:feedmedia/view/profile_view.dart';
import 'package:feedmedia/view/search_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'destination.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  static const List<Widget> allWidgets = [
    HomeView(),
    SearchView(),
    CreatePostView(),
    MessagesView(),
    ProfileView(),
  ];

  static const List<Destination> allDestinations = [
    Destination(index: 0, label: 'Home', iconData: Icons.home_outlined),
    Destination(index: 1, label: 'Search', iconData: Icons.search_rounded),
    Destination(index: 2, label: 'Add', iconData: Icons.add_circle_rounded),
    Destination(index: 3, label: 'Messages', iconData: Icons.email_outlined),
    Destination(
        index: 4, label: 'Profile', iconData: Icons.account_circle_outlined),
  ];

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _currentIndex == 0 ? AppBar(
            leading: Container(),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ) : null,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromRGBO(1, 10, 28, 1.0),
            unselectedItemColor: const Color.fromRGBO(177, 188, 208, 1.0),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: allDestinations
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(e.iconData),
                    label: e.label,
                  ),
                )
                .toList(),
          ),
          body: allWidgets[_currentIndex],
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final PostController _postController = Get.put(PostController());


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const Text(
            'My Feeds',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
