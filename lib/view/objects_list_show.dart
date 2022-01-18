import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furibase_firestore_write/class/constant.dart';

import 'package:furibase_firestore_write/class/home_object.dart';

class ObjectsListShow extends StatefulWidget {
  const ObjectsListShow(
      {Key? key,
      required this.size,
      required this.rooms,
      this.isCliked = false,
      this.isFirstList = false})
      : super(key: key);

  final Size size;
  final List<RoomElement> rooms;

  final bool isCliked;
  final bool isFirstList;

  @override
  State<ObjectsListShow> createState() => _ObjectsListShowState();
}

class _ObjectsListShowState extends State<ObjectsListShow> {
  _deleObjectFromHome(int indexslectedObject) {
    setState(() {
      if (!isRoom.value) {
        homeConstant.rooms.remove(homeConstant.rooms[indexslectedObject]);
      } else {
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
                height: widget.isFirstList
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
                              ? roomShow(
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
        feedback: roomShow(
            room: room,
            size: size,
            slected: true,
            index: index,
            context: context),
        child: roomShow(room: room, size: size, context: context));
  }

  roomShow(
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
