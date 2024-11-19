import 'dart:io';
import 'package:cloudease/models/comments.dart';
import 'package:cloudease/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class CourseCommentsWidget extends StatefulWidget {
  final Stream<List<Comment>> commentsStream;
  final Function(String, File?) onSubmitComment;
  final Map<String, dynamic> extra;

  const CourseCommentsWidget({
    super.key,
    required this.commentsStream,
    required this.onSubmitComment,
    required this.extra
  });

  @override
  State<CourseCommentsWidget> createState() => _CourseCommentsWidgetState();
}

class _CourseCommentsWidgetState extends State<CourseCommentsWidget> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    final Stream<List<Comment>> commentsStream = widget.extra['commentsStream'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlue,
        iconTheme: IconThemeData(color: white),
        title: Text(widget.extra['courseTitle'] ?? ''),
        titleTextStyle: TextStyle(color: white, fontSize: 17),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () => context.go('/home'),
          ),
      ),
      body: StreamBuilder<List<Comment>>(
        stream: commentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
          final sampledComments = [
              Comment(
                id: 1,
                userId: 101,
                text: 'Here\'s my solution to the exercise!',
                timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
                mediaUrl: 'https://picsum.photos/800/600', // Random sample image
                mediaType: MediaType.image,
              ),
              Comment(
                id: 2,
                userId: 102,
                text: 'Another approach to consider',
                timestamp: DateTime.now().subtract(const Duration(hours: 2)),
                mediaUrl: 'https://picsum.photos/seed/coding/800/600', // Different random image
                mediaType: MediaType.image,
              ),
              Comment(
                id: 3,
                userId: 103,
                text: 'This is a comment without any image',
                timestamp: DateTime.now().subtract(const Duration(days: 1)),
              ),
              Comment(
                id: 4,
                userId: 104,
                text: 'Check out this diagram I made',
                timestamp: DateTime.now().subtract(const Duration(hours: 4)),
                mediaUrl: 'https://picsum.photos/seed/diagram/800/600', // Another random image
                mediaType: MediaType.image,
              ),
            ];

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: sampledComments.length,
              itemBuilder: (context, index) {
                return _CommentTile(comment: sampledComments[index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _selectedFile = null),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      setState(() {
                        _selectedFile = File(result.files.single.path!);
                      });
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    final text = _commentController.text.trim();
                    if (text.isNotEmpty) {
                      widget.onSubmitComment(text, _selectedFile);
                      _commentController.clear();
                      setState(() => _selectedFile = null);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  comment.userId.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(comment.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(fontSize: 14),
                    ),
                    // Add media content if available
                    if (comment.mediaUrl != null) ...[
                      const SizedBox(height: 8),
                      _buildMediaContent(comment.mediaUrl!, comment.mediaType!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(String mediaUrl, MediaType mediaType) {
    switch (mediaType) {
      case MediaType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.error)),
          ),
        );
      case MediaType.video:
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  comment.thumbnailUrl ?? mediaUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              // Play button overlay
              IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  size: 48,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Implement video playback logic here
                },
              ),
            ],
          ),
        );
    }
  }
  // ... rest of the code ...
}

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
  }
