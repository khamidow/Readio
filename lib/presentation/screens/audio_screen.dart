import 'package:audio_pdf_book_flutter/models/pdf_book.dart';
import 'package:audio_pdf_book_flutter/presentation/screens/reader_screen.dart';
import 'package:audio_pdf_book_flutter/services/audio_player_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioScreen extends StatefulWidget {
  final PdfBook bookData;

  const AudioScreen({super.key, required this.bookData});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final _service = audioHandler;

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  int _selectedIndex = 0;

  late final List<void Function()> _cancellers;

  String _fmt(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isThisBookPlaying =>
      _service.currentTitle ==
          widget.bookData.title;

  Future<void> _playSelected() async {
    if (widget.bookData.audioUrls.isEmpty) return;
    final url = widget.bookData.audioUrls[_selectedIndex];
    await _service.playUrl(
      url: url,
      bookTitle: widget.bookData.title,
      trackIndex: _selectedIndex,
    );
  }

  Future<void> _togglePlayPause() async {
    if (_isThisBookPlaying && _isPlaying) {
      await _service.pause();
    } else {
      await _playSelected();
    }
  }

  void _seekToSeconds(int seconds) {
    _service.seek(Duration(seconds: seconds));
  }

  void _seekBy(int seconds) {
    final newPos = _position + Duration(seconds: seconds);
    if (newPos < Duration.zero) {
      _service.seek(Duration.zero);
    } else if (_duration != Duration.zero && newPos > _duration) {
      _service.seek(_duration);
    } else {
      _service.seek(newPos);
    }
  }

  @override
  void initState() {
    super.initState();

    if (_service.currentBookTitle == widget.bookData.title &&
        _service.currentTrackIndex >= 0) {
      _selectedIndex = _service.currentTrackIndex;
    }

    _isPlaying = _isThisBookPlaying && _service.isPlaying;
    _position = _isThisBookPlaying ? (_service.position) : Duration.zero;
    _duration = _isThisBookPlaying
        ? (_service.duration ?? Duration.zero)
        : Duration.zero;

    final s1 = _service.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = _isThisBookPlaying && state.playing;
      });
    });

    final s2 = _service.positionStream.listen((pos) {
      if (!mounted) return;
      if (_isThisBookPlaying) {
        setState(() => _position = pos);
      }
    });

    final s3 = _service.durationStream.listen((dur) {
      if (!mounted) return;
      if (_isThisBookPlaying && dur != null) {
        setState(() => _duration = dur);
      }
    });

    _cancellers = [s1.cancel, s2.cancel, s3.cancel];
  }

  @override
  void dispose() {
    for (final cancel in _cancellers) {
      cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 102),
            _buildTrackInfo(),
            const SizedBox(height: 32),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildControls(),
            const SizedBox(height: 36),
            _buildSecondaryActions(),
            _buildTrackList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        ClipPath(
          clipper: _HeaderClipper(),
          child: Container(
            height: 260,
            width: double.infinity,
            color: Colors.redAccent,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -72,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReaderScreen(
                  pdfUrl: widget.bookData.pdfUrl,
                  title: widget.bookData.title,
                ),
              ),
            ),
            child: Container(
              width: 170,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.bookData.coverUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, _) => Container(
                    color: const Color(0xFFF0E0E0),
                    child: Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 64,
                        color: Colors.redAccent.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            widget.bookData.audioUrls.isNotEmpty
                ? '${widget.bookData.title} - ${_selectedIndex + 1}'
                : widget.bookData.title,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.bookData.title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Stephen King',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final showProgress = _isThisBookPlaying;
    final sliderValue = (showProgress && _duration.inSeconds > 0)
        ? (_position.inSeconds / _duration.inSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3.5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: Colors.redAccent,
              inactiveTrackColor: Colors.black26,
              thumbColor: Colors.redAccent,
              overlayColor: Colors.redAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: sliderValue,
              onChanged: showProgress
                  ? (value) {
                      final newSec = (value * _duration.inSeconds).toInt();
                      _seekToSeconds(newSec);
                    }
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showProgress ? _fmt(_position.inSeconds) : '00:00',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  showProgress ? _fmt(_duration.inSeconds) : '00:00',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () async {
              if (_selectedIndex > 0) {
                setState(() => _selectedIndex--);
                await _playSelected();
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.replay_10_rounded,
              color: Colors.black87,
              size: 28,
            ),
            onPressed: () => _seekBy(-10),
          ),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.forward_10_rounded,
              color: Colors.black87,
              size: 28,
            ),
            onPressed: () => _seekBy(10),
          ),
          IconButton(
            icon: const Icon(
              Icons.skip_next_rounded,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () async {
              if (_selectedIndex < widget.bookData.audioUrls.length - 1) {
                setState(() => _selectedIndex++);
                await _playSelected();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.bedtime_outlined,
              color: Colors.black45,
              size: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.repeat_rounded,
              color: Colors.black45,
              size: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: Colors.black45,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.bookData.audioUrls.length,
      itemBuilder: (context, index) {
        final isSelected = index == _selectedIndex;
        final isThisTrackPlaying =
            _isThisBookPlaying &&
            _service.currentTrackIndex == index &&
            _isPlaying;

        return ListTile(
          onTap: () async {
            setState(() => _selectedIndex = index);
            await _service.pause();
            await _playSelected();
          },
          title: Text(
            '${widget.bookData.title} - ${index + 1}',
            style: TextStyle(
              color: isSelected ? Colors.redAccent : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isThisTrackPlaying
              ? const Icon(Icons.graphic_eq, color: Colors.redAccent)
              : isSelected
              ? const Icon(Icons.pause_circle_outline, color: Colors.redAccent)
              : null,
        );
      },
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper oldClipper) => false;
}
