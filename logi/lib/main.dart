import 'package:flutter/material.dart';
import 'package:logi/screen/Menu.dart';


void main (){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override

Widget build (BuildContext context){
  return  MaterialApp(
    home: Scaffold(
      body:Menuoption
      (),
    ),
  );
}

}
