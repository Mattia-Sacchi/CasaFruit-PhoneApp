import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:casa_fruit/ColloWidget.dart';

class Storage {

  String _path = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    _path = '$path/objects.txt';
    return File(_path);
  }

  String get localFilePath {
    return _path;
  }

  Future<File> write(List<ColloWidget> lst) async {
    final file = await _localFile;
    var temp = "";
    for(ColloWidget w in lst) {
      int id = w.ID;
      String collo = w.Collo;
      temp +=  "$id;$collo\n";
    }
    return file.writeAsString(temp.toString());
  }

  Future<List<ColloWidget>> read() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      List<ColloWidget> colli = [];
      List<String> lines = contents.split('\n');
      for (String l in lines) {
        if(l.isEmpty)
          continue;
        List<String> tmp = l.split(';');
        if(tmp.length != 2)
          continue;
        int id =  int.parse(tmp.elementAt(0));
        String name = tmp.elementAt(1);
        if(id == 0 || name.isEmpty)
          continue;
        ColloWidget collo =  ColloWidget(ID: id,
            Collo: name);
        colli.add(collo);
      }
      colli.sort((a, b) => a.ID.compareTo(b.ID));
      return colli;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

}
