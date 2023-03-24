import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/video_player_controls.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    required this.url,
    super.key,
  });

  final String url;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.network(
      widget.url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.darkBlack01,
      child: Center(
        child: _buildVideo(widget.url),
      ),
    );
  }

  Widget _buildVideo(String url) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_videoController),
            ClosedCaption(text: _videoController.value.caption.text),
            VideoPlayerControls(controller: _videoController),
            VideoProgressIndicator(
              _videoController,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: MyColors.yellow01,
                bufferedColor: MyColors.yellow02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
