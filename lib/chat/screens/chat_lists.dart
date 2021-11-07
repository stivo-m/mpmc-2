import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/screens/chat_screen.dart';

class ChatListsScreen extends StatefulWidget {
  @override
  _ChatListsScreenState createState() => _ChatListsScreenState();
}

class _ChatListsScreenState extends State<ChatListsScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: StreamBuilder(
            stream: Firestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Text(
                      "No Chats Available",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w100, fontSize: 17),
                    ),
                  );
                }

                return ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    reverse: false,
                    controller: _scrollController,
                    children: snapshot.data.documents.map<Widget>((users) {
                      return _buidChatListScreen(users);
                    }).toList());
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _buidChatListScreen(DocumentSnapshot doc) {
    return doc.data["uid"] == respository.user.uid
        ? Container()
        : StreamBuilder(
            stream: respository.db.collection("chat_list").snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data.documents.length == 0) {
                  return Center(
                    child: Text("No Active Chats"),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      chatUser: doc,
                                    )));
                          },
                          contentPadding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 10, left: 0),
                          leading: CircleAvatar(
                              maxRadius: 50,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 30,
                                    ),
                                  ),
                                  Positioned(
                                    top: 45,
                                    left: 65,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxHeight: 7, maxWidth: 7),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                    ),
                                  )
                                ],
                              )),
                          title: Text(doc.data["name"]),
                          subtitle: Text("",
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                          trailing: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "12:24pm",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 55),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Container();
            },
          );
  }
}
