import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Storage.dart';
import 'dart:math';
import 'package:untitled/ColloWidget.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title,required this.storage});
  Storage storage;
  final String title;



  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  List<ColloWidget> colli = [];

  @override
  void initState() {
    super.initState();
    widget.storage.read().then((value) {
      setState(() {
        colli = value;
        for(ColloWidget tmp in colli)
          {
            tmp.setCallback(() {
              setState(() {
                colli.remove(tmp);
                save();
              });
            });
          }
      });
    });

  }

  @override
  void save()
  {
    widget.storage.clear();
    Map<int,String> tmp = {};
    for (ColloWidget w in colli)
    {
      tmp[w.ID] = w.Collo;
    }
    for(int id in tmp.keys) {
      if(id == 0)
        continue;
      widget.storage.write(id, tmp[id]!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: colli,
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { showAlertDialog(this.context); },
        tooltip: 'Settings',
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget addButton = TextButton(
      child: Text("Aggiungi"),
      onPressed: () {
        Navigator.of(context).pop();
        },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Aggiungi un collo"),
      content: Column(
        children: [
          new TextField(
          decoration: new InputDecoration(labelText: "Inserisci l'id"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          ),
          new TextField(
            decoration: new InputDecoration(labelText: "Inserisci il collo")
            ,)
        ]
      ),
      actions: [
        addButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
