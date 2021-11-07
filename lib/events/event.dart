import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpmc/dashboard/dashboard.dart';
import 'bloc/bloc.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<String> titles, subtitles;
  List<Color> colors;
  List<Function> functions;

  @override
  void initState() {
    titles = [
      "Add",
    ];

    subtitles = [
      "Event",
    ];

    colors = [Colors.blue, Colors.purple, Colors.orange, Colors.green];

    functions = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return CustomHomeCards(
                color: colors[index],
                onPress: () {
                  switch (index) {
                    case 0:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddNewEventPage()));
                  }
                },
                subtitle: subtitles[index],
                title: titles[index],
              );
            },
          ),

          // list of the events

          EventsLists()
        ],
      ),
    );
  }
}

class EventsLists extends StatefulWidget {
  @override
  _EventsListsState createState() => _EventsListsState();
}

class _EventsListsState extends State<EventsLists> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: respository.db.collection("Events").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    "No Events",
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
                  children: snapshot.data.documents.map<Widget>((events) {
                    return Banner(
                      message: "Completed",
                      location: BannerLocation.topEnd,
                      color: Colors.green,
                      child: ListTile(
                        leading: Image.asset("assets/image_placeholder.jpg"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EventsListPage(currentEvent: events)));
                        },
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        title: Text(events.data["description"]),
                        subtitle: Text(events.data["venue"]),
                        trailing: Text(events.data["date"]),
                      ),
                    );
                  }).toList());
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class AddNewEventPage extends StatefulWidget {
  @override
  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title, theme, date, venue;
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        builder: (context) => EventsBloc(),
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return _buildBody(context);
          },
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Add New Event",
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 50),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 150,
                      minWidth: MediaQuery.of(context).size.width / 2,
                      maxHeight: 300,
                      minHeight: 150,
                    ),
                    child: Image.asset("assets/image_placeholder.jpg"),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  enabled: !submitting,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Enter Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                  validator: (val) {
                    if (val.length < 2) {
                      return "Title cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String val) {
                    title = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enabled: !submitting,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Enter Theme",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                  validator: (val) {
                    if (val.length < 2) {
                      return "Theme cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String val) {
                    theme = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enabled: !submitting,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Enter Venue",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                  validator: (val) {
                    if (val.length < 2) {
                      return "Venue cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String val) {
                    venue = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enabled: !submitting,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      labelText: "Enter Date",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                  validator: (val) {
                    if (val.length < 2) {
                      return "Date cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String val) {
                    date = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.teal,
                  disabledColor: Theme.of(context).disabledColor,
                  onPressed: submitting
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            BlocProvider.of<EventsBloc>(context).dispatch(
                                AddEvent(
                                    date: date,
                                    venue: venue,
                                    theme: theme,
                                    description: title));
                          }
                        },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: BlocListener<EventsBloc, EventsState>(
                      listener: (context, state) {
                        if (state is AddingEventState) {
                          if (state.processing) {
                            setState(() {
                              submitting = true;
                            });
                            CircularProgressIndicator();
                          }
                        }

                        if (state is EventAdded) {
                          if (state.success) {
                            setState(() {
                              submitting = false;
                            });
                            Icon(Icons.verified_user, color: Colors.white);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(state.state,
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                            ));

                            Future.delayed(Duration(seconds: 5)).then((val) {
                              Navigator.pop(context);
                            });
                          }
                        }

                        if (state is EventError) {
                          if (state.success == false) {
                            setState(() {
                              submitting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(state.state,
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      child: submitting
                          ? CircularProgressIndicator()
                          : Text("ADD EVENT"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventsListPage extends StatelessWidget {
  final DocumentSnapshot currentEvent;

  const EventsListPage({Key key, this.currentEvent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 100,
                    minWidth: MediaQuery.of(context).size.width / 2,
                    maxHeight: 300,
                    minHeight: 150,
                  ),
                  child: Image.asset("assets/image_placeholder.jpg"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Title: ${currentEvent.data["description"].toUpperCase()}"),
              SizedBox(
                height: 20,
              ),
              Text("Venue: ${currentEvent.data["venue"]}"),
              SizedBox(
                height: 20,
              ),
              Text("Date: ${currentEvent.data["date"]}"),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text("ATTENDING ?"),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text("Delete"),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
