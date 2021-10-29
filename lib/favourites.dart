import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/db.dart';
import 'package:musicplayer/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import './Database/database_handler.dart';
import './fav_playscrenn.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final GlobalKey<FavPlayScreenState> Key = GlobalKey<FavPlayScreenState>();

  List<SongModel> favSongs = [];
  int currentIndex = 0;

  DatabaseHandler? handler;
  late final AudioPlayer player;
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    // Future <List<User>> data = handler!.retrieveFavUsers();
    player = AudioPlayer();
    getTracks();
  }

  void getTracks() async {
    favSongs = await audioQuery.querySongs();
    setState(() {
      favSongs = favSongs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != favSongs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    Key.currentState!.setSong(favSongs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    // var bookmarkBloc = Provider.of<BookMarkBloc>(context);

    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: this.handler!.retrieveUsers(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete_forever),
                        ),
                        key: ValueKey<int>(snapshot.data![index].id!),
                        onDismissed: (DismissDirection direction) async {
                          await handler!.deleteUser(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: ListTile(
                          title: Text(
                            snapshot.data![index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            snapshot.data![index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: SizedBox(
                            height: Height / 7,
                            width: Width / 7,
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.orange,
                              size: 42,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(10),
                            id: snapshot.data![index].num,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey),
                              child:const Image(
                                image: AssetImage('images/musicimage.png'),
                              ),
                            ),
                          ),
                          onTap: () {
                            dynamic songData = snapshot.data![index].location;
                            dynamic songTitle = snapshot.data![index].name;
                            dynamic songID = snapshot.data![index].num;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavPlayScreen(
                                    songData: songData,
                                    songTitle: songTitle,
                                    songID: songID,
                                    changeTrack: changeTrack,
                                    Key: Key,
                                  ),
                                ));
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
