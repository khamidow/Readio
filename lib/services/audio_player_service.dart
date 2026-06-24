import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

late AudioPlayerService audioHandler;

Future<AudioPlayerService> initAudioService() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.audio_pdf_book_flutter.audio',
      androidNotificationChannelName: 'Audio Book Player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  return audioHandler;
}
class AudioPlayerService extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  String? currentBookTitle;
  int currentTrackIndex = -1;

  AudioPlayerService() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenToPosition();
    _listenToDuration();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });
  }

  void _listenToPosition() {
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
  }

  void _listenToDuration() {
    _player.durationStream.listen((duration) {
      final currentItem = mediaItem.value;

      if (currentItem != null && duration != null) {
        mediaItem.add(currentItem.copyWith(duration: duration));
      }
    });
  }

  Future<void> playUrl({
    required String url,
    required String bookTitle,
    required int trackIndex,
    String? imageUrl,
  }) async {
    final alreadyLoaded =
        currentBookTitle == bookTitle && currentTrackIndex == trackIndex;

    if (!alreadyLoaded) {
      currentBookTitle = bookTitle;
      currentTrackIndex = trackIndex;

      mediaItem.add(
        MediaItem(
          id: url,
          title: bookTitle,
          artist: 'Audio Book',
          artUri: imageUrl != null ? Uri.parse(imageUrl) : null,
        ),
      );

      await _player.setUrl(url);
    }

    await play();
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> stop() async {
    await _player.stop();

    currentBookTitle = null;
    currentTrackIndex = -1;

    await super.stop();
  }

  @override
  Future<void> fastForward() async {
    await seek(_player.position + const Duration(seconds: 10));
  }

  @override
  Future<void> rewind() async {
    await seek(_player.position - const Duration(seconds: 10));
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool isCurrentTrack(String bookTitle, int trackIndex) {
    return currentBookTitle == bookTitle && currentTrackIndex == trackIndex;
  }

  Duration get position => _player.position;

  Duration? get duration => _player.duration;

  bool get isPlaying => _player.playing;

  String? get currentTitle => mediaItem.value?.title;
}
