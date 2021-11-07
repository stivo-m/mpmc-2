import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/chat/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpmc/chat/chat_utils.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot chatUser;

  const ChatScreen({Key key, @required this.chatUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.chatUser.data["name"],
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        builder: (context) => ChatBloc(),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _chatLogSection(context),
        ),
        BottomInputField(
          state: state,
          controller: _controller,
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).dispatch(SendMessage(
                message: _controller.text,
                sender: respository.user.uid,
                recipient: widget.chatUser.data["uid"]));

            setState(() {
              _controller.clear();
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 100));
            });
          },
        ),
      ],
    );
  }

  Widget _chatLogSection(BuildContext contex) {
    String chatID =
        chat.getChatId(widget.chatUser.data["uid"], respository.user.uid);
    return StreamBuilder(
        stream: respository.db
            .collection("Chats")
            .orderBy("sent_at")
            .where("id", isEqualTo: chatID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text(
                  "No Messages. Start Chat",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 17),
                ),
              );
            }

            return ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: false,
                controller: _scrollController,
                children: snapshot.data.documents.map<Widget>((msg) {
                  bool isMine = msg.data["sender"] == respository.user.uid;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: isMine
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: <Widget>[
                        isMine
                            ? CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image:
                                      NetworkImage(respository.user.photoUrl),
                                ),
                              )
                            : Container(),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 200,
                          ),
                          child: Bubble(
                            padding: BubbleEdges.all(20),
                            margin: BubbleEdges.only(top: 10),
                            stick: true,
                            color: isMine ? Colors.blue : Colors.green,
                            nip: isMine
                                ? BubbleNip.leftBottom
                                : BubbleNip.rightBottom,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: isMine
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    msg.data["message"],
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  DateFormat("Hm")
                                      .format(msg.data["sent_at"].toDate()),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        !isMine
                            ? CircleAvatar(
                                radius: 30,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }).toList());
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class BottomInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressed, pickImage;
  final bool isGroup;
  final ChatState state;

  BottomInputField(
      {Key key,
      @required this.controller,
      @required this.onPressed,
      this.pickImage,
      @required this.state,
      this.isGroup = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _onChanged() {
      controller.addListener(() {
        if (isGroup) {
          if (controller.text.hashCode == "@".hashCode) {
            print("Finally");
            return;
          } else {
            print("Not Yet @");
          }
        }
      });
    }

    return Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 8),
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white10,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15),
              child: TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  hintText: 'Your Message',
                ),
                onChanged: _onChanged(),
                controller: controller,
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.attach_file),
              iconSize: 23,
              onPressed: pickImage),
          IconButton(icon: Icon(Icons.send), iconSize: 23, onPressed: onPressed)
        ],
      ),
    );
  }
}
