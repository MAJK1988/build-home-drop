import 'package:flutter/material.dart';

import 'home_object.dart';

const kPrimaryColor = Color(0xFF1565C0); // Colors.blue;//Color(0xff0c9869);
const kTextColor = Color(0xff3c4046);
const kBackgroundColor = Color(0xfff9f0fd);
const kDefaultPadding = 20.0;
const kColoryellow = Color(0xFFFFFFFF);
const kPrimaryLightColor = Color(0xFFF1E6FF);

//final ValueNotifier<bool> isRoom = ValueNotifier<bool>(false);
final ValueNotifier<bool> isRoom = ValueNotifier<bool>(false);
final ValueNotifier<bool> upDate = ValueNotifier<bool>(false);
int indexRoom = 1;
late Home homeConstant = Home();

List<RoomElement> rooms = [
  RoomElement(
      room: Room(name: 'Toilets', iconPath: 'assets/icons/bathtub.svg')),
  RoomElement(
      room: Room(name: 'Living Room', iconPath: 'assets/icons/sofa.svg')),
  RoomElement(
      room: Room(name: 'Kitchen', iconPath: 'assets/icons/kitchen.svg')),
  RoomElement(room: Room(name: 'BedRoom', iconPath: 'assets/icons/bed.svg')),
];

List<RoomElement> appliances = [
  RoomElement(
      room:
          Room(name: 'Dish washer', iconPath: 'assets/icons/dish_washer.svg')),
  RoomElement(
      room: Room(
          name: 'Refrigerator', iconPath: 'assets/icons/refrigerator.svg')),
  RoomElement(
      room: Room(
          name: 'Coffee maker', iconPath: 'assets/icons/coffee_maker.svg')),
  RoomElement(
      room: Room(name: 'Gas stove', iconPath: 'assets/icons/gas_stove.svg')),
  RoomElement(
      room: Room(name: 'Microwave', iconPath: 'assets/icons/microwave.svg')),
  RoomElement(
      room:
          Room(name: 'Rice cooker', iconPath: 'assets/icons/rice_cooker.svg')),
  RoomElement(room: Room(name: 'Light', iconPath: 'assets/icons/light.svg')),
  RoomElement(room: Room(name: 'TV', iconPath: 'assets/icons/tv.svg')),
  RoomElement(
      room: Room(
          name: 'Air conditioner',
          iconPath: 'assets/icons/air_conditioner.svg')),
  RoomElement(
      room: Room(
          name: 'Water heater', iconPath: 'assets/icons/water_heater.svg')),
  RoomElement(
      room: Room(name: 'Blow dryer', iconPath: 'assets/icons/blow_dryer.svg')),
  RoomElement(
      room:
          Room(name: 'Washing', iconPath: 'assets/icons/washing_machine.svg')),
];
