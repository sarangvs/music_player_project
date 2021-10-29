import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'managers/page_manager.dart';



//ignore: must_be_immutable
class MusicPlayerScreen extends StatefulWidget {
  SongModel songInfo;
  MusicPlayerScreen({required this.songInfo,required this.changeTrack,required this.key}):super(key:key);
  Function changeTrack;
  final GlobalKey<MusicPlayerScreenState> key;

  @override
  MusicPlayerScreenState createState() => MusicPlayerScreenState();


}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSong(widget.songInfo);
  }
  void dispose(){
    super.dispose();
    player.dispose();
  }

  void setSong(SongModel songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.data);
    currentValue=minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if(currentValue == maximumValue) {
      widget.changeTrack(true);
    }
    setState(() {
      currentTime=getDuration(currentValue);
      endTime=getDuration(maximumValue);
    });
    isPlaying=false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue=duration.inMilliseconds.toDouble();
      setState(() {
        currentTime=getDuration(currentValue);
        if(currentValue == maximumValue) {
          widget.changeTrack(true);
        }
      });
    });
  }
  void changeStatus(){
    setState(() {
      isPlaying=!isPlaying;
    });
    if(isPlaying){
      player.play();
    }else{
      player.pause();
    }
  }
  void nextSong(){
    setState(() {
      if(currentValue >= maximumValue){
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

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xff0B1444),
        title: const Text(
          "Now Playing",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff0B1444),
                  Color(0xaaFFFFFF),
                ])),
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
          child: Column(
            children: [
              // CircleAvatar(
              //   backgroundImage: widget.songInfo.albumArtwork == null
              //       ? AssetImage('assets/download.png') as ImageProvider
              //       : FileImage(File(widget.songInfo.albumArtwork)),
              //   radius: 95,
              // ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 7),
                child: Text(
                  widget.songInfo.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Text(
                  widget.songInfo.data,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Slider(
                  inactiveColor: Colors.white,
                  activeColor: Colors.blue,
                  min: minimumValue,
                  max: maximumValue,
                  value: currentValue,
                  onChanged: (value){
                    currentValue <= value;
                    player.seek(Duration(milliseconds: currentValue.round()));
                  }),
              Container(transform: Matrix4.translationValues(0, -5, 0),margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTime,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      endTime,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(transform: Matrix4.translationValues(0, 0, 0),margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.skip_previous, color: Colors.black, size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,onTap: (){
                      widget.changeTrack(false);
                    },
                    ),
                    GestureDetector(
                      child: Icon(isPlaying?Icons.pause_circle_outline_sharp:Icons.play_circle_outline_sharp, color: Colors.black, size: 100,
                      ),
                      behavior: HitTestBehavior.translucent,onTap: (){
                      changeStatus();
                    },
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.skip_next, color: Colors.black, size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,onTap: (){
                      widget.changeTrack(true);
                    },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}