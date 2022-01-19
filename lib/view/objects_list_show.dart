import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furibase_firestore_write/class/constant.dart';

import 'package:furibase_firestore_write/class/home_object.dart';

class ObjectsListShow extends StatefulWidget {
  // ObjectsListShow is a class created in order to show a list of rooms
  // iput: 1. size: is the size of screen
  //       2. rooms: list of rooms
  //       3. isCliked: is a bool used to determine if the list is LongPressDraggable or not
  //       if isCliked =flase, list is first one; else, list is second one
  // output:  GridView of rooms list

  // LongPressDraggable is another draggable widget. The only difference between LongPressDraggable
  // and Draggable is that LongPressDraggable allows you to drag the item on long-pressing over it
  //while the Draggable can be dragged instantly.
  const ObjectsListShow({
    Key? key,
    required this.size,
    required this.rooms,
    this.isCliked = false,
  }) : super(key: key);

  final Size size;
  final List<RoomElement> rooms;

  final bool isCliked;

  @override
  State<ObjectsListShow> createState() => _ObjectsListShowState();
}

class _ObjectsListShowState extends State<ObjectsListShow> {
  _deleObjectFromHome(int indexslectedObject) {
    // _deleObjectFromHome
    // Object: delete object from homeConsyant
    // iput: 1. indexslectedObject
    setState(() {
      if (!isRoom.value) {
        // if isRoom is equal of 'false' the indexslectedObject is an index of room
        homeConstant.rooms.remove(homeConstant.rooms[indexslectedObject]);
      } else {
        //if isRoom is equal of 'true' the indexslectedObject is an index of applaince
        // and the index of room is saved in the global variable 'indexRoom'
        homeConstant.rooms[indexRoom].room.appliances.remove(
            homeConstant.rooms[indexRoom].room.appliances[indexslectedObject]);
      }
      upDate.value = !upDate.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: upDate,
        builder: (context, bool snapshot, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: !widget.isCliked
                    ? widget.size.height * 0.4
                    : widget.size.height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      children: List.generate(widget.rooms.length, (index) {
                        return Center(
                          child: widget.isCliked
                              ? showObject(
                                  index: index,
                                  room: widget.rooms[index].room,
                                  size: widget.size,
                                  context: context,
                                  isCliked: true,
                                )
                              : draggingStart(
                                  hOme: homeConstant,
                                  room: widget.rooms[index].room,
                                  size: widget.size,
                                  context: context,
                                  index: index),
                        );
                      })),
                )),
          );
        });
  }

  Widget draggingStart(
      {required Room room,
      required Size size,
      required Home hOme,
      required BuildContext context,
      int index = 0}) {
    return LongPressDraggable<Room>(
        data: room,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: showObject(
            room: room,
            size: size,
            slected: true,
            index: index,
            context: context),
        child: showObject(room: room, size: size, context: context));
  }

  showObject(
      // showObject
      // Object: Show the room in grid view
      // input: 1. room
      //        2. size
      //        3. slected: an bool determine if the object is slected
      //        4. context
      //        5. index: an int represent the index of object (applaince ot room)
      //        6. isCliked: determine the object is in the first or second list
      // output: 1. Card view contains the name and icon of object
      //         2. onTap function
      //            Object: if the object in second list and isRoom=false,
      //            onTap function change the Value of isRoom and upDate listener and
      //            save the of room selected in global variale indexRoom
      //         3. onDoubleTap function
      //            Object:if the object in second list and isRoom=false
      //            onDoubleTap function delete the slected room (_deleObjectFromHome)
      //            elseif the object in second list and isRoom=true
      //            onDoubleTap function delete the slected applaince (_deleObjectFromHome)
      {required Room room,
      required Size size,
      bool slected = false,
      required BuildContext context,
      int index = 0,
      bool isCliked = false}) {
    return SizedBox(
      width: slected ? size.width * 0.35 : size.width * 0.28,
      child: Card(
          elevation: 10,
          shadowColor: Colors.blue,
          child: GestureDetector(
            onTap: () {
              if (isCliked & !isRoom.value) {
                isRoom.value = !isRoom.value;
                upDate.value = !upDate.value;
                indexRoom = index;
              }
            },
            onDoubleTap: () {
              if (isCliked) {
                String objectSlected = !isRoom.value ? 'Room' : 'Appliance';
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Warning'),
                    content: Text(
                        'Do you want to delete the selected $objectSlected ?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'No'),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleObjectFromHome((index));
                          Navigator.pop(context, 'Yes');
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    room.iconPath,
                    height: size.height * 0.08,
                    color: Colors.blue,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                Text(room.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: slected ? Colors.black : Colors.blue,
                        fontWeight: slected ? FontWeight.bold : null)),
              ],
            ),
          )),
    );
  }
}
