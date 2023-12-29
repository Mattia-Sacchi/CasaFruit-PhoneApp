import 'package:casa_fruit/objects/collo.dart';
import 'package:flutter/material.dart';

class ColloTile extends StatefulWidget {
  ColloTile({Key? key, required this.obj, required this.callback});
  final Collo obj;
  bool selected = false;
  void Function() callback;


  @override
  State<ColloTile> createState() => ColloTileState();
}

class ColloTileState extends State<ColloTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:  Text(widget.obj.name),
      subtitle:  Text(widget.obj.uid.toString()),
      leading: CircleAvatar(child:  Text(widget.obj.uid.toString()),),
      trailing: IconButton(icon: Icon(Icons.edit), onPressed: widget.callback,
      ),
      selected: widget.selected,
      selectedColor: Colors.orange,
      textColor: Colors.blue,
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });

      },
    );
  }

}
