import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  String songUrl;
  Stream<DurationState>? durationState;
  final player = AudioPlayer();

  AudioPlayerManager({required this.songUrl});

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playBackEvent) => DurationState(
            progress: position,
            buffered: playBackEvent.bufferedPosition,
            total: playBackEvent.duration));

    player.setUrl(songUrl);
  }
}

class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration? total;

  const DurationState(
      {required this.progress, required this.buffered, this.total});
}
