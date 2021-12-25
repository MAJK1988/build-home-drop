
import 'package:flutter/material.dart';
import 'package:furibase_firestore_write/class/class_object.dart';
import 'package:furibase_firestore_write/class/constant.dart';
import 'package:furibase_firestore_write/main.dart';
import 'package:furibase_firestore_write/view/home_builder.dart';
import 'package:furibase_firestore_write/view/rooms_list_show.dart';

class RoomBuilder extends StatefulWidget{
  const RoomBuilder({Key? key,required this.home, required this.index}) : super(key: key);
  final Home home;final int index;

  @override
  State<RoomBuilder> createState() => _StateRoomBuilder();
}

class _StateRoomBuilder extends State<RoomBuilder>{
void _applianceDropInRoom({required Appliance appliance }){
  setState(() {
    widget.home.rooms[widget.index].appliances.add(appliance);
  });
}

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title:
      Text('Build ${widget.home.rooms[widget.index].name}')),
      body:Center(
        child: Column(
          children:<Widget> [
            title(size: size, titleName: "Appliances List"),

            RoomsListShow(size: size, rooms:appliances, hOme:widget.home),
             title(size: size, titleName: "Appliances's ${widget.home.rooms[widget.index].name}"),
            DragTarget<Room>(
                builder: (context, candidateItems, rejectedItems) {
                return HomeBuilder(
                  home :widget.home,
                  room:widget.home.rooms[widget.index],
                  showRoom:true,
                  size: size,);},

                onAccept: (room) {
                  _applianceDropInRoom(appliance:fromRoomToAppliances(room: room));},
        ),


          ],

      ))
    );
  }
  
}