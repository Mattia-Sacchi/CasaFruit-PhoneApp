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
      Text('ID: $ID'),
      Text('  Nome: $Collo'),
      MaterialButton(onPressed: callback,
          child: const Text('Remove',textScaleFactor: 1.33,),
          textColor: Colors.white,
          color: Colors.deepOrange,),

    ],);
    throw UnimplementedError();
  }

}