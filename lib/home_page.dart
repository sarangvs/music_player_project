import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'music_player_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerScreenState> key=GlobalKey<MusicPlayerScreenState>();

  @override
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.querySongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext){
    if(isNext){
      if(currentIndex!=songs.length-1){
        currentIndex++;
      }
    }else{
      if(currentIndex!=0){
        currentIndex--;
      }
    }
    key.currentState!.setSong(songs[currentIndex]);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0B1444),
                Color(0xaaFFFFFF),
              ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "HOME",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 50, 10),
          child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                if(songs[index].data.contains("mp3")) {
                  return Card(
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            currentIndex = index;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MusicPlayerScreen(
                                  changeTrack:changeTrack,
                                  songInfo: songs[currentIndex],
                                  key: key,
                                )));
                          },
                          child:  ListTile(
                            tileColor: const Color(0xcc6C6C6C),
                            // leading: CircleAvatar(
                            //   backgroundImage: songs[index].albumArtwork == null
                            //       ? AssetImage('assets/download.png')
                            //       : FileImage(File(songs[index].albumArtwork)),
                            // ),
                            title: Text(
                              songs[index].title,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                         //   subtitle: Text(songs[index].artist),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.playlist_add,
                                        size: 30,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite_border))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  height: 0,
                );
              }),
        ),
      ),
    );
  }
}