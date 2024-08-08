/*
*  {
      "id": "1130295694",
      "title": "Như Anh Đã Thấy Em",
      "album": "Chẳng Thể Tìm Được Em 2",
      "artist": "Phúc XP ft Freak D",
      "source": "https://thantrieu.com/resources/music/1130295694.mp3",
      "image": "https://thantrieu.com/resources/arts/1130295694.webp",
      "duration": 302,
      "favorite": "false",
      "counter": 40,
      "replay": 0
    }
* */

class Song {
  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  int duration;
  String favorite;
  int counter;
  int replay;

// 1: yes 0: no
  Song(this.id, this.title, this.album, this.artist, this.source, this.image,
      this.duration, this.favorite, this.counter, this.replay);

  factory Song.fromJson(Map<String, dynamic> map) {
    return Song(
      map['id'] as String,
      map['title'] as String,
      map['album'] as String,
      map['artist'] as String,
      map['source'] as String,
      map['image'] as String,
      map['duration'] as int,
      map['favorite'] as String,
      map['counter'] as int,
      map['replay'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $album, artist: $artist, '
        'source: $source, image: $image, duration: $duration, '
        'favorite: $favorite, counter: $counter, replay: $replay}';
  }
}
