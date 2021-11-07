import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListMembers extends StatelessWidget {
  const ListMembers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "List of members",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: respository.getMembers(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // case where the app is loading
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data.documents.length == 0) {
                  return Text("No records found");
                }

                // success case. Snapshot has data
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot user = snapshot.data.documents[index];

                    return ListTile(
                      title: Text(user["name"]),
                      subtitle: Text(user["phoneNumber"]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
