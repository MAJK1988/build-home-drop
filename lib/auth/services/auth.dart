import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furibase_firestore_write/auth/Screens/Login/login_screen.dart';
import 'package:furibase_firestore_write/view/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
      user = userCredential.user;
      
      
      toWidget(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        snackBarMassage(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        snackBarMassage(context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
   
    User? user;
  
      

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
        try{
         final prefs = await SharedPreferences.getInstance();
         prefs.setString('uid',user!.uid);
         var testName=user.displayName;
         if(testName!=null){
         prefs.setString('name',testName);
         }
         var testEmail=user.email;
         if(testEmail!=null){
         prefs.setString('email',testEmail);
         }
      }catch(e){
        print('Error: ${e.toString()}');
      }
      
      
      
      toWidget(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBarMassage(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        snackBarMassage(context, 'Wrong password provided.');
        print('Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<int> testLogin() async {
    int state = 0;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        
        state = 1;
      }
    });

    return state;
  }

  static void toWidget(BuildContext context) {
    /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );*/
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => 
       const MyHomePage(title: 'Home Builder')),
      (Route<dynamic> route) => false,
    );
  }

  static void snackBarMassage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  static Future<void> logOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const  
        LoginScreenApp()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  
}
