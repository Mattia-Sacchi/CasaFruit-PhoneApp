import 'package:flutter/material.dart';

class Collo
{
  Collo({ required this.uid, required this.name});
  int uid; // unique identifier
  String name;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name
    };
  }

  static Collo fromMap(Map<String, dynamic> map) {
    return Collo(uid : map['uid'],  name:  map['name']);
  }
}