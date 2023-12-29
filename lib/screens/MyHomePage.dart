import 'dart:convert';

import 'package:casa_fruit/widgets/collo_tile.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:casa_fruit/objects/database.dart';

import '../objects/collo.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController searchBar = TextEditingController();
  TextEditingController dialogController = TextEditingController();
  List<ColloTile> colli = [];
  int dialogId = 100;

  MyHomePageState() {
    manager = DatabaseManager();
  }

  late DatabaseManager manager;

  void reload() async {
    await manager.open();
    List<Collo> objects = await manager.getColli();
    objects.forEach((element) {
      setState(() {
        colli.add(ColloTile(obj: element,callback: () {_showDialog(element.name, element.uid); }));
      });
    });

  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  void searchByName(String value) {}

  void search() {
    searchByName(searchBar.text);
  }

  void onImportPressed()
  {
    FlutterClipboard.paste().then((value) {
      List<dynamic> temps = jsonDecode(value);
      if(temps.isEmpty)
      {
        return;
      }
      // Transform in a list of objects
      List<Collo> newColli = [];
      temps.forEach((element) {
        newColli.add(Collo.fromMap(element));
      });
      // Transform in widget and save in database
      newColli.forEach((element) {
        colli.removeWhere((e) => e.obj.uid == element.uid);
        setState(() {
          colli.add(ColloTile(obj: element,callback: () {_showDialog(element.name, element.uid); }));

        });
        manager.insert(element);
      });

    });
  }

  void onSharePressed() async
  {
    List<Collo> objects =  await manager.getColli();
    List<Map<String,dynamic>> temps = [];
    objects.forEach((element) {
      temps.add(element.toMap());
    });
    String text = jsonEncode( temps);
    print(text);
    await Share.share(text, subject: 'Json Document');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: search,
        ),
        title: TextField(
          decoration: new InputDecoration(
            labelText: "Cerca",
            icon: Icon(Icons.search),
            iconColor: Colors.white,
          ),
          onChanged: searchByName,
          controller: searchBar,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: colli.length,
          itemBuilder: (BuildContext context, int Itemindex) {
            return colli[Itemindex]; // return your widget
          }),
      persistentFooterButtons: [
        IconButton(
          onPressed: _showMyDialog,
          tooltip: 'Add',
          icon: Icon(Icons.add),
          color: Colors.blue,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              colli.removeWhere((element) {
                if(element.selected)
                  manager.delete(element.obj.uid);
                return element.selected;
              });
            });
          },
          tooltip: 'Delete',
          icon: Icon(Icons.delete),
          color: Colors.blue,
        ),
        IconButton(
          onPressed: onImportPressed,
          tooltip: 'Import',
          icon: Icon(Icons.import_export),
          color: Colors.blue,
        ),
        IconButton(
          onPressed: onSharePressed,
          tooltip: 'Share',
          icon: Icon(Icons.share),
          color: Colors.blue,
        ),
      ],
    );
  }

  void dialogAccepted() {
    Navigator.of(context).pop();
    colli.removeWhere((element) => element.obj.uid == dialogId);
    Collo c = Collo(uid: dialogId, name: dialogController.text);
    setState(() {
      colli.add(ColloTile(obj: c,callback: () {_showDialog(c.name, c.uid); }));

    });
    manager.insert(c);
  }

  void _showDialog(String name, int id)
  {
    dialogId = id;
    dialogController.text = name;
    _showMyDialog();
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return  Dialog(
          child: Column(
            children: [
              Text('Inserisci un collo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              Column(
                children: [
                  const Text('Nome: '),
                  TextField(
                    controller: dialogController,),
                ],
              ),
              StatefulBuilder(
                builder: (context4, setState2) {
                  return  Row(
                    children: [
                      Text('Id: '),

                      NumberPicker(
                        minValue: 1,
                        maxValue: 600,
                        value: dialogId,
                        onChanged: (value) {
                          setState2(() => dialogId = value);
                        },
                        axis: Axis.horizontal,
                      )
                    ],
                  );
                },
              ),

              TextButton(
                onPressed: dialogAccepted,
                child: Text('Aggiungi'),
              ),
            ],
          ),
        );
      },
    );
  }
}
