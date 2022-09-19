import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";

class AudioPlayerCard extends StatefulWidget {
  const AudioPlayerCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(247, 247, 247, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  String url =
                      "https://file-examples.com/storage/fe49a9fa16632246e9a1f3a/2017/11/file_example_MP3_700KB.mp3";
                  await audioPlayer.play(UrlSource(url));
                }
              },
              icon: isPlaying
                  ? const Icon(
                      Icons.pause,
                      color: Colors.grey,
                    )
                  : const Icon(
                      Icons.play_arrow,
                      color: Colors.grey,
                    ),
            ),
            Slider(
                thumbColor: Colors.grey,
                activeColor: Colors.grey,
                inactiveColor: Colors.grey,
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                }),

            //Text(formatTime(position)) //duration in text format
          ],
        ),
      ),
    );
  }
}
