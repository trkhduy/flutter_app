import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/service/apiService.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage(
      {super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  late double _currentAnimationPosition;
  late APIService service;
  bool _isShuffle = false;
  bool _isRepeat = false;

  @override
  void initState() {
    super.initState();
    _currentAnimationPosition = 0.0;
    _song = widget.playingSong;
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    _audioPlayerManager = AudioPlayerManager(songUrl: _song.source);
    _audioPlayerManager.init();
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
    service = APIService();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta);
    _audioPlayerManager.player
        .setLoopMode(_isRepeat ? LoopMode.one : LoopMode.off);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Now Playing",
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '_song.album',
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('_ ___ _'),
              const SizedBox(
                height: 48,
              ),
              RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loadingImage.png',
                    image: _song.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/loadingImage.png',
                        width: screenWidth - delta,
                        height: screenWidth - delta,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64, bottom: 16),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Column(
                        children: [
                          Text(
                            _song.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            _song.artist.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_outline))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, left: 24, right: 24, bottom: 16),
                child: _progressBar(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: _mediaButtons(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _imageAnimController.dispose();
    super.dispose();
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: _setShuffle,
              icon: Icons.shuffle,
              color: _getShuffleColor(),
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: Colors.deepPurple,
              size: 36),
          _playButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.deepPurple,
              size: 36),
          MediaButtonControl(
              function: _setRepeatSong,
              icon: Icons.repeat,
              color: _getRepeatColor(),
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapShot) {
          final durationState = snapShot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;

          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withOpacity(0.3),
            progressBarColor: Colors.green,
            bufferedBarColor: Colors.grey.withOpacity(0.3),
            thumbColor: Colors.deepPurple,
            thumbGlowColor: Colors.green.withOpacity(0.3),
            thumbRadius: 10.0,
          );
        });
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(0),
            width: 48,
            height: 48,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return MediaButtonControl(
              function: () {
                _audioPlayerManager.player.play();
                _imageAnimController.forward(from: _currentAnimationPosition);
                _imageAnimController.repeat();
              },
              icon: Icons.play_arrow,
              color: null,
              size: 48);
        } else if (processingState != ProcessingState.completed) {
          return MediaButtonControl(
              function: () {
                _audioPlayerManager.player.pause();
                _imageAnimController.stop();
                _currentAnimationPosition = _imageAnimController.value;
              },
              icon: Icons.pause,
              color: null,
              size: 48);
        } else {
          if (processingState == ProcessingState.completed) {
            _imageAnimController.stop();
            _currentAnimationPosition = 0.0;
          }
          return MediaButtonControl(
              function: () {
                _currentAnimationPosition = 0.0;
                _imageAnimController.forward(from: _currentAnimationPosition);
                _imageAnimController.repeat();
                _audioPlayerManager.player.seek(Duration.zero);
              },
              icon: Icons.replay,
              color: null,
              size: 48);
        }
      },
    );
  }

  void _setNextSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else {
      ++_selectedItemIndex;
    }

    if (_selectedItemIndex >= widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _currentAnimationPosition = 0.0;
      _imageAnimController.forward(from: _currentAnimationPosition);
      _imageAnimController.repeat();
      _song = nextSong;
    });
  }

  void _setPrevSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else {
      --_selectedItemIndex;
    }

    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _currentAnimationPosition = 0.0;
      _imageAnimController.forward(from: _currentAnimationPosition);
      _imageAnimController.repeat();
      _song = nextSong;
    });
  }

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getShuffleColor() {
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }

  void _setRepeatSong() {
    setState(() {
      _isRepeat = !_isRepeat;
    });
  }

  Color? _getRepeatColor() {
    return _isRepeat ? Colors.deepPurple : Colors.grey;
  }
}

class MediaButtonControl extends StatefulWidget {
  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
