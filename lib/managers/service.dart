import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:musicplayer/managers/page_manager.dart';
import 'package:musicplayer/managers/songs.dart';

import 'audio_handler.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  // page state
  getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());

  getIt.registerLazySingleton<PageManger>(() => PageManger());
}
