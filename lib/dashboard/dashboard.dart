import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> updates, descriptions;
  List<Icon> icons;

  @override
  void initState() {
    super.initState();

    updates = [
      "New Members",
      "Recent Talks",
      "Future Events",
      "Upcoming Meetings"
    ];

    descriptions = [
      "Click to meet new Members",
      "View Last Blog Topics",
      "Know when next events occur",
      "Know next meeting dates"
    ];

    icons = [
      Icon(
        Icons.person_add,
        size: 40,
      ),
      Icon(
        Icons.book,
        size: 40,
      ),
      Icon(
        Icons.event_available,
        size: 40,
      ),
      Icon(
        Icons.edit,
        size: 40,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Dashboard",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontSize: 35, fontWeight: FontWeight.w200),
            ),
            SizedBox(
              height: 20,
            ),
            CustomHomeCards(
              title: "Last Monthly Contributions",
              subtitle: "May 2019",
              color: Colors.red,
              onPress: () {},
            ),
            CustomHomeCards(
              title: "Last Meeting Minutes",
              subtitle: "July 2019",
              color: Colors.yellow[800],
              onPress: () {},
            ),
            CustomHomeCards(
              title: "Meet the",
              subtitle: "Team",
              color: Colors.purple,
              onPress: () {},
            ),
            CustomHomeCards(
              title: "Meet the",
              subtitle: "Members",
              color: Colors.blue,
              onPress: () {},
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Recent Updates",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontSize: 35, fontWeight: FontWeight.w200),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Divider(
                  height: 5,
                  color: Colors.white54,
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    onTap: () {},
                    leading: icons[index],
                    title: Text(
                      updates[index],
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: 20, fontWeight: FontWeight.w200),
                    ),
                    subtitle: Text(
                      descriptions[index],
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomHomeCards extends StatelessWidget {
  final Function onPress;
  final String title, subtitle;
  final Color color;

  const CustomHomeCards(
      {Key key,
      @required this.onPress,
      @required this.title,
      @required this.subtitle,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: onPress,
        elevation: 10,
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Text(subtitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 35,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
