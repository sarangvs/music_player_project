import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'Database/database_handler.dart';
import 'Database/db.dart';
import 'package:rxdart/rxdart.dart';
import 'managers/page_manager.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'notification_controll.dart';

class PlayScreen extends StatefulWidget {
  SongModel songInfo;

  PlayScreen(
      {required this.songInfo, required this.changeTrack, required this.Key})
      : super(key: Key);

  Function changeTrack;
  final GlobalKey<PlayScreenState> Key;

  @override
  PlayScreenState createState() => PlayScreenState();
}

class PlayScreenState extends State<PlayScreen> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;

  DatabaseHandler? handler;
  dynamic songTitle_2;
  dynamic songId_2;
  dynamic songData_2;

  //late final PageManger _pageManager;

  final AudioPlayer player = AudioPlayer();
  List<String> listName = [];

  @override
  void initState() {
    super.initState();
    // _pageManager = PageManger();
    addUser(songTitle_2, songId_2, songData_2);
    handler = DatabaseHandler();
    setSong(widget.songInfo);
    // songFav();
    player.play();
  }

  void dispose(){
    super.dispose();
    player.dispose();
  }

  Future<void> songFav() async {
    // handler =DatabaseHandler();
    listName = await handler!.retrieveFavUsers();
    for (int i = 0; i < listName.length; i++) {
      if (listName[i] == widget.songInfo.title) {
        setState(() {
          fav = 1;
        });
      } else {
        setState(() {
          fav = 0;
        });
      }
    }
  }

  //  @override
  //  void dispose() {
  // _pageManager.dispose();
  //    super.dispose();
  //  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, duration ?? Duration.zero));

  ///ADDING SONGS
  Future<int> addUser(songTitle_2, songId_2, songData_2) async {
    User firstUser =
        User(name: songTitle_2, num: songId_2, location: songData_2);
    List<User> listOfUsers = [firstUser];
    print("songtilte:$songTitle_2");
    print("songid: $songId_2");
    print("songdata: $songData_2");
    print('list of users $listOfUsers');
    return await handler!.insertUser(listOfUsers);
  }

  void setSong(SongModel songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.data);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
      songFav();
    }
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        if (currentValue == maximumValue) {
          widget.changeTrack(true);
           songFav();
        }
      });
    });
  }

  void stopSong() {
    setState(() {
      player.pause();
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    setState(() {
      if (isPlaying) {
        player.play();
      } else {
        player.pause();
      }
    });
  }

  void nextSong() {
    setState(() {
      if (currentValue >= maximumValue) {
        widget.changeTrack(true);
      }
    });
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  int fav = 0;
  int shuffle = 0;
  int repeat = 0;
  int play = 0;

//  bool isPlaying=false;
  bool isPaused = false;

  final List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  Widget build(BuildContext context) {
    // var bookmarkBloc = Provider.of<BookMarkBloc>(context);

    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[50],
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: Height - 250,
                  child: StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return QueryArtworkWidget(
                        id: widget.songInfo.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.zero,
                        nullArtworkWidget: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.zero,
                              color: Colors.black),
                          child: const Image(
                            image: AssetImage('images/musicimage.png'),
                            fit: BoxFit.cover,
                          ),
                          // height: 150,
                          // width: 100,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        stopSong();
                        debugPrint('Back button clicked');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: Height / 2.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero, topRight: Radius.circular(60)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: fav == 0
                                  ? const Icon(Icons.favorite_border)
                                  : const Icon(
                                      Icons.favorite,
                                      color: Colors.orange,
                                    ),
                              onPressed: () {
                                setState(() {
                                  songTitle_2 = widget.songInfo.title;
                                  songData_2 = widget.songInfo.data;
                                  songId_2 = widget.songInfo.id;
                                  addUser(songTitle_2, songId_2, songData_2);
                                  fav == 0 ? fav = 1 : fav = 0;
                                });
                              },
                            ),

                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            StreamBuilder<bool>(
                              stream: player.shuffleModeEnabledStream,
                              builder: (context, snapshot) {
                                final shuffleModeEnabled =
                                    snapshot.data ?? false;
                                return IconButton(
                                  icon: shuffleModeEnabled
                                      ? const Icon(Icons.shuffle,
                                          color: Colors.orange)
                                      : const Icon(Icons.shuffle,
                                          color: Colors.black),
                                  onPressed: () async {
                                    final enable = !shuffleModeEnabled;
                                    if (enable) {
                                      await player.shuffle();
                                    }
                                    await player.setShuffleModeEnabled(enable);
                                  },
                                );
                              },
                            ),
                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            StreamBuilder<LoopMode>(
                              stream: player.loopModeStream,
                              builder: (context, snapshot) {
                                final loopMode = snapshot.data ?? LoopMode.off;
                                const icons = [
                                  Icon(Icons.repeat, color: Colors.black),
                                  Icon(Icons.repeat, color: Colors.orange),
                                  Icon(Icons.repeat_one, color: Colors.orange),
                                ];
                                const cycleModes = [
                                  LoopMode.off,
                                  LoopMode.all,
                                  LoopMode.one,
                                ];
                                final index = cycleModes.indexOf(loopMode);
                                return IconButton(
                                  icon: icons[index],
                                  onPressed: () {
                                    player.setLoopMode(cycleModes[
                                        (cycleModes.indexOf(loopMode) + 1) %
                                            cycleModes.length]);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: Width,
                          child: StreamBuilder<SequenceState?>(
                            stream: player.sequenceStateStream,
                            builder: (context, snapshot) {
                              return Marquee(
                                text: widget.songInfo.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    color: Colors.black87),
                                blankSpace: 150,
                                velocity: 50,
                              );
                            },
                          ),
                        ),
                        Text(widget.songInfo.artist.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: Width - 15,
                          height: 50,
                          child: StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                onChangeEnd: (newPosition) {
                                  player.seek(newPosition);
                                },
                              );
                            },
                          ),
                        ),
                        // Container(
                        //   color: Colors.red,
                        //  // padding: const EdgeInsets.symmetric(horizontal: 30),
                        //   child: Row(
                        //   //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         currentTime,
                        //         style: const TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //       Text(
                        //         endTime,
                        //         style: const TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                StreamBuilder<SequenceState?>(
                                  stream: player.sequenceStateStream,
                                  builder: (context, snapshot) => IconButton(
                                      icon: const Icon(Icons.fast_rewind,
                                          size: 30, color: Colors.black),
                                      onPressed: () {
                                        widget.changeTrack(false);
                                        songFav();
                                      }),
                                ),
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: StreamBuilder<PlayerState>(
                                    stream: player.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      final playing = playerState?.playing;
                                      if (playing != true) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.orange,
                                            size: 70,
                                          ),
                                          onPressed: player.play,
                                        );
                                      } else {
                                        return IconButton(
                                          icon: const Icon(
                                              Icons.pause_circle_filled,
                                              color: Colors.orange,
                                              size: 70),
                                          onPressed: player.pause,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                StreamBuilder<SequenceState?>(
                                  stream: player.sequenceStateStream,
                                  builder: (context, snapshot) => IconButton(
                                      icon: const Icon(Icons.fast_forward,
                                          size: 30, color: Colors.black),
                                      onPressed: () {
                                        widget.changeTrack(true);
                                        songFav();
                                      }),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

// void showSliderDialog({
//   required BuildContext context,
//   required String title,
//   required int divisions,
//   required double min,
//   required double max,
//   String valueSuffix = '',
//   required double value,
//   required Stream<double> stream,
//   required ValueChanged<double> onChanged,
// }) {
//   showDialog<void>(
//     context: context,
//     builder: (context) => AlertDialog(
//       backgroundColor: Colors.white,
//       title: Text(title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//               color: Colors.white,
//               fontFamily: 'Gemunu',
//               fontWeight: FontWeight.bold,
//               fontSize: 24.0)),
//       content: StreamBuilder<double>(
//         stream: stream,
//         builder: (context, snapshot) => Container(
//           height: 100.0,
//           child: Column(
//             children: [
//               Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Gemunu',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24.0)),
//               Slider(
//                 inactiveColor: Colors.grey,
//                 activeColor: Colors.white,
//                 divisions: divisions,
//                 min: min,
//                 max: max,
//                 value: snapshot.data ?? value,
//                 onChanged: onChanged,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
