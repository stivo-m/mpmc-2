import 'package:flutter/material.dart';
import 'package:mpmc/authentication/Utils.dart';

class AddMember extends StatefulWidget {
  const AddMember() : super();

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

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
              "Add a new member",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                label: Text("Full Name"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                label: Text("Phone number"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RawMaterialButton(
              child: Text("Add record"),
              onPressed: () async {
                await respository.addMemberTolist(
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
