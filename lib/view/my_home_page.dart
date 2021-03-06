import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furibase_firestore_write/auth/services/auth.dart';
import 'package:furibase_firestore_write/class/constant.dart';
import 'package:furibase_firestore_write/class/home_object.dart';
import 'package:furibase_firestore_write/view/show_all_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<UserLocal> getNameUidEmail() async {
    //getNameUidEmail
    //object: get the saved email, name and uid in SharedPreferences
    //input: void
    // Output: 1. UserLocal
    //            UserLocal is an object contains three string email, uid and name
    //         Show home_object.dart script
    final SharedPreferences prefs = await _prefs;
    final String nAme = (prefs.getString('name') ?? '');
    final String uId = (prefs.getString('uid') ?? '');
    final String eMail = (prefs.getString('email') ?? '');
    return UserLocal(email: eMail, uid: uId, name: nAme);
  }

  @override
  Widget build(BuildContext context) {
    //FireAuth.logOut(context: context);

    getHome({required DocumentReference<Home> fireHome}) async {
      //getHome
      // object: get the saved home in firebase and set in homeConstant
      // input: 1. DocumentReference<Home>
      // output: the saved home in firebase or new home object
      return await fireHome
          .get()
          .then((snapshot) => homeConstant = snapshot.data()!)
          .catchError((error, stackTrace) => homeConstant);
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<UserLocal>(
            //  FutureBuilder is used here to get the UserLocal (getNameUidEmail)
            future: getNameUidEmail(),
            builder: (BuildContext context, AsyncSnapshot<UserLocal> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var testUser = snapshot.data;
                    if (testUser != null && testUser.uid != '') {
                      // if snapshot has data, the data is used to create DocumentReference<Home> 'fireHome'
                      final fireHome = FirebaseFirestore.instance
                          .collection('User')
                          .doc(snapshot.data!.uid)
                          .withConverter<Home>(
                            fromFirestore: (snapshot, _) =>
                                Home.fromJson(snapshot.data()!),
                            toFirestore: (home, _) => home.toJson(),
                          );

                      UserLocal user = snapshot.data!;
                      // get home object from firebase
                      return FutureBuilder<Home>(
                          //  FutureBuilder is used here to get the home from firbase (getHome)
                          future: getHome(fireHome: fireHome),
                          builder: (BuildContext context,
                              AsyncSnapshot<Home> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  if (snapshot.data != null) {
                                    // if snapshot has data go to ShowAllObject class
                                    return ShowAllObject(
                                      size: size,
                                      user: user,
                                      fireHome: fireHome,
                                    );
                                  } else {
                                    FireAuth.logOut(context: context);
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }
                            }
                          });
                    } else {
                      FireAuth.logOut(context: context);
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              }
            }),
      ),
    );
  }
}

Future<void> setHomeInFirestore(
    // setHomeInFirestore
    // object: set Home In Firestore
    {required Home home,
    required DocumentReference<Home> fireHome}) async {
  await fireHome.set(home).then((value) => print('data add'));
}

/*title widget */
class title extends StatelessWidget {
  // title class return widget text
  // input: 1. size of screen
  //        2. titleName: String
  //output: 1. text  with specific character

  const title({
    Key? key,
    required this.size,
    required this.titleName,
  }) : super(key: key);

  final Size size;
  final String titleName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Text(
          titleName,
          style: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.03,
              fontWeight: FontWeight.bold),
        ));
  }
}
