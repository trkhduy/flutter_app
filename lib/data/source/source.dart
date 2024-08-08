import 'dart:convert';

import 'package:music_app/data/model/song.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    const url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      // Log thông tin về response để kiểm tra
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        var songWrapper = jsonDecode(body) as Map;

        // Log thông tin về dữ liệu nhận được
        print('Response body: $songWrapper');

        var songList = songWrapper['songs'] as List;
        List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
        return songs;
      } else {
        // Log lỗi nếu status code không phải là 200
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Log lỗi khi có exception xảy ra
      print('Error loading data: $e');
      return null;
    }
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async{
    final String response = await rootBundle.loadString('assets/songs.json');
    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
    return songs;
  }
}
