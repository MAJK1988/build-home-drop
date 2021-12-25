import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furibase_firestore_write/class/class_object.dart';
import 'package:furibase_firestore_write/view/room_builder.dart';


class RoomsListShow extends StatelessWidget {
  const RoomsListShow({
    Key? key,
    required this.size,
    required this.rooms,
     this.home=false, 
    required this.hOme
  }) : super(key: key);

  final Size size;
  final List<Room> rooms;
  final bool home;
  final Home hOme;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          border:  Border.all(
            color:home ?Colors.white :Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        height:size.height*0.4 ,
        child:
         Padding(
           padding: const EdgeInsets.only(top:20, bottom:20),
           child: GridView.count(  
            crossAxisCount: 3,  
            crossAxisSpacing: 4.0,  
            mainAxisSpacing: 8.0,  
            children: List.generate(rooms.length, (index) {  
              return Center(  
                child: home?roomShow(
                  hOme:hOme,
                  index:index,
                  room:rooms[index],
                  size:size, context:context):
                draggingStart(
                  hOme:hOme,
                  room: rooms[index],
                  size: size, 
                  context:context),  
              );  
            }  
            )),
         )  
      ),
    );
  }


Widget draggingStart({required Room room, required Size size,required Home hOme,
required BuildContext context ,int index=0}){
  return LongPressDraggable<Room>(
      data: room,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: roomShow(room:room,size:size, slected:true, context: context, hOme: hOme),
      child: roomShow(room:room,size:size, context:context,hOme: hOme)
    );
} 


Widget roomShow({required Room room, required Size size,
 bool slected=false, required BuildContext context, int index=0, required Home hOme
}){
  return SizedBox(
   width:slected?size.width*0.35: size.width*0.28,
    child: Card(
      elevation:10,
      shadowColor: Colors.blue,
      child:GestureDetector(
        onTap: (){
          if(home){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoomBuilder(home:hOme, index:index)),
            );

            }
          },

        child: Column(
          children:<Widget> [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                room.iconPath,
                height:size.height*0.08,
                
                color:Colors.blue,
                allowDrawingOutsideViewBox: true,),
            ),
      
              Text(room.name, 
              overflow: TextOverflow.ellipsis,
              style:TextStyle(
                color: slected? Colors.black:Colors.blue,
                fontWeight: slected?FontWeight.bold:null)),
          ],
        ),
      )
    ),
  );
}
}