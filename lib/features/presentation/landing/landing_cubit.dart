import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/features/presentation/widgets/course.dart';

part 'landing_state.dart';

@injectable
class LandingCubit extends Cubit<LandingState> {
  LandingCubit() : super(LandingInitial.initial()) {
    onCreate();
  }

  // MEV CIQ AU

  final List<CarouselSliderController> carouselController =
      List.generate(5, (index) => CarouselSliderController());

  List<Course> myList = [];
  List<Course> myList2 = [];
  List<Course> combineList = [];
  List<Course> otherCourses = [];
  List<Course> popularBasicCourses = [];
  List<Course> execDiplomaCourses = [];

  int currentIndex = 0;

  void toggleMenu() {
    if (state is LandingSuccess) {
      final current = state as LandingSuccess;

      emit(
        current.copyWith(isMenuExpanded: !current.isMenuExpanded),
      );
    }
  }

  void resetMenu() {
    if (state is LandingSuccess) {
      final current = state as LandingSuccess;
      emit(current.copyWith(isMenuExpanded: false));
    }
  }

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

  Future<void> onCreate() async {
    await fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      emit(LandingLoading());
      await Future.delayed(Duration.zero, () {
        myList = [
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
        myList2 = [
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

        combineList.addAll(myList + myList2);

        // otherCourses

        otherCourses = [
          const Course(
            id: 'MEV',
            imagePath: 'assets/images/E-D- Data Analytics.jpg',
            title: 'Executive Diploma in Data Analytics',
            durationType: 'Flexible Duration',
            duration: '2-3 Weeks Learning',
          ),
          const Course(
            id: 'AU',
            imagePath: 'assets/images/Ess-Data-Vis- Ms Excel.jpg',
            title: 'Essentials of Data Visualization using MS Excel',
            durationType: 'Flexible Duration',
            duration: '6-9 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Essential-Ms Excel Form&Func.jpg',
            title: 'Essentials of MS Excel - Formulas and Functions',
            durationType: 'Flexible Duration',
            duration: '6-9 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basic Microsoft Power-Bi.jpg',
            title: 'Basics of Microsoft Power BI',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Machine Learn Algo.jpg',
            title: 'Basics of Machine Learning Algorithms',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'MEV',
            imagePath: 'assets/images/Master ChatGPT.jpg',
            title: 'Master ChatGPT',
            durationType: 'Flexible Duration',
            duration: '1 week Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Data Science.jpg',
            title: 'Basics of Data Science',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'MEV',
            imagePath: 'assets/images/Diploma in Power BI.jpg',
            title: 'Diploma in Power BI',
            durationType: 'Flexible Duration',
            duration: '1-2 weeks Learning',
          ),
          const Course(
            id: 'MEV',
            imagePath: 'assets/images/Diploma-SQL-Begin-to-adv-lev.jpg',
            title: 'Diploma in SQL: Beginner to Advanced Levels',
            durationType: 'Flexible Duration',
            duration: '1-2 weeks Learning',
          ),
          const Course(
            id: 'AU',
            imagePath: 'assets/images/MBA Essentials with Machine Learning.jpg',
            title: 'MBA Essentials with Machine Learning',
            durationType: 'Flexible Duration',
            duration: '4-5 weeks Learning',
          ),
        ];

        // Popular Courses

        popularBasicCourses = [
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics-of-Python.jpg',
            title: 'Basics of Python',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Digital Marketing.jpg',
            title: 'Basics of Digital Marketing',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics-Human-Resource Mgt.jpg',
            title: 'Basics in Human Resource Management',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basic Microsoft Power-Bi.jpg',
            title: 'Basics of Microsoft Power BI',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Machine Learn Algo.jpg',
            title: 'Basics of Machine Learning Algorithms',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Data Science.jpg',
            title: 'Basics of Data Science',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Build & Const Works.jpg',
            title: 'Basics of Buildings and Construction Works',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Fundamentals-of-English-Grammar.jpg',
            title: 'Fundamentals of English Grammar',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath: 'assets/images/Basics of Accounting.jpg',
            title: 'Basics of Accounting',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
          const Course(
            id: 'CIQ',
            imagePath:
                'assets/images/Basics of Excel Spreadsheet & Workbook.jpg',
            title: 'Basics of Excel Spreadsheet & Workbook',
            durationType: 'Flexible Duration',
            duration: '4-6 Hours Learning',
          ),
        ];

        // Executive Diploma Courses

        execDiplomaCourses = [
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

        emit(
          LandingSuccess(
            '',
            courses: myList,
            courses2: myList2,
            combineCourse: combineList,
          ),
        );
      });
    } catch (e) {
      emit(LandingFailure(e.toString()));
    }
  }
}
