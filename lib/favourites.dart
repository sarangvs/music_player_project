import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import './Database/database_handler.dart';
import './fav_playscrenn.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final GlobalKey<FavPlayScreenState> key = GlobalKey<FavPlayScreenState>();

  List<SongModel> favSongs = [];
  int currentIndexFav = 0;

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

  void changeFavTrack(bool isNext) {
    if (isNext) {
      if (currentIndexFav != favSongs.length - 1) {
        currentIndexFav++;
      }
    } else {
      if (currentIndexFav != 0) {
        currentIndexFav--;
      }
    }
    key.currentState!.setSong(favSongs[currentIndexFav]);
  }

  @override
  Widget build(BuildContext context) {
    // var bookmarkBloc = Provider.of<BookMarkBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: handler!.retrieveUsers(),
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
                        key: ValueKey<int>(snapshot.data![index].num),
                        onDismissed: (DismissDirection direction) async {
                          await handler!.deleteUser(snapshot.data![index].num);
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
                            height: screenHeight / 7,
                            width: screenWidth / 7,
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
                           for(int i = 0; i<favSongs.length;i++){
                             if(favSongs[i].id== snapshot.data![index].num){
                               currentIndexFav=i;
                               break;
                             }
                           }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavPlayScreen(
                                    songData: favSongs[currentIndexFav],
                                    changeTrack: changeFavTrack,
                                    key: key,
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
