import 'package:flutter/material.dart';
import 'package:music_app/data/repository/repository.dart';
import 'package:music_app/ui/home/home.dart';

void main() => runApp(const MusicApp());

// void main() async {
//   var repository = DefaultRepository();
//   var songs = await repository.loadData();
//   if(songs != null){
//     for(var song in songs){
//       debugPrint(song.toString());
//     }
//   }
//
// }