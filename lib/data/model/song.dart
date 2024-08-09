import 'package:music_app/data/model/aritst.dart';

class Song {
  String id;
  String title;
  Artist artist;
  String source;
  String image;
  int duration;
  int counter;
  int replay;

  Song(this.id, this.title, this.artist, this.source, this.image, this.duration,
      this.counter, this.replay);

  factory Song.fromJson(Map<String, dynamic> map) {
    return Song(
      map['id'] as String,
      map['title'] as String,
      Artist.fromJson(map['artist'] as Map<String, dynamic>),
      map['source'] as String,
      map['image'] as String,
      map['duration'] as int,
      map['counter'] as int,
      map['replay'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist.toJson(), // Chuyển đổi đối tượng Artist thành JSON
      'source': source,
      'image': image,
      'duration': duration,
      'counter': counter,
      'replay': replay,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artist, source: $source,'
        ' image: $image, duration: $duration, counter: $counter,'
        ' replay: $replay}';
  }
}
