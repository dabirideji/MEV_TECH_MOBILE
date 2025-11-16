// // // - counter_bloc.dart        <-- the actual Bloc class
// // // - counter_event.dart       <-- events the Bloc responds to
// // // - counter_state.dart       <-- possible states the UI listens to
// // // - counter_view.dart        <-- UI screen (usually a widget)

// // 1. //Define Events
// // // counter_event.dart
// // abstract class CounterEvent {}

// // class Increment extends CounterEvent {}

// // class Decrement extends CounterEvent {}

// // 2. //Define States
// // // counter_state.dart
// // class CounterState {
// //   final int count;
// //   CounterState(this.count);
// // }

// // 3. //Create Bloc
// // // counter_bloc.dart
// // import 'package:bloc/bloc.dart';
// // import 'counter_event.dart';
// // import 'counter_state.dart';

// // class CounterBloc extends Bloc<CounterEvent, CounterState> {
// //   CounterBloc() : super(CounterState(0)) {
// //     on<Increment>((event, emit) {
// //       emit(CounterState(state.count + 1));
// //     });

// //     on<Decrement>((event, emit) {
// //       emit(CounterState(state.count - 1));
// //     });
// //   }
// // }

// // 4. //Using it in the UI
// // // counter_view.dart
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'counter_bloc.dart';
// // import 'counter_event.dart';
// // import 'counter_state.dart';

// // class CounterView extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (_) => CounterBloc(),
// //       child: Scaffold(
// //         appBar: AppBar(title: Text('BLoC Counter')),
// //         body: Center(
// //           child: BlocBuilder<CounterBloc, CounterState>(
// //             builder: (context, state) {
// //               return Text('Count: ${state.count}', style: TextStyle(fontSize: 24));
// //             },
// //           ),
// //         ),
// //         floatingActionButton: Row(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             FloatingActionButton(
// //               heroTag: "inc",
// //               onPressed: () => context.read<CounterBloc>().add(Increment()),
// //               child: Icon(Icons.add),
// //             ),
// //             SizedBox(width: 10),
// //             FloatingActionButton(
// //               heroTag: "dec",
// //               onPressed: () => context.read<CounterBloc>().add(Decrement()),
// //               child: Icon(Icons.remove),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:carousel_slider/carousel_slider.dart';

// // class MyCarouselWithButtons extends StatefulWidget {
// //   const MyCarouselWithButtons({super.key});

// //   @override
// //   State<MyCarouselWithButtons> createState() => _MyCarouselWithButtonsState();
// // }

// // class _MyCarouselWithButtonsState extends State<MyCarouselWithButtons> {
// //   final CarouselController _controller = CarouselController();
// //   int _currentIndex = 0;

// //   final List<String> items = ['One', 'Two', 'Three', 'Four'];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         // The Carousel

// //         const SizedBox(height: 10),

// //         // Arrow buttons
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             IconButton(
// //               onPressed: () => _controller.previousPage(),
// //               icon: const Icon(Icons.arrow_back_ios),
// //             ),
// //             Text('${_currentIndex + 1} / ${items.length}'),
// //             IconButton(
// //               onPressed: () => _controller.nextPage(),
// //               icon: const Icon(Icons.arrow_forward_ios),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// // options: CarouselOptions(
// //             height: 200,
// //             viewportFraction: 1.0, // full width
// //             enableInfiniteScroll: true,
// //             enlargeCenterPage: false,
// //             onPageChanged: (index, reason) {
// //               setState(() {
// //                 _currentIndex = index;
// //               });
// //             },
// //           ),

// //           void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await configureDependencies(); // <--- Initialize get_it & injectable

// //   final courseCubit = getIt<CourseCubit>();
// //   await courseCubit.loadCourses(); // <--- Preload the data

// //   runApp(MyApp());
// // }

// // class CoursesPage extends StatelessWidget {
// //   const CoursesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider.value(
// //       value: getIt<CourseCubit>(), // Already loaded
// //       child: BlocBuilder<CourseCubit, CourseState>(
// //         builder: (context, state) {
// //           if (state is CoursesLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (state is CoursesLoaded) {
// //             return ListView(
// //               children: state.courses.map((e) => ListTile(title: Text(e))).toList(),
// //             );
// //           } else {
// //             return const SizedBox.shrink();
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';

// // class ExpandingHeader extends StatefulWidget {
// //   const ExpandingHeader({super.key});

// //   @override
// //   State<ExpandingHeader> createState() => _ExpandingHeaderState();
// // }

// // class _ExpandingHeaderState extends State<ExpandingHeader> {
// //   bool _isExpanded = false;

// //   void _toggleMenu() {
// //     setState(() {
// //       _isExpanded = !_isExpanded;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedContainer(
// //       duration: const Duration(milliseconds: 300),
// //       padding: const EdgeInsets.all(16),
// //       height: _isExpanded ? 250 : 70, // Expanded or collapsed height
// //       width: double.infinity,
// //       color: Colors.white,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // TOP BAR CONTENT
// //           Row(
// //             children: [
// //               Image.asset('assets/logo.png', height: 40),
// //               const SizedBox(width: 16),
// //               const Text('Explore', style: TextStyle(fontSize: 16)),
// //               const Spacer(),
// //               const Icon(Icons.search),
// //               const SizedBox(width: 16),
// //               GestureDetector(
// //                 onTap: _toggleMenu,
// //                 child: Icon(_isExpanded ? Icons.close : Icons.menu),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),

// //           // EXPANDED MENU SECTION
// //           if (_isExpanded)
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: const [
// //                   Text('Home'),
// //                   SizedBox(height: 8),
// //                   Text('About'),
// //                   SizedBox(height: 8),
// //                   Text('Services'),
// //                   SizedBox(height: 8),
// //                   Text('Contact'),
// //                 ],
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // dependencies:
// //   marquee: ^2.2.3

// // import 'package:marquee/marquee.dart';

// // SizedBox(
// //   height: 50,
// //   child: Marquee(
// //     text: '🔥 This is an infinitely scrolling text 🔥   ',
// //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //     scrollAxis: Axis.horizontal,
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     blankSpace: 60.0,
// //     velocity: 50.0,
// //     pauseAfterRound: Duration(seconds: 0),
// //     startPadding: 10.0,
// //     accelerationDuration: Duration(seconds: 1),
// //     accelerationCurve: Curves.linear,
// //     decelerationDuration: Duration(milliseconds: 500),
// //     decelerationCurve: Curves.easeOut,
// //   ),
// // ),

// // final class HomeSuccess extends HomeState {
// //   const HomeSuccess(this.successMessage, {this.isExpanded = false});

// //   final String successMessage;
// //   final bool isExpanded;

// //   HomeSuccess copyWith({String? successMessage, bool? isExpanded}) {
// //     return HomeSuccess(
// //       successMessage ?? this.successMessage,
// //       isExpanded: isExpanded ?? this.isExpanded,
// //     );
// //   }

// //   @override
// //   List<Object> get props => [successMessage, isExpanded];
// // }

// // void toggleExpand() {
// //   final currentState = state;

// //   if (currentState is HomeSuccess) {
// //     emit(currentState.copyWith(isExpanded: !currentState.isExpanded));
// //   }
// // }

// // final isExpanded = state is HomeSuccess ? state.isExpanded : false;

// // AnimatedContainer(
// //   duration: Duration(milliseconds: 300),
// //   height: isExpanded ? 300 : 100,
// //   // your child here
// // );

// // BlocBuilder<HomeCubit, HomeState>(
// //   builder: (context, state) {
// //     double appBarHeight = 150;
// //     if (state is HomeSuccess && state.isExpanded) {
// //       appBarHeight = 300;
// //     }

// //     return CustomScrollView(
// //       slivers: [
// //         SliverAppBar(
// //           expandedHeight: appBarHeight,
// //           pinned: true,
// //           flexibleSpace: FlexibleSpaceBar(
// //             title: Text('Dynamic AppBar'),
// //             background: Container(color: Colors.blue),
// //           ),
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.expand),
// //               onPressed: () {
// //                 context.read<HomeCubit>().toggleExpanded();
// //               },
// //             ),
// //           ],
// //         ),
// //         SliverList(
// //           delegate: SliverChildBuilderDelegate(
// //             (context, index) => ListTile(title: Text('Item #$index')),
// //             childCount: 30,
// //           ),
// //         ),
// //       ],
// //     );
// //   },
// // );

// // SliverAppBar(
// //   expandedHeight: isExpanded ? 300.0 : 120.0, // Expand based on Cubit state
// //   pinned: true,
// //   flexibleSpace: FlexibleSpaceBar(
// //     background: Container(
// //       padding: EdgeInsets.all(16),
// //       alignment: Alignment.bottomLeft,
// //       child: SafeArea(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 20)),
// //             if (isExpanded) ...[
// //               SizedBox(height: 10),
// //               Text("Menu Item 1", style: TextStyle(color: Colors.white)),
// //               Text("Menu Item 2", style: TextStyle(color: Colors.white)),
// //               // Add more items here
// //             ],
// //           ],
// //         ),
// //       ),
// //     ),
// //   ),
// //   actions: [
// //     IconButton(
// //       icon: Icon(Icons.menu),
// //       onPressed: () => context.read<HomeCubit>().toggleExpanded(), // Toggles the expanded state
// //     ),
// //   ],
// // ),

// // class OverlayMenuExample extends StatefulWidget {
// //   @override
// //   _OverlayMenuExampleState createState() => _OverlayMenuExampleState();
// // }

// // class _OverlayMenuExampleState extends State<OverlayMenuExample> {
// //   bool showMenu = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           // Main content
// //           Column(
// //             children: [
// //               Container(
// //                 height: 60,
// //                 color: Colors.blue,
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Padding(
// //                       padding: EdgeInsets.all(16),
// //                       child: Text("Home", style: TextStyle(color: Colors.white)),
// //                     ),
// //                     IconButton(
// //                       icon: Icon(Icons.menu, color: Colors.white),
// //                       onPressed: () {
// //                         setState(() {
// //                           showMenu = !showMenu;
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Expanded(
// //                 child: Center(child: Text("Main Content Area")),
// //               ),
// //             ],
// //           ),

// //           // Dropdown overlay
// //           Positioned(
// //             top: 60, // position right below the top bar
// //             right: 0,
// //             left: 0,
// //             child: AnimatedContainer(
// //               duration: Duration(milliseconds: 300),
// //               height: showMenu ? 150 : 0,
// //               curve: Curves.easeInOut,
// //               color: Colors.white,
// //               child: showMenu
// //                   ? Column(
// //                       children: [
// //                         ListTile(title: Text("Item 1")),
// //                         ListTile(title: Text("Item 2")),
// //                         ListTile(title: Text("Item 3")),
// //                       ],
// //                     )
// //                   : SizedBox.shrink(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // <activity android:name=".MainActivity" ...>
// //   <intent-filter android:label="flutter_web_auth">
// //     <action android:name="android.intent.action.VIEW"/>
// //     <category android:name="android.intent.category.DEFAULT"/>
// //     <category android:name="android.intent.category.BROWSABLE"/>
// //     <data android:scheme="com.template.app" android:host="auth-callback"/>
// //   </intent-filter>
// // </activity>

// // <key>CFBundleURLTypes</key>
// // <array>
// //   <dict>
// //     <key>CFBundleURLSchemes</key>
// //     <array>
// //       <string>com.template.app</string>
// //     </array>
// //   </dict>
// // </array>

// // import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // Future<void> initiateGoogleSignIn() async {
// //   try {
// //     // Step 1: Get the Google sign-in URL from your backend
// //     final redirectUri = 'com.template.app:/auth-callback';
// //     final response = await http.get(
// //       Uri.parse('https://mev-tech-api.onrender.com/get-google-auth-url?redirectUri=$redirectUri'),
// //     );

// //     final body = json.decode(response.body);
// //     final url = body['Data']['url'];

// //     // Step 2: Open the Google login page in a browser and wait for redirect
// //     final result = await FlutterWebAuth2.authenticate(
// //       url: url,
// //       callbackUrlScheme: 'com.template.app',
// //     );

// //     // Step 3: Extract code/token from redirect
// //     final code = Uri.parse(result).queryParameters['code'];

// //     // Step 4: Send the code to your backend to complete login
// //     final loginResponse = await http.post(
// //       Uri.parse('https://mev-tech-api.onrender.com/signin-with-google'),
// //       body: {
// //         'code': code,
// //         'redirectUri': redirectUri,
// //       },
// //     );

// //     final loginBody = json.decode(loginResponse.body);
// //     print('Login success: ${loginBody}');
// //   } catch (e) {
// //     print('Google sign-in failed: $e');
// //   }
// // }

// const String currentFlavor = String.fromEnvironment('FLAVOR');

// String getRedirectUri() {
//   switch (currentFlavor) {
//     case 'production':
//       return 'dev.adryanev.template:/auth-callback';
//     case 'staging':
//       return 'dev.adryanev.template.stg:/auth-callback';
//     case 'development':
//       return 'dev.adryanev.template.dev:/auth-callback';
//     default:
//       throw Exception('Unknown or missing FLAVOR');
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // // Cubit States
// // abstract class VideoPlayerState {}

// // class VideoPlayerInitial extends VideoPlayerState {}

// // class VideoPlayerLoading extends VideoPlayerState {}

// // class VideoPlayerLoaded extends VideoPlayerState {
// //   final YoutubePlayerController controller;

// //   VideoPlayerLoaded(this.controller);
// // }

// // class VideoPlayerError extends VideoPlayerState {
// //   final String message;

// //   VideoPlayerError(this.message);
// // }

// // // Video Player Cubit
// // class VideoPlayerCubit extends Cubit<VideoPlayerState> {
// //   YoutubePlayerController? _controller;

// //   VideoPlayerCubit() : super(VideoPlayerInitial());

// //   Future<void> loadVideo() async {
// //     emit(VideoPlayerLoading());
// //     try {
// //       String youtubeUrl = await fetchYouTubeLink();
// //       String videoId = getYouTubeVideoId(youtubeUrl);

// //       if (videoId.isNotEmpty) {
// //         if (_controller == null) {
// //           _controller = YoutubePlayerController.fromVideoId(
// //             videoId: videoId,
// //             autoPlay: false,
// //             params: const YoutubePlayerParams(
// //               showControls: true,
// //               showFullscreenButton: true,
// //             ),
// //           )..onInit = () {
// //               print('YouTube player initialized');
// //             };
// //         } else {
// //           _controller?.cueVideoById(videoId: videoId);
// //         }
// //         emit(VideoPlayerLoaded(_controller!));
// //       } else {
// //         emit(VideoPlayerError('Invalid YouTube URL'));
// //       }
// //     } catch (e) {
// //       emit(VideoPlayerError('Error loading video: $e'));
// //     }
// //   }

// //   Future<void> changeVideo(String youtubeUrl) async {
// //     try {
// //       emit(VideoPlayerLoading());
// //       String videoId = getYouTubeVideoId(youtubeUrl);

// //       if (videoId.isNotEmpty) {
// //         _controller?.cueVideoById(videoId: videoId);
// //         emit(VideoPlayerLoaded(_controller!));
// //       } else {
// //         emit(VideoPlayerError('Invalid YouTube URL'));
// //       }
// //     } catch (e) {
// //       emit(VideoPlayerError('Error changing video: $e'));
// //     }
// //   }

// //   Future<String> fetchYouTubeLink() async {
// //     // Replace with your actual API call
// //     await Future.delayed(Duration(seconds: 2));
// //     return 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
// //   }

// //   String getYouTubeVideoId(String url) {
// //     final uri = Uri.parse(url);
// //     if (uri.host.contains('youtube.com')) {
// //       return uri.queryParameters['v'] ?? '';
// //     } else if (uri.host.contains('youtu.be')) {
// //       return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
// //     }
// //     return '';
// //   }

// //   @override
// //   Future<void> close() {
// //     _controller?.close();
// //     _controller = null;
// //     return super.close();
// //   }
// // }

// // // UI
// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: BlocProvider(
// //         create: (context) => VideoPlayerCubit()..loadVideo(),
// //         child: VideoPlayerScreen(),
// //       ),
// //     );
// //   }
// // }

// // class VideoPlayerScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('YouTube Video Player')),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: Center(
// //               child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
// //                 builder: (context, state) {
// //                   if (state is VideoPlayerLoading) {
// //                     return CircularProgressIndicator();
// //                   } else if (state is VideoPlayerError) {
// //                     return Text(
// //                       state.message,
// //                       style: TextStyle(color: Colors.red),
// //                     );
// //                   } else if (state is VideoPlayerLoaded) {
// //                     return YoutubePlayer(
// //                       controller: state.controller,
// //                       aspectRatio: 16 / 9,
// //                     );
// //                   }
// //                   return Text('No video available');
// //                 },
// //               ),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               context.read<VideoPlayerCubit>().changeVideo(
// //                   'https://www.youtube.com/watch?v=NEW_VIDEO_ID');
// //             },
// //             child: Text('Change Video'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// 1. Pass currentDepth Parameter:

// // In ExpandableCommentTreeItem.dart

// class ExpandableCommentTreeItem extends StatefulWidget {
//   final MyComment rootComment;
//   final bool isNestedChild;
//   final int currentDepth; // <--- NEW: current recursion depth

//   const ExpandableCommentTreeItem({
//     Key? key,
//     required this.rootComment,
//     this.isNestedChild = false,
//     this.currentDepth = 0, // <--- Default depth for top-level comments
//   }) : super(key: key);

//   // ... rest of the class
// }

// // In MyCommentSection's ListView.builder (or wherever you initialize top-level comments):
// // Ensure you pass currentDepth: 0
// itemBuilder: (context, index) {
//   final rootComment = allRootComments[index];
//   return ExpandableCommentTreeItem(
//     rootComment: rootComment,
//     currentDepth: 0, // Start depth at 0 for top-level comments
//   );
// },

// 2. Modify contentChild to Handle Max Depth:

// // Inside _ExpandableCommentTreeItemState class's build method:

// // ... (other parts of the build method)

// contentChild: (context, node) {
//   if (node is ViewMoreRepliesNode) {
//     // ... (existing ViewMoreRepliesNode rendering logic)
//   } else if (node is RegularCommentNode) {
//     final comment = node.comment;
//     final bool hasNestedReplies = comment.replies.isNotEmpty;

//     // Define the maximum depth before offering to view in a new context
//     // This is the depth at which the comment content will start to get too small.
//     final int maxDisplayDepthBeforeNewThread = 4; // Adjust this value as needed

//     // Check if we are too deep AND this comment still has replies
//     if (widget.currentDepth >= maxDisplayDepthBeforeNewThread && hasNestedReplies) {
//       // If true, we render this comment's basic content + a "View Thread" button
//       // instead of recursively rendering another full ExpandableCommentTreeItem.
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(comment.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
//           Text(comment.content, style: const TextStyle(fontSize: 13)),
//           Row(
//             children: [
//               Text(formatTimeAgo(comment.timestamp), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   _showReplyBottomSheet(context, comment.id, comment.content);
//                 },
//                 child: const Text('Reply', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
//               ),
//               const SizedBox(width: 8),
//               // --- "View Thread" button ---
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to a new screen/modal that displays this 'comment'
//                   // as a new root, effectively resetting its indentation.
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => Scaffold(
//                         appBar: AppBar(title: const Text('Thread')),
//                         // Pass the current comment as the new root for the thread view
//                         body: ExpandableCommentTreeItem(
//                           rootComment: comment,
//                           currentDepth: 0, // Reset depth for the new thread view
//                           isNestedChild: false, // It's the new root on this screen
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'View thread (${comment.replies.length} replies)',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.purple, // Use a distinct color
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//     // If it's not too deep, or it's a leaf node (no further replies), render it normally:
//     else if (hasNestedReplies) {
//       // Normal recursive rendering for parents within the maxDisplayDepth
//       return ExpandableCommentTreeItem(
//         rootComment: comment,
//         isNestedChild: true,
//         currentDepth: widget.currentDepth + 1, // Increment depth for the recursive call
//       );
//     } else {
//       // Leaf comment content (no further replies)
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             comment.author,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//           ),
//           Text(comment.content, style: const TextStyle(fontSize: 13)),
//           Row(
//             children: [
//               Text(
//                 formatTimeAgo(comment.timestamp),
//                 style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   _showReplyBottomSheet(context, comment.id, comment.content);
//                 },
//                 child: const Text(
//                   'Reply',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//   }
//   return const SizedBox.shrink(); // Fallback
// },

// testing

  // Future<void> registerUser() async {
  //   final jsonData = RegisterRequest(
  //     username: txtUsername.text,
  //     firstName: txtFirstName.text,
  //     lastName: txtLastName.text,
  //     email: txtEmail.text,
  //     phoneNumber: txtPhoneNumber.text,
  //     password: txtPassword.text,
  //     confirmPassword: txtConfirmPassword.text,
  //   );

  //   try {
  //     emit(const AuthLoading(AuthActionType.register));

  //     final result = await Future.delayed(const Duration(seconds: 2), () {
  //       return 'Register succesful';
  //     });

  //     emit(AuthRegisterSuccess(result));
  //     // await localStorage.clearUserData();

  //     userEmail = txtEmail.text;
  //   } catch (e) {
  //     emit(AuthFailure(e.toString(), actionType: AuthActionType.register));
  //   }
  // }

  // Future<void> sendEmailConfirmToken() async {
  //   final jsonData = <String, dynamic>{
  //     'emailAddress': userEmail,
  //     'title': 'USER SIGNUP VERICATION',
  //   };
  //   if (state is! AuthRegisterSuccess) return;
  //   final current = state as AuthRegisterSuccess;
  //   try {
  //     emit(current.copyWith(sendStatus: const RequestState.loading()));
  //     await Future.delayed(const Duration(seconds: 3), () {});

  //     final result = 'send succesful';

  //     emit(current.copyWith(
  //       sendStatus: const RequestState.success(),
  //       message: result,
  //     ));
  //   } catch (e) {
  //     emit(current.copyWith(
  //       sendStatus: RequestState.failure(e.toString()),
  //     ));
  //   }
  // }

  // Future<void> verifyEmailConfirmToken() async {
  //   final jsonData = <String, dynamic>{
  //     'tk': txtToken.text,
  //     'reference': userEmail,
  //   };
  //   if (state is! AuthRegisterSuccess) return;
  //   final current = state as AuthRegisterSuccess;
  //   try {
  //     emit(current.copyWith(verifyStatus: const RequestState.loading()));

  //     final result = await Future.delayed(const Duration(seconds: 2), () {
  //       return 'verify succesful';
  //     });

  //     // final wrong = jsonData['wrong'];
  //     // final dd = int.parse(wrong.toString());
  //     // log(dd.toString());

  //     emit(current.copyWith(
  //       verifyStatus: const RequestState.success(),
  //       message: result,
  //     ));
  //   } catch (e) {
  //     emit(current.copyWith(
  //       verifyStatus: RequestState.failure(e.toString()),
  //     ));
  //   }
  // }
  // end of test

  // final HubConnection? _chatHubConnection;

  // // Use a StreamController to broadcast incoming events
  // final _messageController = StreamController<ChatMessageModel>.broadcast();
  // Stream<ChatMessageModel> get incomingMessages => _messageController.stream;

  // void _registerListeners() {
  //   _chatHubConnection?.on('ReceiveMessage', (data) {
  //     if (data != null) {
  //       // final message = ChatMessageModel.fromJson(data);
  //       // _messageController.sink.add(message);
  //       log(data.toString());
  //     }
  //   });

  //   // ... all other .on() handlers go here
  // }

  // // Public method to send a message
  // Future<void> sendMessage(String text) {
  //   return _chatHubConnection!.invoke('SendMessage', args: [text]);
  // }

//   class ChatPageCubit extends Cubit<ChatPageState> {
//   final ChatDataCubit _dataCubit;
  
//   // Assuming the channelId (the room you are viewing) is passed into the Cubit's constructor
//   ChatPageCubit(this._dataCubit, String channelId) 
//     : 
//     // STEP 1: INITIALIZATION (Immediate Data)
//     // Find the single active room from the global state immediately.
//     super(ChatPageState.initial(
//         // Use .state to access the current value right now!
//         activeRoom: _dataCubit.state.currentRooms.firstWhereOrNull(
//             (r) => r.id == channelId
//         )
//     )) 
//   {
//     // STEP 2: SUBSCRIPTION (Future Reactive Data)
//     _dataCubit.stream.listen((globalState) {
//       // Find the single room again whenever the global list changes
//       final updatedRoom = globalState.currentRooms.firstWhereOrNull(
//           (r) => r.id == channelId
//       );
      
//       // If the data is found or changed, emit a new state for the page.
//       if (updatedRoom != state.activeRoom) {
//           emit(state.copyWith(activeRoom: updatedRoom));
//       }
//     });
//   }
//   // ...
// }

// rooms
// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": [
//     {
//       "name": "💬 dabirideji ↔ kunle7",
//       "description": "",
//       "createdBy": "fcf1a72e-22e5-488c-2ae5-08de127d127a",
//       "members": [],
//       "settings": {
//         "memberCount": 2,
//         "otherRoomMembers": [
//           {
//             "userId": "fcf1a72e-22e5-488c-2ae5-08de127d127a",
//             "username": "dabirideji",
//             "joinedAt": "2025-11-01T10:38:34.6081826",
//             "role": 0,
//             "isMuted": false,
//             "lastActiveAt": null,
//             "firstName": "AYODEJI",
//             "lastName": "DABIRI",
//             "profilePictureUrl": null
//           }
//         ],
//         "mostRecentMessage": {
//           "roomId": "dm_-1947229616_275193331",
//           "userId": "fcf1a72e-22e5-488c-2ae5-08de127d127a",
//           "username": "dabirideji",
//           "content": "hi",
//           "type": "Text",
//           "timestamp": "2025-11-01T11:35:51.6900586",
//           "metadata": {},
//           "isEdited": false,
//           "replyToMessageId": null,
//           "replyToMessage": null,
//           "mentions": [],
//           "mediaId": null,
//           "readStatuses": [],
//           "media": null,
//           "editedAt": null,
//           "id": "3f33d08a-019a-0000-0100-05000d0daff1",
//           "createdAt": "2025-11-01T11:35:51.6900554",
//           "updatedAt": "2025-11-01T11:35:51.6900554",
//           "rowVersion": "AAAAAAAAaNs=",
//           "createdBy": null,
//           "updatedBy": null,
//           "isDeleted": false,
//           "deletedAt": null,
//           "deletedBy": null,
//           "isArchived": false,
//           "archivedAt": null,
//           "archivedBy": null,
//           "physicallyArchivedAt": null,
//           "archiveReason": null
//         },
//         "unreadRoomMessagesCount": 1
//       },
//       "isPrivate": true,
//       "password": null,
//       "lastMessageAt": null,
//       "maxMembers": 1000,
//       "id": "dm_-1947229616_275193331",
//       "createdAt": "2025-11-01T10:38:34.6079316",
//       "updatedAt": "2025-11-01T10:38:34.607885",
//       "rowVersion": "AAAAAAAAaH8=",
//       "updatedBy": null,
//       "isDeleted": false,
//       "deletedAt": null,
//       "deletedBy": null,
//       "isArchived": false,
//       "archivedAt": null,
//       "archivedBy": null,
//       "physicallyArchivedAt": null,
//       "archiveReason": null
//     },
//     ///////
//     {
//       "name": "👥 Elite Club",
//       "description": "",
//       "createdBy": "a1d238c7-286f-4dfe-3caa-08de13e02cfa",
//       "members": [],
//       "settings": {
//         "memberCount": 2,
//         "otherRoomMembers": [
//           {
//             "userId": "a1d238c7-286f-4dfe-3caa-08de13e02cfa",
//             "username": "ade77",
//             "joinedAt": "2025-10-26T13:30:00.2779325",
//             "role": 0,
//             "isMuted": false,
//             "lastActiveAt": null,
//             "firstName": "ade",
//             "lastName": "kola",
//             "profilePictureUrl": null
//           }
//         ],
//         "mostRecentMessage": null,
//         "unreadRoomMessagesCount": 0
//       },
//       "isPrivate": false,
//       "password": null,
//       "lastMessageAt": null,
//       "maxMembers": 1000,
//       "id": "group_elite_club_638970821999777481",
//       "createdAt": "2025-10-26T13:30:00.2776357",
//       "updatedAt": "2025-10-26T13:30:00.27759",
//       "rowVersion": "AAAAAAAAZzo=",
//       "updatedBy": null,
//       "isDeleted": false,
//       "deletedAt": null,
//       "deletedBy": null,
//       "isArchived": false,
//       "archivedAt": null,
//       "archivedBy": null,
//       "physicallyArchivedAt": null,
//       "archiveReason": null
//     }
//   ]
// }

