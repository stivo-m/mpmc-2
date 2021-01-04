import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mpmc/events/bloc/bloc.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class UserRespository {
  Firestore db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  handleMpesaInitialization() {
    MpesaFlutterPlugin.setConsumerKey("jNsONUzVRfZCc0p9QZjTc7TVJfnufhwB");
    MpesaFlutterPlugin.setConsumerSecret("N2eUp4Nq9TwGl8AI");
  }

  Future payWithMpesa(String desc, double amount, String number) async {
    dynamic transactionInitialisation;
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: number,
          partyB: "174379",
          callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
          accountReference: desc,
          phoneNumber: number,
          baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
          transactionDesc: desc,
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());

      /*Update your db with the init data received from initialization response,
      * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  Future addEventToList(AddEvent event) async {
    await respository.db.collection("Events").add({
      "theme": event.theme,
      "date": event.date,
      "title": event.description,
      "venue": event.venue,
      "added_by": respository.user.email,
      "last_updated": DateTime.now()
    }).catchError((onError) {
      print(onError.toString());
    }).then((onValue) {
      print(onValue.documentID);
    });
  }

  Future detleteEvent(String id) async {
    await respository.db
        .collection("Events")
        .document(id)
        .delete()
        .catchError((onError) {
      print(onError.toString());
    });
  }

  Future signOut() async {
    //await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  userID() async {
    return await currentUser().then((u) => u.uid);
  }

  Future<DocumentSnapshot> getUserData(String id) async {
    return await db.collection("users").document(user.uid).get();
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
          user = authResult.user;
          await user.reload();
        })
        .then((doc) {
          handleMpesaInitialization();
        })
        .whenComplete(() => _updateLastLogin(user))
        .catchError((e) => print("LoginError: $e"));
    return user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String password, String name, String number) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((AuthResult authResult) async {
      user = authResult.user;
      handleMpesaInitialization();
     

      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      info.photoUrl = "https://static.thenounproject.com/png/538846-200.png";

      await user.updateProfile(info);
      await user.reload();
       await _saveUserData(user, name, number);
      user.sendEmailVerification();
    });

    return user;
  }

  Future<FirebaseUser> googleSignin() async {
    GoogleSignInAccount googleAccount;

    googleAccount = await _getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }

    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    user = await _auth.signInWithCredential(credential).then((authResult) {
      return authResult.user;
    }).whenComplete(() {});

    return user == null ? null : user;
  }

  Future<GoogleSignInAccount> _getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future _saveUserData(FirebaseUser user, String name, String number) async {
    if (user != null) {
      DocumentReference data = db.document("users/" + user.uid);
      await data.setData({
        "name" : name,
        "photoURL" : "https://static.thenounproject.com/png/538846-200.png",
        "uid": user.uid,
        "email": user.email,
        "isVerified": user.isEmailVerified,
        "number": number,
      }, merge: true);
    }
  }

  void _updateLastLogin(FirebaseUser user) async {
    if (user != null) {
      await db.collection("users").document(user.uid).setData({
        "uid": user.uid,
        "last_seen": DateTime.now(),
      });
    }
  }
}

UserRespository respository = UserRespository();

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
