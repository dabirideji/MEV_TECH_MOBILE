import 'package:flutter/material.dart';
import 'package:template/core/network/signalr_service.dart';

class MockTestPage extends StatefulWidget {
  const MockTestPage({super.key});

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final SignalRService _signalRService = SignalRService();
  final String targetUserId = '70c4e4f6-cba1-4635-5e92-08ddb88cec3b';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _signalRService.initSignalR();
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

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final SignalRService _signalRService = SignalRService();
//   final String targetUserId = '70c4e4f6-cba1-4635-5e92-08ddb88cec3b';

//   @override
//   void initState() {
//     super.initState();
//     // Connect to SignalR when the widget is first created
//     _signalRService.initSignalR();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter SignalR'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Example of sending a message
//             _signalRService.sendChatMessage(
//               targetUserId,
//               'Hello from Austinero, this is a test message to kunle! 👋',
//             );
//           },
//           child: const Text('Send Test Message'),
//         ),
//       ),
//     );
//   }
// }





// class CourseCubit extends Cubit<CourseState> {
//   final GenericRepository<Course> repository;

//   CourseCubit(this.repository) : super(CourseState());

//   Future<void> loadCourses() async {
//     emit(CourseState(isLoading: true));
//     try {
//       final data = await repository.getAll();
//       emit(CourseState(courses: data));
//     } catch (e) {
//       emit(CourseState(error: e.toString()));
//     }
//   }

//   Future<void> createCourse(String title) async {
//     try {
//       final newCourse = Course(title: title);
//       await repository.create(newCourse.toJson());
//       await loadCourses(); // reload after creating
//     } catch (e) {
//       emit(CourseState(error: e.toString()));
//     }
//   }

//   Future<void> deleteCourse(String id) async {
//     try {
//       await repository.delete(id);
//       await loadCourses(); // reload after delete
//     } catch (e) {
//       emit(CourseState(error: e.toString()));
//     }
//   }
// }

// void main() {
//   final courseRepository = GenericRepository<Course>(
//     client: http.Client(),
//     baseUrl: 'https://yourapi.com/api/courses',
//     fromJson: (json) => Course.fromJson(json),
//   );

//   runApp(MyApp(courseRepository));
// }

// class MyApp extends StatelessWidget {
//   final GenericRepository<Course> courseRepository;

//   const MyApp(this.courseRepository, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider(
//         create: (_) => CourseCubit(courseRepository)..loadCourses(),
//         child: CoursePage(),
//       ),
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

// class PaginatedResult<T> {
//   final int pageNumber;
//   final int pageSize;
//   final int totalRecords;
//   final int totalPages;
//   final List<T> result;

//   PaginatedResult({
//     required this.pageNumber,
//     required this.pageSize,
//     required this.totalRecords,
//     required this.totalPages,
//     required this.result,
//   });

//   factory PaginatedResult.fromJson(
//     Map<String, dynamic> json,
//     T Function(Map<String, dynamic>) fromJson,
//   ) {
//     return PaginatedResult(
//       pageNumber: json['pageNumber'],
//       pageSize: json['pageSize'],
//       totalRecords: json['totalRecords'],
//       totalPages: json['totalPages'],
//       result: (json['result'] as List)
//           .map((item) => fromJson(item))
//           .toList(),
//     );
//   }
// }


// Future<PaginatedResult<T>> getPaginated({
//     required int page,
//     required int pageSize,
//     Map<String, String>? extraParams,
//   }) async {
//     final allParams = {
//       'pageNumber': page.toString(),
//       'pageSize': pageSize.toString(),
//       ...?extraParams,
//     };
//     final uri = Uri.parse('$baseUrl/paginate').replace(queryParameters: allParams);
//     final response = await client.get(uri);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonMap = json.decode(response.body);
//       return PaginatedResult<T>.fromJson(jsonMap, fromJson);
//     } else {
//       throw Exception('Failed to fetch paginated data');
//     }
//   }

// this is the part i really need as methods apart from the base class GenericRepository<T>

// class CourseRepository {
//   final http.Client client;

//   CourseRepository(this.client);

//   Future<List<T>> fetchCourseData<T>({
//     required String endpoint,
//     Map<String, String>? queryParams,
//     required T Function(Map<String, dynamic>) fromJson,
//   }) async {
//     final repo = GenericRepository<T>(
//       client: client,
//       baseUrl: endpoint,
//       fromJson: fromJson,
//     );

//     return await repo.getAll(queryParams: queryParams);
//   }
// }

// in your cubit, now do this

// final comments = await courseRepository.fetchCourseData<CourseComment>(
//   endpoint: 'https://yourapi.com/api/CourseComment',
//   queryParams: {'courseId': courseId.toString()},
//   fromJson: (json) => CourseComment.fromJson(json),
// );

// final notes = await courseRepository.fetchCourseData<CourseNote>(
//   endpoint: 'https://yourapi.com/api/CourseNote',
//   fromJson: (json) => CourseNote.fromJson(json),
// );


