import 'dart:ffi';

import 'package:flutter/material.dart';


class ColloWidget extends StatelessWidget {
  int ID;
  String Collo;
  ColloWidget({Key? key,required this.ID,required this.Collo}) : super(key: key)
  {
  }

  late final void Function() callback;

  void setCallback(void Function() c)
  {
    callback = c;
  }



  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text('$ID:  '),
      Text('$Collo'),
      Expanded(child: Align(alignment: Alignment.centerRight,
      child: IconButton(onPressed: callback,
        icon: Icon(Icons.remove),
        color: Colors.deepOrange,),),)
      ,
    ],);
    throw UnimplementedError();
  }

}