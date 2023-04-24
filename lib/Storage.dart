import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:untitled/ColloWidget.dart';

import 'package:untitled/ColloWidget.dart';

class Storage {


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/objects.txt');
  }

  void clear() async
  {
    final file = await _localFile;
    file.writeAsString("");
  }

  Future<File> write(int id,String collo) async {
    final file = await _localFile;

    return file.writeAsString("$id/$collo\n",mode: FileMode.writeOnlyAppend);
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
        List<String> tmp = l.split('/');
        ColloWidget collo =  ColloWidget(ID: int.parse(tmp.elementAt(0)),
            Collo: tmp.elementAt(1));
        colli.add(collo);
      }
      return colli;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

}
