import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Storage.dart';
import 'package:casa_fruit/ColloWidget.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';

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
      });
      for(ColloWidget tmp in colli)
        addWidget(tmp);
    });

  }

  void addCollo(int id,String c)
  {
    if(id == 0 || c.isEmpty)
      return;
    for(ColloWidget w in colli)
      {
        if(w.ID == id)
          return;
      }
    ColloWidget w = ColloWidget(ID: id,
        Collo: c);
    setState(() {
      colli.add(w);
    });
    addWidget(w);
    save();
  }

  void addWidget(ColloWidget c)
  {
    c.setCallback(() {
      setState(() {
        colli.remove(c);
        save();
      });
    });
  }

  @override
  void save()
  {
    widget.storage.write(colli);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: colli,
        ),
      ),
      persistentFooterButtons: [
        IconButton(
          onPressed: () async {
            await Share.shareXFiles(
                [XFile(widget.storage.localFilePath)],
            text: "Ciao mondo");

          },
          tooltip: 'Share',
          icon: Icon(Icons.share),
          color: Colors.blue,),
        IconButton(
          onPressed: () { showAlertDialog(this.context); },
          tooltip: 'Add',
          icon: Icon(Icons.add),
          color: Colors.blue,),
        IconButton(
          onPressed: () {  },
          tooltip: 'Get File',
          icon: Icon(Icons.add),
          color: Colors.blue,),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button

    TextEditingController idController = TextEditingController();
    TextEditingController colloController = TextEditingController();

    Widget addButton = TextButton(
      child: Text("Aggiungi"),
      onPressed: () {
        int id = int.parse(idController.text);
        String collo = colloController.text;
        addCollo(id, collo);
        Navigator.of(context).pop();
        },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Aggiungi un collo"),
      content: Column(
        children: [
          // ignore: unnecessary_new
          TextField(
          decoration: new InputDecoration(labelText: "Inserisci l'id"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: idController,
          ),
          TextField(
            decoration: new InputDecoration(labelText: "Inserisci il collo"),
            controller: colloController
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
