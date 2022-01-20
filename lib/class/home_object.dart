// To parse this JSON data, do
//
//     final home = homeFromJson(jsonString);

import 'dart:convert';

Home homeFromJson(String str) => Home.fromJson(json.decode(str));

String homeToJson(Home data) => json.encode(data.toJson());

class Home {
  Home({
    this.bill = const Bill(),
    this.genralData = const GenralData(),
    rooms,
  }) : rooms = rooms ?? [];

  Bill bill;
  GenralData genralData;
  List<RoomElement> rooms;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
        bill: Bill.fromJson(json["bill"]),
        genralData: GenralData.fromJson(json["GenralData"]),
        rooms: List<RoomElement>.from(
            json["Rooms"].map((x) => RoomElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bill": bill.toJson(),
        "GenralData": genralData.toJson(),
        "Rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
      };
}

class Bill {
  const Bill({
    this.limitedDay = "Not activated",
    this.units = "Not activated",
    this.billPrice = "Not activated",
  });

  final String limitedDay;
  final String units;
  final String billPrice;

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        limitedDay: json["limitedDay"],
        units: json["units"],
        billPrice: json["billPrice"],
      );

  Map<String, dynamic> toJson() => {
        "limitedDay": limitedDay,
        "units": units,
        "billPrice": billPrice,
      };
}

class GenralData {
  const GenralData(
      {this.temperature = "10.01",
      this.humidity = "10.01",
      this.consomation = "Not activated",
      this.date = "1/1/1"});

  final String temperature;
  final String humidity;
  final String consomation;
  final String date;

  factory GenralData.fromJson(Map<String, dynamic> json) => GenralData(
        temperature: json["temperature"],
        humidity: json["humidity"],
        consomation: json["consomation"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "humidity": humidity,
        "consomation": consomation,
        "date": date
      };
}

class RoomElement {
  // ignore: prefer_initializing_formals
  RoomElement({room}) : room = room;

  Room room;

  factory RoomElement.fromJson(Map<String, dynamic> json) => RoomElement(
        room: Room.fromJson(json["Room"]),
      );

  Map<String, dynamic> toJson() => {
        "Room": room.toJson(),
      };
}

class Room {
  Room(
      {this.name = "Not activated",
      this.iconPath = "Not activated",
      this.genralData = const GenralData(),
      appliances})
      : appliances = appliances ?? [];

  String name;
  String iconPath;
  GenralData genralData;
  List<ApplianceElement> appliances;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        name: json["name"],
        iconPath: json["iconPath"],
        genralData: GenralData.fromJson(json["GenralData"]),
        appliances: List<ApplianceElement>.from(
            json["appliances"].map((x) => ApplianceElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iconPath": iconPath,
        "GenralData": genralData.toJson(),
        "appliances": List<dynamic>.from(appliances.map((x) => x.toJson())),
      };
}

class ApplianceElement {
  // ignore: prefer_initializing_formals
  ApplianceElement({appliance}) : appliance = appliance;

  Appliance appliance;

  factory ApplianceElement.fromJson(Map<String, dynamic> json) =>
      ApplianceElement(
        appliance: Appliance.fromJson(json["appliance"]),
      );

  Map<String, dynamic> toJson() => {
        "appliance": appliance.toJson(),
      };
}

fromAppliancesToRoom({required Appliance appliance}) {
  return Room(name: appliance.name, iconPath: appliance.iconPath);
}

List<RoomElement> fromAppliancesToRoomElement(
    {required List<ApplianceElement> appliances}) {
  List<RoomElement> rooms = [];
  for (ApplianceElement i in appliances) {
    rooms.add(RoomElement(room: fromAppliancesToRoom(appliance: i.appliance)));
  }
  return rooms;
}

fromRoomToAppliances({required Room room}) {
  return Appliance(name: room.name, iconPath: room.iconPath);
}

class Appliance {
  Appliance({
    this.name = "Not activated",
    this.iconPath = "Not activated",
    this.lastActivation = "Not activated",
    this.status = false,
    this.roomName = "Not activated",
  });

  String name;
  String iconPath;
  String lastActivation;
  bool status;
  String roomName;

  factory Appliance.fromJson(Map<String, dynamic> json) => Appliance(
        name: json["name"],
        iconPath: json["iconPath"],
        lastActivation: json["lastActivation"],
        status: json["status"],
        roomName: json["roomName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iconPath": iconPath,
        "lastActivation": lastActivation,
        "status": status,
        "roomName": roomName,
      };
}

class UserLocal {
  final String name;
  final String email;
  final String uid;
  UserLocal({required this.email, required this.name, required this.uid});
}
