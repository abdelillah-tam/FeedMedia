import 'package:feedmedia/constants.dart';
import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/move_to_page.dart';
import 'package:feedmedia/view/authentication_view.dart';
import 'package:feedmedia/view/chat_channel_view.dart';
import 'package:feedmedia/view/edit_profile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';

class ProfileView extends StatefulWidget {
  final String? objectId;

  const ProfileView({Key? key, this.objectId}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: coldBlue),
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 0.0,
            shadowColor: lightBlue,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  height: 30.0,
                  value: 0,
                  child: const Text('Log out'),
                  onTap: () async {
                    final result = await _userController.logout();
                    result && mounted
                        ? Navigator.of(context)
                            .pushReplacement(createRoute(const AuthenticationView()))
                        : print('error');
                  },
                ),
              ];
            },
          )
        ],
        actionsIconTheme: const IconThemeData(color: lightBlue, size: 26.0),
        leading: widget.objectId != null
            ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: darkBlue,
                ),
              )
            : null,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
        ),
      ),
      body: widget.objectId != null
          ? FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return ProfileBody(user: snapshot.data!);
                  default:
                    return const CircularProgressIndicator();
                }
              },
              future: _userController.getPublicUser(widget.objectId!),
            )
          : const ProfileBody(
              user: null,
            ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  final User? user;

  const ProfileBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find();
  final PostController _postController = Get.find();

  final ValueNotifier<int> followers = ValueNotifier(0);

  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<bool> _isFollower = ValueNotifier(false);

  late final User _currentUser;
  late final User? _user;

  late TabController _tabController;

  late Future<List<Post>> _getPosts;

  List<Post> posts = List.empty();
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Posts'),
  ];

  @override
  void initState() {
    _user = widget.user;
    _currentUser = _userController.user!;
    if (_user != null) {
      _userController
          .isFollower(
        targetedUserObjectId: _currentUser.objectId!,
        userObjectId: _user!.followersObjectId,
      )
          .then((value) {
        _isLoading.value = false;
        _isFollower.value = value;
      });
    }
    _getPosts = _postController.getPosts(
        _user == null ? _userController.user! : _user!,
        _userController.user!.userToken!);
    _tabController = TabController(length: tabs.length, vsync: this);
    _userController.followersCount.listenAndPump((value) {
      if (mounted) {
        followers.value = value;
      }
    });
    _userController.getFollowersCount(_user != null
        ? _user!.followersObjectId
        : _currentUser.followersObjectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              '0 Following',
            ),
            Image.network(
              'https://i.stack.imgur.com/oVKTL.jpg',
              width: 80.0,
            ),
            ValueListenableBuilder<int>(
              valueListenable: followers,
              builder: (context, value, child) {
                return Text(
                  '$value Followers',
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            '${_user != null ? _user!.firstName : _currentUser.firstName} ${_user != null ? _user!.lastName : _currentUser.lastName}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        _user == null
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      createRoute(
                        const EditProfileView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: blue),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder2<bool, bool>(
                    _isLoading,
                    _isFollower,
                    builder: (context, isLoading, isFollower, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                        child: SizedBox(
                          width: 120.0,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? () {}
                                : () async {
                                    _isLoading.value = true;
                                    if (!isFollower) {
                                      await _userController.follow(
                                        currentUserObjectId:
                                            _currentUser.objectId!,
                                        currentFollowersObjectId:
                                            _currentUser.followersObjectId,
                                        userObjectId: _user!.objectId!,
                                        userFollowersObjectId:
                                            _user!.followersObjectId,
                                        userToken: _currentUser.userToken!,
                                      );
                                    } else {
                                      await _userController.unfollow(
                                        currentUserObjectId:
                                            _currentUser.objectId!,
                                        currentFollowersObjectId:
                                            _currentUser.followersObjectId,
                                        userObjectId: _user!.objectId!,
                                        userFollowersObjectId:
                                            _user!.followersObjectId,
                                        userToken:
                                            _userController.user!.userToken!,
                                      );
                                    }
                                    await _userController
                                        .isFollower(
                                      targetedUserObjectId:
                                          _currentUser.objectId!,
                                      userObjectId: _user!.followersObjectId,
                                    )
                                        .then((value) {
                                      _isLoading.value = false;
                                      _isFollower.value = value;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: darkBlue),
                                borderRadius: BorderRadius.circular(360.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: blue,
                                    ),
                                  )
                                : Text(
                                    isFollower ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                      color: darkBlue,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                    child: const Text(''),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 8.0),
                    child: SizedBox(
                      width: 120.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(createRoute(const ChatChannelView()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: darkBlue),
                            borderRadius: BorderRadius.circular(360.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Message',
                          style: TextStyle(color: darkBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        TabBar(
          controller: _tabController,
          tabs: tabs,
          labelColor: blue,
          dividerColor: blue,
          indicatorColor: blue,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((Tab tab) {
              return FutureBuilder<List<Post>>(
                future: _getPosts,
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.done) {
                    if (state.data!.isNotEmpty) {
                      return _PostWidget(
                          state: state, user: _user ?? _currentUser);
                    } else {
                      return const Center(
                        child:
                            Text('No posts', style: TextStyle(color: darkBlue)),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: blue,
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isFollower.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}

class _PostWidget extends StatelessWidget {
  const _PostWidget({
    Key? key,
    required this.state,
    required this.user,
  }) : super(key: key);
  final AsyncSnapshot<List<Post>> state;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.data![index].post,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: state.data!.length,
    );
  }
}

class ValueListenableBuilder2<T, N> extends StatelessWidget {
  const ValueListenableBuilder2(
    this.first,
    this.second, {
    Key? key,
    required this.builder,
    required this.child,
  }) : super(key: key);

  final ValueListenable<T> first;
  final ValueListenable<N> second;
  final Widget child;
  final Widget Function(BuildContext context, T one, N two, Widget child)
      builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<N>(
            valueListenable: second,
            builder: (context, b, _) {
              return builder(context, a, b, child);
            });
      },
    );
  }
}
