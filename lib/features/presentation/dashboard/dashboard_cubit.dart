import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/data/odata_query_builder.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/data/repository/course_repository.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/presentation/widgets/course.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.courseRepository) : super(const DashboardSuccess()) {
    loadDashboardData();
  }

  final picker = ImagePicker();
  final CourseRepository courseRepository;

  YoutubePlayerController? _controller;

  List<Map<String, dynamic>> myList = [];

  TextEditingController emailToken = TextEditingController();

  final List<CarouselSliderController> carouselController =
      List.generate(5, (index) => CarouselSliderController());

  List<Course> popularCourses = [];
  List<Course> trendingCourses = [];
  List<Course> otherCourses = [];

  void goToNextPage(int index) {
    carouselController[index].nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void goToPreviousPage(int index) {
    carouselController[index].previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  int _currentSearchId = 0;

  Future<void> loadDashboardData() async {
    emit((state as DashboardSuccess).copyWith(
      courseStatus: LoadStatus.loading,
      categoryStatus: LoadStatus.loading,
    ));

    // Both run at the same time
    unawaited(loadCourses(showLoadingStatus: false));
    unawaited(loadCategories(showLoadingStatus: false));
  }

  Future<void> loadCourses({bool showLoadingStatus = true}) async {
    try {
      if (showLoadingStatus) {
        if (!isClosed) {
          emit((state as DashboardSuccess).copyWith(
            courseStatus: LoadStatus.loading,
          ));
        }
      }

      // await Future.delayed(const Duration(seconds: 2), () {});

      final result = await courseRepository.getCourses();
      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          courses: result,
          courseStatus: LoadStatus.success,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          courseStatus: LoadStatus.failure,
          courseError: e.toString(),
        ));
      }
    }
  }

  Future<void> loadCategories({bool showLoadingStatus = true}) async {
    try {
      if (showLoadingStatus) {
        if (!isClosed) {
          emit((state as DashboardSuccess).copyWith(
            categoryStatus: LoadStatus.loading,
          ));
        }
      }

      final result = await courseRepository.fetchAll<CourseCategoryModel>(
        endPoint: 'CourseCategory/GetAllAsQueryable',
        fromJson: CourseCategoryModel.fromJson,
      );

      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          categories: result,
          categoryStatus: LoadStatus.success,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          categoryStatus: LoadStatus.failure,
          categoryError: e.toString(),
        ));
      }
    }
  }

  Future<void> searchCourse(String searchText) async {
    _currentSearchId++;
    final searchId = _currentSearchId;
    try {
      const endPoint = 'Course/GetOData/odata';

      final queryBuilder =
          ODataQueryBuilder(baseUrl: '${ApiService.baseUrlAddress}/$endPoint');

      final uri = queryBuilder
          .filter(
              "contains(courseTitle, '$searchText') or contains(courseName, '$searchText')")
          .top(10)
          .build();

      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          searchStatus: LoadStatus.loading,
        ));
      }

      final result = await courseRepository.fetchOdata<CourseModel>(
        url: uri,
        fromJson: CourseModel.fromJson,
      );

      if (searchId == _currentSearchId) {
        if (!isClosed) {
          emit((state as DashboardSuccess).copyWith(
            searchStatus: LoadStatus.success,
            searchedCourses: result,
          ));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit((state as DashboardSuccess).copyWith(
          searchStatus: LoadStatus.failure,
          searchError: e.toString(),
        ));
      }
    }
  }

  void fetchCourses() {
    try {
      // emit(DashboardLoading());
      popularCourses = [
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/ED-Biz-Com.jpg',
          title: 'Executive Diploma in Business Communication',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/E-D-Proc-Contract-Mgt.jpg',
          title: 'Executive Diploma in Procurement & Contract Management',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/E-D- Data Analytics.jpg',
          title: 'Executive Diploma in Data Analytics',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/Dip-Business-Admin.jpg',
          title: 'Diploma in Business Administration',
          durationType: 'Flexible Duration',
          duration: '1-2 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/Dip- Healthcare Mgt.jpg',
          title: 'Diploma in Healthcare Management',
          durationType: 'Flexible Duration',
          duration: '1-2 Weeks Learning',
        ),
        const Course(
          id: 'CIQ',
          imagePath: 'assets/images/Mast Health & Safety mgt.jpg',
          title: 'Mastering Health and Safety Management',
          durationType: 'Flexible Duration',
          duration: '1 Weeks Learning',
        ),
        const Course(
          id: 'AU',
          imagePath: 'assets/images/Ess-Data-Vis- Ms Excel.jpg',
          title: 'Essentials of Data Visualization using MS Excel',
          durationType: 'Flexible Duration',
          duration: '6-9 Hours Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/Dip- Construction-Management.jpg',
          title: 'Diploma in Construction Management',
          durationType: 'Flexible Duration',
          duration: '1-2 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/Dip- Trans & Log mgt.jpg',
          title: 'Diploma in Transportation & Logistics Management',
          durationType: 'Flexible Duration',
          duration: '1-2 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/Dip- Environ-Health & Safety-Mgt.jpg',
          title: 'Diploma in Environment Health and Safety Management',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
      ];
      // second list
      trendingCourses = [
        const Course(
          id: 'CIQ',
          imagePath: 'assets/images/Basics-of-Data-Cleaning-card.jpg',
          title: 'Basics of Data Cleaning',
          durationType: 'Flexible Duration',
          duration: '4-6 Hours Learning',
        ),
        const Course(
          id: 'CIQ',
          imagePath: 'assets/images/Basics-of-Pandas-UK.jpg',
          title: 'Basics of Pandas',
          durationType: 'Flexible Duration',
          duration: '4-6 Hours Learning',
        ),
        const Course(
          id: 'AU',
          imagePath:
              'assets/images/Essentials-of-Data-Sourcing-Cleaning-card.jpg',
          title: 'Essentials of Data Sourcing & Cleaning',
          durationType: 'Flexible Duration',
          duration: '6-9 Hours Learning',
        ),
        const Course(
          id: 'AU',
          imagePath: 'assets/images/Data-visualization-seaborn-card.jpg',
          title: 'Data Visualization - Seaborn',
          durationType: 'Flexible Duration',
          duration: '6-9 Hours Learning',
        ),
        const Course(
          id: 'CIQ',
          imagePath: 'assets/images/Data-Visualization-Matplotlib-card.jpg',
          title: 'Data Visualization - Matplotlib',
          durationType: 'Flexible Duration',
          duration: '6-9 Hours Learning',
        ),
        const Course(
          id: 'CIQ',
          imagePath: 'assets/images/Data-Visualization-Pandas.jpg',
          title: 'Data Visualization - Pandas',
          durationType: 'Flexible Duration',
          duration: '6-9 Hours Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath:
              'assets/images/Diploma-in-Data-Pre-Processing-and-Exploratory-Analysis-card-1-.jpg',
          title: 'Diploma in Data Pre-Processing & Exploratory Analysis',
          durationType: 'Flexible Duration',
          duration: '1-2 Weeks Learning',
        ),
        const Course(
          id: 'AU',
          imagePath:
              'assets/images/Mastering-Exploratory-Data-Analysis-card-1-.jpg',
          title: 'Mastering Exploratory Data Analysis',
          durationType: 'Flexible Duration',
          duration: '1 WeekLearning',
        ),
      ];

      otherCourses = [
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/ED-Biz-Com.jpg',
          title: 'Executive Diploma in Business Communication',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/E-D-Proc-Contract-Mgt.jpg',
          title: 'Executive Diploma in Procurement & Contract Management',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath: 'assets/images/E-D- Data Analytics.jpg',
          title: 'Executive Diploma in Data Analytics',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
        const Course(
          id: 'MEV',
          imagePath:
              'assets/images/Exe Dip Supply Chain & Logistics in Global Context.jpg',
          title:
              'Executive Diploma in Supply Chain & Logistics in Global Context',
          durationType: 'Flexible Duration',
          duration: '2-3 Weeks Learning',
        ),
      ];
      // emit(
      //   DashboardSuccess(
      //     '',
      //     courses1: popularCourses,
      //     courses2: trendingCourses,
      //     courses3: otherCourses,
      //   ),
      // );
    } catch (e) {
      // emit(DashboardFailure(e.toString()));
    }
  }

  Future<String> fetchYouTubeLink() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    return 'https://www.youtube.com/watch?v=geR9PeCuHK4';
  }

  String getYouTubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  @override
  Future<void> close() {
    _controller?.close();
    _controller = null;
    return super.close();
  }
}
