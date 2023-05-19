import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/iconpack/feed_media_icons_icons.dart';
import 'package:feedmedia/utilities/dialogs/loading_screen.dart';
import 'package:feedmedia/view/create_post_view.dart';
import 'package:feedmedia/view/messages_view.dart';
import 'package:feedmedia/view/profile_view.dart';
import 'package:feedmedia/view/search_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controller/user_controller.dart';
import '../model/full_post.dart';
import '../model/user.dart';
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
    Destination(index: 0, label: 'Home', iconData: FeedMediaIcons.home),
    Destination(index: 1, label: 'Search', iconData: FeedMediaIcons.search),
    Destination(index: 2, label: 'Add', iconData: Icons.add),
    Destination(index: 3, label: 'Messages', iconData: FeedMediaIcons.chat),
    Destination(index: 4, label: 'Profile', iconData: FeedMediaIcons.user),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                leading: Container(),
                title: const Text(
                  'FeedMedia',
                ),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  systemNavigationBarColor: Color.fromRGBO(236, 248, 255, 1.0),
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: darkBlue,
          backgroundColor: _currentIndex == 0 ? const Color.fromRGBO(236, 248, 255, 1.0) : Colors.white,
          useLegacyColorScheme: false,
          selectedFontSize: 0.0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: allDestinations
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: InkWell(
                      child: e.label == 'Add'
                          ? Container(
                              decoration: const BoxDecoration(color: blue, shape: BoxShape.circle),
                              child: Icon(e.iconData, color: Colors.white, size: 50.0),
                            )
                          : Icon(e.iconData, color: null, size: 30.0),
                    ),
                  ),
                  label: e.label,
                ),
              )
              .toList(),
        ),
        body: allWidgets[_currentIndex],
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
  final PostController _postController = Get.find();
  final UserController _userController = Get.find();

  ValueNotifier<List<FullPost>?> listNotifier = ValueNotifier(List.empty());

  late User _currentUser;

  bool _isLoading = true;

  @override
  void initState() {
    _currentUser = _userController.user!;
    _postController
        .getFollowingPosts(
      userToken: _currentUser.userToken!,
      currentFollowersObjectId: _currentUser.followersObjectId,
      currentUserObjectId: _currentUser.objectId!,
    )
        .then((value) {
      if (value == null) {
        _isLoading = false;
        listNotifier.value = value;
      }
    });

    _postController.homePosts.listenAndPump((event) {
      _isLoading = false;
      listNotifier.value = List.of(event);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoadingScreen().hide();
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'My Feeds',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<FullPost>?>(
                  valueListenable: listNotifier,
                  builder: (context, value, child) {
                    if (!_isLoading) {
                      if (value != null) {
                        if (value.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: Container(
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        side: BorderSide(width: 0.5, color: coldBlue),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Image.network('https://i.stack.imgur.com/oVKTL.jpg', width: 40.0),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  '${value[index].user!.firstName} ${value[index].user!.lastName}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(value[index].post!.post, style: const TextStyle(fontSize: 16.0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 24.0),
                                            child: Text(
                                              '${value[index].likesCount} likes',
                                              style: const TextStyle(color: lightBlue, fontSize: 15.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onDoubleTap: () {
                                                    _reactToPost(value[index], index);
                                                  },
                                                  onTap: () {
                                                    _reactToPost(value[index], index);
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        value[index].isLiker! ? Icons.thumb_up_alt_rounded : Icons.thumb_up_outlined,
                                                        color: lightBlue,
                                                        size: 30.0,
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 8.0),
                                                        child: Text('Like', style: TextStyle(color: lightBlue, fontSize: 15.0)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Row(
                                                    children: const [
                                                      Icon(FeedMediaIcons.comment, color: lightBlue, size: 30.0),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 8.0),
                                                        child: Text('Comment', style: TextStyle(color: lightBlue, fontSize: 15.0)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Row(
                                                    children: const [
                                                      Icon(FeedMediaIcons.bookmark, color: lightBlue, size: 30.0),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 8.0),
                                                        child: Text('Bookmark', style: TextStyle(color: lightBlue, fontSize: 15.0)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: value.length,
                            ),
                          );
                        } else if (value.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/emptybox.png', height: 120.0,),
                                const Text('No one has posted !', style: TextStyle(fontSize: 20.0)),
                              ],
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text('You are not following anyone!', style: TextStyle(fontSize: 20.0)),
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator(color: blue));
                  }),
            )
          ],
        ));
  }

  _reactToPost(FullPost fullPost, int index) async {
    if (fullPost.isLiker! && fullPost.likerObjectId != null) {
      listNotifier.value?[index].likerObjectId = null;
      listNotifier.value?[index].likesCount -= 1;
      listNotifier.value?[index].isLiker = false;
      listNotifier.notifyListeners();
      _postController.react(
          postObjectId: fullPost.post!.objectId,
          likerObjectId: _currentUser.objectId!,
          userToken: _currentUser.userToken!,
          index: index,
          likeBool: false);
    } else {
      listNotifier.value?[index].likerObjectId = _currentUser.objectId;
      listNotifier.value?[index].likesCount += 1;
      listNotifier.value?[index].isLiker = true;
      listNotifier.notifyListeners();
      _postController.react(
          postObjectId: fullPost.post!.objectId,
          likerObjectId: _currentUser.objectId!,
          userToken: _currentUser.userToken!,
          index: index,
          likeBool: true);
    }
  }
}
