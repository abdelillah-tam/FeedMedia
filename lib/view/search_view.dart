import 'package:feedmedia/constants.dart';
import 'package:feedmedia/controller/user_controller.dart';
import 'package:feedmedia/iconpack/feed_media_icons_icons.dart';
import 'package:feedmedia/move_to_page.dart';
import 'package:feedmedia/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/user.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchTextController;

  final UserController _userController = Get.find();

  List<User?> users = List.empty();

  @override
  void initState() {
    _searchTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchTextController,
              cursorWidth: 1.0,
              cursorHeight: (height < 720 ? 15 : 20.0),
              cursorRadius: const Radius.circular(18.0),
              decoration: InputDecoration(
                labelText: 'Search in FeedMedia',
                labelStyle: TextStyle(
                  fontSize: (height < 720 ? 12 : 16.0),
                ),
                prefixIcon: const Icon(FeedMediaIcons.search),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              style: const TextStyle(color: darkBlue),
              keyboardType: TextInputType.text,
              autocorrect: false,
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  final result = await _userController.searchUsers(value);
                  setState(() {
                    users = result;
                  });
                } else {
                  setState(() {
                    users.clear();
                  });
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        createRoute(
                          ProfileView(objectId: users[index]!.objectId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${users[index]!.firstName} ${users[index]!.lastName}',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              width: double.infinity,
                              height: 0.1,
                              color: darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: users.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
