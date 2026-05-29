import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/extensions/navigation_bar_extension.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/course/pages/course_page.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_page.dart';
import 'package:mevtech/features/presentation/favourite/favourite_page.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/pages/user_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.child, super.key});

  final Widget child;

  static final routeNames = [
    AppRouter.dashboard,
    AppRouter.course,
    AppRouter.quizMode,
    AppRouter.chat,
    AppRouter.user,
  ];

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final currentIndex = context.watch<HomeCubit>().state;
    final showBottomNavBar = context.shouldShowBottomNavBar;
    // final location = GoRouterState.of(context).fullPath;
    // final location = GoRouter.of(context).namedLocation(AppRouter.user);
    // final dashboardCubit = context.read<DashboardCubit>();

    // final iconList = <IconData>[
    //   Icons.home,
    //   Icons.menu_book,
    //   Icons.quiz,
    //   Icons.chat_rounded,
    //   Icons.person_2,
    // ];

    return BlocListener<HomeCubit, int>(
      listener: (context, index) {
        context.goNamed(routeNames[index]);
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (currentIndex == 0) {
            MevTechUtilities.showAnimatedAlert(
              context: context,
              title: 'Confirm Exit',
              message: 'Are you sure you want to exit the app?',
              // ignore: unnecessary_lambdas
              onConfirm: () {
                // Navigator.pop(context, true);
                SystemNavigator.pop();
              },
            );
          } else {
            homeCubit.navigateToPage(0);
          }
        },
        child: FScaffold(
          childPad: false,
          footer: showBottomNavBar
              ? FBottomNavigationBar(
                  index: currentIndex,
                  onChange: homeCubit.navigateToPage,
                  children: const [
                    FBottomNavigationBarItem(
                      icon: Icon(FIcons.house),
                      label: Text('Home'),
                    ),
                    FBottomNavigationBarItem(
                      icon: Icon(FIcons.graduationCap),
                      label: Text('Courses'),
                    ),
                    FBottomNavigationBarItem(
                      icon: Icon(FIcons.badgeQuestionMark),
                      label: Text('Quiz'),
                    ),
                    FBottomNavigationBarItem(
                      icon: Icon(FIcons.messageCircleMore),
                      label: Text('Chat'),
                    ),
                    FBottomNavigationBarItem(
                      icon: Icon(FIcons.user),
                      label: Text('Profile'),
                    ),
                  ],
                )
              : null,
          child: child,

          // bottomNavigationBar: showBottomNavBar
          //     ? AnimatedBottomNavigationBar.builder(
          //         backgroundColor: Colors.white70,
          //         borderColor: Colors.grey.shade300,
          //         borderWidth: 3.5,
          //         itemCount: iconList.length,
          //         tabBuilder: (index, isActive) {
          //           final color = isActive ? AppColor.primary : Colors.grey;
          //           final labels = <String>[
          //             'Home',
          //             'Courses',
          //             'Quiz',
          //             'Chat',
          //             'Profile',
          //           ];
          //           return Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Icon(iconList[index], size: 24, color: color),
          //               Text(
          //                 labels[index],
          //                 style: TextStyle(
          //                   color: color,
          //                   fontSize: 11,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //             ],
          //           );
          //         },
          //         activeIndex: currentIndex,
          //         gapLocation: GapLocation.none,
          //         // notchSmoothness: NotchSmoothness.softEdge,
          //         onTap: (index) {
          //           homeCubit.navigateToPage(index);
          //         },
          //       )
          //     : null,
        ),
      ),
    );
  }
}
