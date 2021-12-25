
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furibase_firestore_write/view/rooms_list_show.dart';
import 'package:furibase_firestore_write/view/home_builder.dart';

import 'class/class_object.dart';
import 'class/constant.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Builder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Home home=Home();

  void _roomDropInHome({required Room room }){
    setState(() {
      home.rooms.add(room);
      
    });
  }
 
  

  @override
  Widget build(BuildContext context) {
   Size size =MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget> [

            title(size: size, titleName:"Rooms List"),
            RoomsListShow(size: size, rooms:rooms, hOme:home),

            title(size: size, titleName:"Home"),

            
              DragTarget<Room>(
                builder: (context, candidateItems, rejectedItems) {
                return HomeBuilder(
                  home :home,
                  room:rooms[1],
                  size: size,);},

                onAccept: (room) {
                  _roomDropInHome(room:room);},
        ), 
          ]
          
        ),
      ),
    );
  }
}


/*title widget */
class title extends StatelessWidget {
  const title({
    Key? key,
    required this.size,required this.titleName,
  }) : super(key: key);

  final Size size;final String titleName;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(size.height*0.01),
    child: Text(titleName, style: TextStyle(
      color: Colors.black,
       fontSize: size.height*0.03,
     fontWeight: FontWeight.bold),));
  }
}
