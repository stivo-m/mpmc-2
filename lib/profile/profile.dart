import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';
import 'package:mpmc/authentication/login/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 40,
          left: 100,
          right: 100,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: NetworkImage(respository.user.photoUrl),
            ),
          ),
        ),
        Positioned(
          top: 370,
          right: 100,
          left: 100,
          child: Column(
            children: <Widget>[
              Text(" Name: ${respository.user.displayName}"),
              SizedBox(
                height: 20,
              ),

              Text(" Email: ${respository.user.email}"),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MaterialButton(
              child: Text("LOGOUT"),
              color: Colors.red,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              onPressed: () {
                respository.signOut().then((val) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                });
              }),
        )
      ],
    );
  }
}
