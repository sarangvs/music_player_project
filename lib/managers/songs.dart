abstract class PlaylistRepository {
  Future<List<Map<String, String>>> addingSongs();
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> addingSongs(
      {int length = 3}) async {
    return List.generate(length, (index) => _nextSong());
  }


  Map<String, String> _nextSong() {
    return {
      'id': '1',
      'title': 'Stay',
      'album': 'Justin bieber',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
    };
  }
}
