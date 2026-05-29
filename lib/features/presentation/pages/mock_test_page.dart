import 'package:flutter/material.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:mevtech/core/network/signalr_service.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MockTestPage extends StatefulWidget {
  const MockTestPage({super.key});

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage> {
  //  with TickerProviderStateMixin
  // late TabController _tabController;

  final SignalRService _signalRService = SignalRService(
      userId: MevTechUtilities.id, token: MevTechUtilities.authKey);
  final String targetUserId = '70c4e4f6-cba1-4635-5e92-08ddb88cec3b';

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
    _signalRService.initSignalR();
  }

  @override
  void dispose() {
    _signalRService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SignalR'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of sending a message
            _signalRService.sendChatMessage(
              targetUserId,
              'Hello from Austinero, this is a test message to kunle! 👋',
            );
          },
          child: const Text('Send Test Message'),
        ),
      ),
    );
    // Scaffold(
    //   appBar: AppBar(),
    //   body: const Center(
    //     child: Text('Mocktest Page'),
    //   ),
    // );
  }
}

// class CourseYoutubePlayer extends StatefulWidget {
//   const CourseYoutubePlayer({required this.videoId, super.key});
//   final String videoId;

//   @override
//   State<CourseYoutubePlayer> createState() => _CourseYoutubePlayerState();
// }

// class _CourseYoutubePlayerState extends State<CourseYoutubePlayer> {
//   late YoutubePlayerController _controller;
//   String? _title;
//   String? _author;
//   Duration? _duration;

//   @override
//   void initState() {
//     super.initState();

//     // Extract video ID
//     // final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';

//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//       ),
//     );

//     // Listen for metadata updates
//     _controller.addListener(() {
//       final metadata = _controller.metadata;
//       if (metadata.title.isNotEmpty) {
//         setState(() {
//           _title = metadata.title;
//           _author = metadata.author;
//           _duration = metadata.duration;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//       ),
//       builder: (context, player) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             player,
//             const SizedBox(height: 8),
//             if (_title != null) ...[
//               Text(
//                 _title!,
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const SizedBox(height: 4),
//             ],
//             if (_author != null)
//               Text(
//                 'By $_author',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             if (_duration != null)
//               Text(
//                 'Duration: ${_formatDuration(_duration!)}',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// @module
// abstract class RepositoryModule {
//   @lazySingleton
//   http.Client client() => http.Client();

//   @lazySingleton
//   GenericRepository<Course> courseRepository(http.Client client) {
//     return GenericRepository<Course>(
//       client: client,
//       baseUrl: 'https://yourapi.com/api/courses',
//       fromJson: (json) => Course.fromJson(json),
//     );
//   }

//   @lazySingleton
//   GenericRepository<User> userRepository(http.Client client) {
//     return GenericRepository<User>(
//       client: client,
//       baseUrl: 'https://yourapi.com/api/users',
//       fromJson: (json) => User.fromJson(json),
//     );
//   }

//   // Add as many model-specific repositories as needed
// }
