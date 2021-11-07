import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_lists.dart';
import 'package:mpmc/chat/screens/new_chat.dart';
import 'package:mpmc/dashboard/dashboard.dart';
import 'package:mpmc/events/event.dart';
import 'package:mpmc/money/money.dart';
import 'package:mpmc/prefrence/pref.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mpmc/profile/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _pages = ["Home", "Chats", "Money", "Events", "Profile"];
  final List<Widget> _screens = [
    Dashboard(),
    ChatListsScreen(),
    MoneyScreen(),
    EventsScreen(),
    ProfileScreen()
  ];
  int index = 1;

  void initUser() async {
    respository.user = await respository.currentUser();
  }

  @override
  void initState() {
    initUser();
    super.initState();
  }

  void _updatePages(count) {
    setState(() {
      index = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: index == 0
            ? Text(
                "Welcome, Steven Maina",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 25, fontWeight: FontWeight.w200),
              )
            : Text(
                _pages[index],
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 25, fontWeight: FontWeight.w200),
              ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Preference()));
            },
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        buttonBackgroundColor: Theme.of(context).bottomAppBarColor,
        color: Theme.of(context).bottomAppBarTheme.color,
        onTap: _updatePages,
        items: <Widget>[
          Icon(
            Icons.dashboard,
          ),
          Icon(Icons.message),
          Icon(Icons.money_off),
          Icon(Icons.event_available),
          Icon(Icons.person),
        ],
      ),
      body: _screens[index],
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildFloatingActionButtons() {
    Widget widget = Container();
    if (index == 1) {
      widget = buildChatFloatingButton();
    } else if (index == 3) {
      widget = buildAddEventFloatingButton();
    } else {
      widget = Container();
    }
    return widget;
  }

  FloatingActionButton buildChatFloatingButton() {
    return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).iconTheme.color,
        child: Icon(Icons.chat_bubble),
        heroTag: 1,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => NewChat()));
        });
  }

  FloatingActionButton buildAddEventFloatingButton() {
    return null;
  }
}
