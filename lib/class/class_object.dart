
 
class Appliance{
  final String name;
  final String iconPath;
  Appliance({required this.name,required this.iconPath});
}


 fromAppliancesToRoom({required Appliance appliance}){
   return Room(name:appliance.name, iconPath:appliance.iconPath);
 }
 fromRoomToAppliances({required Room room}){
   return Appliance(name:room.name, iconPath:room.iconPath);
 }

class Room{
  Room({
    required this.name,
    required this.iconPath,
   List<Appliance>? appliances }):
    appliances = appliances?? [];

  final String name;
  final String iconPath;
  final List<Appliance> appliances;
}

class Home{
  Home({
    List<Room>? rooms
  }):rooms=rooms??[];
  
  final List<Room> rooms;
}