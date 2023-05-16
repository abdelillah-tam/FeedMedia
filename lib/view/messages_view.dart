import 'package:feedmedia/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final TextEditingController _searchChats;

  @override
  void initState() {
    _searchChats = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color.fromRGBO(236, 248, 255, 1.0),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(
              236, 248, 255, 1.0),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            backgroundColor: const Color.fromRGBO(236, 248, 255, 1.0),
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Chat with your all\nFeedMedia friends',
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextField(
                    controller: _searchChats,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 9.0,
                          color: blue,
                        ),
                        borderRadius: BorderRadius.circular(360.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.1,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(360.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 9.0,
                          color: blue,
                        ),
                        borderRadius: BorderRadius.circular(360.0),
                      ),
                      labelStyle:
                          TextStyle(fontSize: (height < 720 ? 12 : 16.0)),
                      labelText: 'Search',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
