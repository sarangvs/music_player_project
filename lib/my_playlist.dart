import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/Database/playlist_db.dart';
import 'package:musicplayer/Database/playlist_folder_handler.dart';
import 'package:musicplayer/playlist_screen.dart';


class Myplaylist extends StatefulWidget {
  const Myplaylist({Key? key}) : super(key: key);

  @override
  _MyplaylistState createState() => _MyplaylistState();
}

class _MyplaylistState extends State<Myplaylist> {

  late PlaylistDatabaseHandler playlistHandler;
  dynamic playlistFolderName;
  dynamic songData;
  dynamic playlistID=1;

  @override
  void initState() {
    super.initState();
    playlistHandler = PlaylistDatabaseHandler();
    addPlaylist(playlistFolderName);
  }


  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  ///Add Playlist
  Future<int> addPlaylist(playlistFolderName) async {
    PlaylistFolder firstUser =
    PlaylistFolder(playListName: playlistFolderName);
    List<PlaylistFolder> listOfUsers = [firstUser];
    print("playlistName:$playlistFolderName");
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  final TextEditingController _textFieldController = TextEditingController();
  var folderName;

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery
        .of(context)
        .size
        .height;
    var Width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const Icon(Icons.add, color: Colors.black,),
            title: const Text('New Playlist...',
              style: TextStyle(color: Colors.black, fontSize: 18),),
          ), onTap: () {
          print('appbar print');
          _displayTextInputDialog(context);
        },
        ),
        body: Stack(
          children: [
            FutureBuilder(
                future: playlistHandler.retrievePlaylist(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PlaylistFolder>> snapshot) {
                  if (snapshot.hasData) {
                    debugPrint("Playlist folder data$snapshot");
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          playlistID = snapshot.data![index].id!;
                          return Container(

                            padding: const EdgeInsets.all(6),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                            'Are you sure to delete this playlist?',
                                            style: TextStyle(
                                                color: Colors.black54,
                                               ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Yes',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                    color: Colors.black54
                                                      )),
                                              onPressed: () async {
                                                await playlistHandler
                                                    .deletePlaylist(
                                                    snapshot
                                                        .data![index]
                                                        .id!);
                                                setState(() {
                                                  snapshot.data!.remove(
                                                      snapshot
                                                          .data![index]);
                                                });
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                  color: Colors.black54
                                                   ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: [
                                       ListTile(
                                        leading: const Icon(
                                          Icons.playlist_add,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                        title: Text(snapshot.data![index].playListName,style:  const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,),
                                      ),
                                         onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  PlaylistScreen(playlistfolderID:  playlistID ,),));
                                         },
                                       ),
                                      const Divider(
                                        height: 0,
                                        indent: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );

                        }
                    );
                  }
                  return Container();
                }
            )
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(playlistID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                title: const Text(
                  'New Playlist',
                  style: TextStyle(
                      fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                ),
                content: TextField(
                  onChanged: (value) {
                    setState(() {
                      folderName = _textFieldController.text;
                    });
                  },
                  controller: _textFieldController,
                  decoration: const InputDecoration(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // debugPrint(folderName);
                      folderName = _textFieldController.text;
                      setState(() {
                        playlistFolderName = folderName;
                        addPlaylist(playlistFolderName);
                      });
                    },
                    child: const Text('Done',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          );
        });
  }
}

///Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

   CustomAppBar({ required this.onTap, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}