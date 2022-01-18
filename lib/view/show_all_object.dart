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
  Future<void> _roomDropInHome(
      {required Room room,
      required String uid,
      required DocumentReference<Home> fireHome}) async {
    setState(() {
      homeConstant.rooms.add(
          RoomElement(room: Room(name: room.name, iconPath: room.iconPath)));
    });
  }

  void _applianceDropInRoom(
      {required Appliance appliance, required int indexRoom}) {
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
        valueListenable: upDate,
        builder: (context, bool snapshot, Widget? child) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  title(
                      size: widget.size,
                      titleName: !isRoom.value
                          ? "Rooms List"
                          : homeConstant.rooms[indexRoom].room.name),
                  ObjectsListShow(
                      isFirstList: true,
                      size: widget.size,
                      rooms: !isRoom.value ? rooms : appliances),
                  title(
                      size: widget.size,
                      titleName: !isRoom.value
                          ? "Home"
                          : 'Appliances\' s ${homeConstant.rooms[indexRoom].room.name}'),
                  DragTarget<Room>(
                    builder: (context, candidateItems, rejectedItems) {
                      return isRoom.value
                          ? homeConstant
                                  .rooms[indexRoom].room.appliances.isEmpty
                              ? DropHere(
                                  size: widget.size,
                                  titleName: 'Drop here',
                                )
                              : ObjectsListShow(
                                  size: widget.size,
                                  rooms: fromAppliancesToRoomElement(
                                      appliances: homeConstant
                                          .rooms[indexRoom].room.appliances),
                                  isCliked: true)
                          : testHome
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
                      if (!isRoom.value) {
                        _roomDropInHome(
                            room: room,
                            uid: widget.user.uid,
                            fireHome: widget.fireHome);
                      } else {
                        _applianceDropInRoom(
                            appliance: fromRoomToAppliances(room: room),
                            indexRoom: indexRoom);
                      }
                    },
                  ),
                  RoundedButton(
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
