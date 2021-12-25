import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furibase_firestore_write/class/class_object.dart';
import 'package:furibase_firestore_write/view/rooms_list_show.dart';



class HomeBuilder extends StatelessWidget {
  const HomeBuilder({
    Key? key,
    required this.home,
    required this.size,
    required this.room, 
    this.showRoom=false

  }) : super(key: key);
  final Home home;
  final Size size;
  final Room room;
  final bool showRoom;


  @override
  Widget build(BuildContext context) {
    bool testHome=home.rooms.isEmpty;
    return Container(
      alignment: Alignment.center,
      decoration:  BoxDecoration(
      border:  Border.all(
      color: Colors.blue,),
      borderRadius: BorderRadius.circular(10.0),),
      height:size.height*0.2 ,
      width: size.width*0.95,

      child: showRoom?AppliancesShowList(room:room, size:size):
      testHome?const Text('Drop here'): 
      RoomsListShow(
        size: size, 
        rooms:home.rooms, 
        home:true, 
        hOme:home, ),

      );
  }
}

AppliancesShowList({required room, required Size size}){
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child:room.appliances.isEmpty? const Text('Drop here'): Container(
        alignment: Alignment.center,
        
        height:size.height*0.4 ,
        child:
         Padding(
           padding: const EdgeInsets.only(top:20, bottom:20),
           child: GridView.count(  
            crossAxisCount: 3,  
            crossAxisSpacing: 4.0,  
            mainAxisSpacing: 8.0,  
            children: List.generate(room.appliances.length, (index) {  
              return Center(  
                child: Card(
      elevation:10,
      shadowColor: Colors.blue,
      child:Column(
        children:<Widget> [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              room.appliances[index].iconPath,
              height:size.height*0.08,
              
              color:Colors.blue,
              allowDrawingOutsideViewBox: true,),
          ),
      
            Text(room.appliances[index].name, 
            overflow: TextOverflow.ellipsis,
            style:const TextStyle(
              color:  Colors.black,
              fontWeight: FontWeight.bold)),
        ],
      )
    ),  
              );  
            }  
            )),
         )  
      ),
    );
}






