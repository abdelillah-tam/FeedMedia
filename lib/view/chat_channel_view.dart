import 'package:feedmedia/constants.dart';
import 'package:feedmedia/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatChannelView extends StatefulWidget {
  const ChatChannelView({Key? key}) : super(key: key);

  @override
  State<ChatChannelView> createState() => _ChatChannelViewState();
}

class _ChatChannelViewState extends State<ChatChannelView> {
  final UserController _userController = Get.find();
  late final TextEditingController _messageTextController;

  @override
  void initState() async {
    _messageTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 108.0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360.0),
                child: Image.network(
                  'https://i.stack.imgur.com/oVKTL.jpg',
                  height: 100.0,
                ),
              ),
            ),
            toolbarHeight: 108.0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Color.fromRGBO(236, 248, 255, 1.0),
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
            ),
            backgroundColor: const Color.fromRGBO(236, 248, 255, 1.0),
          ),
          SliverPersistentHeader(
              delegate: _AccountHeaderDelegate(firstName: '', lastName: '')),
          SliverPersistentHeader(delegate: _CornerHeaderDelegate()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 60.0 + bottomInsets,
        padding: EdgeInsets.only(bottom: bottomInsets),
        child: TextField(
          expands: true,
          maxLines: null,
          minLines: null,
          controller: _messageTextController,
          decoration: InputDecoration(
            hintText: 'Write a reply...',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintStyle: const TextStyle(color: lightBlue),
            contentPadding: const EdgeInsets.only(
              left: 32.0,
            ),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.add, size: 28.0, color: lightBlue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.add, size: 28.0, color: lightBlue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.add, size: 28.0, color: lightBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }
}

class _AccountHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String firstName;
  final String lastName;

  _AccountHeaderDelegate({required this.firstName, required this.lastName});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 248, 255, 1.0),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '$firstName $lastName',
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Active',
                style: TextStyle(color: lightBlue, fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _CornerHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color.fromRGBO(236, 248, 255, 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18.0),
              ),
              color: Colors.white),
          height: 22.0,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 38.0;

  @override
  double get minExtent => 38.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
