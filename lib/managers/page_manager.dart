import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/managers/service.dart';
import 'package:musicplayer/managers/songs.dart';



class PageManger {
  final _audioPlayer = getIt<AudioHandler>();
  final buttonNotifier = ValueNotifier(ButtonState.paused);
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(current: Duration.zero, total: Duration.zero),
  );



  PageManger() {
    _init();
  }

  static const path = 'Assets/Selena2.mp3';

  Future<void> _loadPlaylist() async {
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.addingSongs();
    final mediaItems = playlist
        .map((song) => MediaItem(
      id: song['id'] ?? '',
      album: song['album'] ?? '',
      title: song['title'] ?? '',
      extras: {'url': song['url']},
    ))
        .toList();

    _audioPlayer.addQueueItems(mediaItems);
  }


  void _init() async {
    await _loadPlaylist();

    _audioPlayer.playbackState.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);
      }
    });

    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        total: oldState.total,
      );
    });

    _audioPlayer.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,   total: mediaItem?.duration ?? Duration.zero,);
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {}
}

class ProgressBarState {
  final Duration current;
  final Duration total;

  ProgressBarState({required this.current, required this.total});
}

enum ButtonState { paused, playing }
