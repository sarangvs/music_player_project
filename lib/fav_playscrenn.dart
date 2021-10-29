import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'managers/page_manager.dart';


class FavPlayScreen extends StatefulWidget {
  dynamic songData;
  dynamic songTitle;
  dynamic songID;
   FavPlayScreen({required this.songData,required this.songTitle,required this.songID,required this.changeTrack,required this.Key}) : super(key: Key);

  Function changeTrack;
 final GlobalKey<FavPlayScreenState> Key;

  @override
  FavPlayScreenState createState() => FavPlayScreenState();
}

class FavPlayScreenState extends State<FavPlayScreen> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;


  // late final PageManger _pageManager;

  final AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    // _pageManager = PageManger();
    setSong(widget.songData);
  }

  double valueReturn(double min, double max, double current){
    if(current >= min && current <= max){
      return current;
    }else{
      setState(() {
        widget.changeTrack(true);
      });
      return max;
    }
  }

  // @override
  // void dispose() {
  //   // _pageManager.dispose();
  //   super.dispose();
  // }


  void setSong(dynamic songData) async {
    widget.songData = songData;
    await player.setUrl(widget.songData);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
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
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
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


  bool isPaused=false;

  final List<IconData> _icons=[
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  Widget build(BuildContext context) {
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
                  height: Height - 168,
                  child: QueryArtworkWidget(
                    id: widget.songID,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.zero,
                    nullArtworkWidget: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: Colors.black),
                      child:  const Image(
                        image: AssetImage('images/musicimage.png'),fit: BoxFit.cover,
                      ),
                      // height: 150,
                      // width: 100,
                    ),
                  )
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
                        player.pause();
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     IconButton(
                        //       icon: fav == 0
                        //           ? const Icon(Icons.favorite_border)
                        //           : const Icon(
                        //         Icons.favorite,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("fav button");
                        //         setState(() {
                        //           fav == 0 ? fav = 1 : fav = 0;
                        //         });
                        //       },
                        //     ),
                        //     // SizedBox(
                        //     //   width: Width / 5,
                        //     // ),
                        //     IconButton(
                        //       icon: shuffle == 0
                        //           ? const Icon(Icons.shuffle)
                        //           : const Icon(
                        //         Icons.shuffle,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("Shuffle button");
                        //         setState(() {
                        //           shuffle == 0 ? shuffle = 1 : shuffle = 0;
                        //         });
                        //       },
                        //     ),
                        //     // SizedBox(
                        //     //   width: Width / 5,
                        //     // ),
                        //     IconButton(
                        //       icon: repeat == 0
                        //           ? const Icon(Icons.repeat)
                        //           : const Icon(
                        //         Icons.repeat,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("repeat button");
                        //         setState(() {
                        //           repeat == 0 ? repeat = 1 : repeat = 0;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 50,
                          width: Width,
                          child: Marquee(
                            text: widget.songTitle,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'roboto',
                                color: Colors.black87),
                            blankSpace: 150,
                            velocity: 50,
                          ),
                        ),
                         const Text('<unknown>'),
                        const SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                            width: Width-15,
                            height: 25,
                            child: Slider(
                                inactiveColor: Colors.grey,
                                activeColor: Colors.orange,
                                min: minimumValue,
                                max: maximumValue,
                                value: valueReturn(maximumValue, maximumValue, currentValue),
                                onChanged: (value) {
                                  setState(() {
                                    currentValue = value;
                                    player.seek(Duration(
                                        milliseconds: currentValue.toInt()));
                                  });
                                }),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(currentTime,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),),
                              Text(endTime,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.fast_rewind,
                                size: 30,
                              ),
                              onPressed: () {
                                widget.changeTrack(false);
                                debugPrint('previous');
                              },
                              //       padding: const EdgeInsets.all(8.0),
                            ),
                            SizedBox(
                                height: 90,
                                width: 90,
                                child: GestureDetector(
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.orange,
                                    size: 70,
                                  ),
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    changeStatus();
                                  },
                                ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.fast_forward,
                                size: 30,
                              ),
                              onPressed: () {
                                widget.changeTrack(true);
                                debugPrint('next');
                              },
                            ),
                            const SizedBox(
                              width: 50,
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