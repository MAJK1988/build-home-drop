import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furibase_firestore_write/auth/components/rounded_button.dart';
import 'package:furibase_firestore_write/class/constant.dart';
import 'package:furibase_firestore_write/class/home_object.dart';

import 'package:furibase_firestore_write/view/my_home_page.dart';
import 'package:furibase_firestore_write/view/objects_list_show.dart';

class ShowAllObject extends StatefulWidget {
  const ShowAllObject({
    Key? key,
    required this.size,
    required this.user,
    required this.fireHome,
  }) : super(key: key);

  final Size size;
  final UserLocal user;
  final DocumentReference<Home> fireHome;

  @override
  State<ShowAllObject> createState() => _ShowState();
}

class _ShowState extends State<ShowAllObject> {
  void _roomDropInHome({required Room room}) {
    // _roomDropInHome is a function created to save room in homeConstant
    // input : 1. room
    setState(() {
      homeConstant.rooms.add(
          RoomElement(room: Room(name: room.name, iconPath: room.iconPath)));
    });
  }

  void _applianceDropInRoom(
      {required Appliance appliance, required int indexRoom}) {
    // _applianceDropInRoom is a function created to save appliance in a specific room in  homeConstant
    // input : 1. appliance 2. indexRoom
    setState(() {
      homeConstant.rooms[indexRoom].room.appliances.add(ApplianceElement(
          appliance:
              Appliance(name: appliance.name, iconPath: appliance.iconPath)));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool testHome = homeConstant.rooms.isEmpty;
    return ValueListenableBuilder<bool>(
        // ValueListenableBuilder used here to update UI when in update on HomeConst is done
        valueListenable: upDate,
        builder: (context, bool snapshot, Widget? child) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  title(
                      size: widget.size,
                      titleName:
                          //if the object is room (isRoom=true) show the list of appliances that saved in assets file
                          // else (isRoom =false) show the list of rooms that saved in assets file
                          !isRoom.value ? "Rooms List" : "Appliances List "),
                  ObjectsListShow(
                      size: widget.size,
                      rooms: !isRoom.value ? rooms : appliances),
                  title(
                      size: widget.size,
                      titleName:
                          //if the object is room (isRoom=true) show the list of target appliances that saved in homeConstant
                          // where homeConstant is a global constant, (in constant.dart)
                          // else (isRoom =false) show the list of target rooms that saved in homeConstant
                          !isRoom.value
                              ? "Home"
                              : 'Appliances\' s ${homeConstant.rooms[indexRoom].room.name}'),
                  DragTarget<Room>(
                    //DragTarget allows us drag a widget across screen.
                    // Follow this link to find out DragTarget  https://blog.logrocket.com/drag-and-drop-ui-elements-in-flutter-with-draggable-and-dragtarget/
                    builder: (context, candidateItems, rejectedItems) {
                      return isRoom.value
                          ? homeConstant
                                  .rooms[indexRoom].room.appliances.isEmpty
                              ? DropHere(
                                  //if no appliances in the selected room show the text "Drop here"
                                  size: widget.size,
                                  titleName: 'Drop here',
                                )
                              : ObjectsListShow(
                                  // in the case where there are appliances in the room, the following
                                  // show the targeted aplliances
                                  size: widget.size,
                                  rooms: fromAppliancesToRoomElement(
                                      appliances: homeConstant
                                          .rooms[indexRoom].room.appliances),
                                  isCliked: true)
                          : testHome
                              //if no rooms in the homeConstant show the text "Drop here"
                              // else, ObjectsListShow class show the targeted rooms
                              ? DropHere(
                                  size: widget.size,
                                  titleName: 'Drop here',
                                )
                              : ObjectsListShow(
                                  size: widget.size,
                                  rooms: homeConstant.rooms,
                                  isCliked: true);
                    },
                    onAccept: (room) {
                      //onAccept is a callback that we should receive once the item is accepted by the DragTarget.
                      if (!isRoom.value) {
                        //if the object is room (isRoom=true) save slected appliance in homeConstant,
                        // with respect room index (_applianceDropInRoom).
                        // else (isRoom =false) save slected room in homeConstant (_roomDropInHome).
                        _roomDropInHome(room: room);
                      } else {
                        _applianceDropInRoom(
                            appliance: fromRoomToAppliances(room: room),
                            indexRoom: indexRoom);
                      }
                    },
                  ),
                  RoundedButton(
                    //if the object is room (isRoom=true), the clicked change the value of isRoom and upDate listener,
                    // else (isRoom =false) save homeConstant in firebase fireStore
                    text: !isRoom.value ? "Save Home " : "Back to Home Builder",
                    press: () async {
                      if (!isRoom.value) {
                        await setHomeInFirestore(
                            home: homeConstant, fireHome: widget.fireHome);
                      } else {
                        isRoom.value = !isRoom.value;
                        upDate.value = !upDate.value;
                        setState(() {
                          indexRoom = 1;
                        });
                      }
                    },
                  ),
                ]),
          );
        });
  }
}

class DropHere extends StatelessWidget {
  // DropHere class return widget text in a container
  // input: 1. size of screen
  //        2. titleName: String
  //output: 1. text in a container with specific character
  //( border Colors.blue, height: size.height * 0.15,
  //    width: size.width * 0.9,)
  const DropHere({
    Key? key,
    required this.size,
    required this.titleName,
  }) : super(key: key);

  final Size size;
  final String titleName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: size.height * 0.15,
      width: size.width * 0.9,
      child: Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: Text(
            titleName,
            style: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.03,
            ),
          )),
    );
  }
}
