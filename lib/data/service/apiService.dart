import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:music_app/data/model/song.dart';

class APIService{

  final String baseUrl = 'http://localhost:8080/api/v1/song/update/'; // Thay đổi URL theo API thực tế

  Future<void> updateSong(String id, Song song) async {
    final url = Uri.parse('$baseUrl/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(song.toJson()),
      );

      if (response.statusCode == 200) {
        // Thành công
        print('Song updated successfully.');
      } else {
        // Xử lý lỗi nếu status code không phải 200
        print('Failed to update song: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi khi có exception
      print('Error updating song: $e');
    }
  }

}