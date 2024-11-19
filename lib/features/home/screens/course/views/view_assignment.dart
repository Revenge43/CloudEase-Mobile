import 'dart:async'; // Import for Timer
import 'package:cloudease/features/home/data/home_provider.dart';
import 'package:cloudease/features/home/screens/course_comments.dart';
import 'package:cloudease/models/assignment.dart';
import 'package:cloudease/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ViewAssignment extends StatefulWidget {
  final Assignment assignment;
  const ViewAssignment({super.key, required this.assignment});

  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  late VideoPlayerController _controller;
  bool isVideo = false;
  double volume = 1.0;
  double _sliderValue = 0.0; // Slider value variable
  Timer? _timer; // Timer variable
  bool isFullScreen = false; // Full-screen state

  @override
  void initState() {
    super.initState();
    fetchAssignmentById();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    if (isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_controller.value.isInitialized && _controller.value.isPlaying) {
          _sliderValue = _controller.value.position.inSeconds.toDouble(); // Update slider value
        }
      });
    });
  }

  Future<void> fetchAssignmentById() async {
    String assignmentFile = 'example.mp4'; // Replace with actual file name
    isVideo = _isVideoFile(assignmentFile);
    if (isVideo) {
      _controller = VideoPlayerController.network(
        'https://onvatnocrobzlxendxxd.supabase.co/storage/v1/object/public/assets/443605eb952cb44c92502b5e2d6552fe.mp4',
      )..initialize().then((_) {
          setState(() {
            _controller.setVolume(1.0); // Set initial volume
            _startTimer(); // Start the timer when the video is initialized
            _sliderValue = 0.0; // Initialize slider value
          });
        });

      // Add a listener to update the slider value when the video position changes
      _controller.addListener(() {
        if (_controller.value.isInitialized && _controller.value.isPlaying) {
          setState(() {
            _sliderValue = _controller.value.position.inSeconds.toDouble();
          });
        }
      });
    }
  }

  bool _isVideoFile(String fileName) {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.flv'];
    return videoExtensions.any((ext) => fileName.toLowerCase().endsWith(ext));
  }

  void _increaseVolume() {
    setState(() {
      volume = (volume + 0.1).clamp(0.0, 1.0);
      _controller.setVolume(volume);
    });
  }

  void _decreaseVolume() {
    setState(() {
      volume = (volume - 0.1).clamp(0.0, 1.0);
      _controller.setVolume(volume);
    });
  }

  void _seekTo(double value) {
    _controller.seekTo(Duration(seconds: value.toInt())); // Seek to the new position
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Video'),
        backgroundColor: lightBlue,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(color: white, fontSize: 17),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HtmlWidget(''' ${widget.assignment.assignmentDescription} '''),

              // Display video content if video is available and initialized
              if (isVideo && _controller.value.isInitialized)
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () {
                          // Toggle play/pause when tapped on the video
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    // Display video time
                    Text(
                      '${_controller.value.position.inMinutes}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / ${_controller.value.duration.inMinutes}:${(_controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Slider for video seeking
                    Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value; // Update slider value while dragging
                        });
                        _seekTo(value); // Seek to the new position immediately while dragging
                      },
                      onChangeEnd: (value) {
                        _seekTo(value); // Seek to the new position when the dragging ends
                      },
                    ),
                  ],
                ),

              // Volume and Control Buttons in a row
              if (isVideo)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Volume Down Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _decreaseVolume,
                        child: const Icon(
                          Icons.volume_down,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20), // Add space between buttons

                      // Play/Pause Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20), // Add space between buttons

                      // Volume Up Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _increaseVolume,
                        child: const Icon(
                          Icons.volume_up_sharp,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20), // Add space between buttons
                    ],
                  ),
                ),

                // CourseCommentsWidget(commentsStream: homeProvider.getCommentStream(), onSubmitComment: (text, file) {}, extra: {})
            ],
          ),
        ),
      ),
    );
  }
}
