import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Storage.dart';
import 'package:casa_fruit/ColloWidget.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title,required this.storage});
  Storage storage;
  final String title;


  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  List<ColloWidget> colli = [];
  List<ColloWidget> colliVisibili = [];
  TextEditingController searchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermission();
    widget.storage.read().then((value) {
      load(value);
    });


  }

  void load(List<ColloWidget> lst)
  {
      setState(() {
        colli = lst;
      });
      for(ColloWidget tmp in colli)
        addWidget(tmp);
      colliVisibili = colli;
  }

  Future<PermissionStatus> getPermission() async
  {

    var status = await Permission.storage.status;
    if(status.isDenied)
      return await Permission.storage.request();
    return status;
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
    reload();

  }

  void reload()
  {
    if(searchBar.text.isNotEmpty)
      searchBar.text = "";
    setState(() {
      colliVisibili = colli;
    });

  }

  void addWidget(ColloWidget c)
  {
    c.setCallback(() {
      setState(() {
        colli.remove(c);
        reload();
        save();
      });
    });
  }

  @override
  void save()
  {
    widget.storage.write(colli);
  }

  void pickFile() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['txt'],
        type: FileType.custom);
    if(result != null && result.files.single.path != null)
      {
        PlatformFile file = result.files.first;

        widget.storage.load(file.path.toString()).then((value)
        {
          load(value);
        });
        save();

      }
  }
void textChanged(String text)
{
  if(text.isEmpty) {
    reload();
    return;
  }
  colliVisibili = [];
  setState(() {
  for(ColloWidget w in colli)
    {
      if(w.Collo.contains(text))
        colliVisibili.add(w);
    }
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Column( children: [
          TextField(
            decoration: new InputDecoration(
              labelText: "Cerca",
              icon: Icon(Icons.search),
              iconColor: Colors.white,
              ),
            onChanged: textChanged,
            controller: searchBar,
            style: TextStyle(color: Colors.white),

          )
        ]),


      ),

      body: Center(
        child: ListView(
          children: colliVisibili,
        ),
      ),

      persistentFooterButtons: [
        IconButton(
          onPressed: () async {
            await Share.shareXFiles(
                [XFile(widget.storage.localFilePath)],
            text: "Condividi file");

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
          onPressed: pickFile,
          tooltip: 'Get File',
          icon: Icon(Icons.file_open),
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
