import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:template/core/utils/constants.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/auth/pages/login_entry_page.dart';
import 'package:template/features/auth/pages/login_page.dart';
import 'package:template/features/auth/pages/password_reset_token_page.dart';
import 'package:template/features/auth/pages/reset_password_page.dart';
import 'package:template/features/auth/pages/sign_up_page.dart';
import 'package:template/features/auth/pages/splash_page.dart';
import 'package:template/features/auth/pages/verify_password_reset_page.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/course/pages/course_content_page.dart';
import 'package:template/features/course/pages/course_detail_page.dart';
import 'package:template/features/course/pages/course_operation_page.dart';
import 'package:template/features/course/pages/course_page.dart';
import 'package:template/features/course/pages/create_course_page.dart';
import 'package:template/features/course/pages/edit_course_page.dart';
import 'package:template/features/home/home_page.dart';
import 'package:template/features/presentation/dashboard/dashboard_cours_category.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:template/features/presentation/dashboard/dashboard_page.dart';
import 'package:template/features/presentation/dashboard/search_course.dart';
import 'package:template/features/presentation/landing/landing_page.dart';
import 'package:template/features/presentation/pages/categories_page.dart';
import 'package:template/features/presentation/pages/category_view_more_page.dart';
import 'package:template/features/presentation/pages/course_category_settings.dart';
import 'package:template/features/presentation/pages/mock_test_page.dart';
import 'package:template/features/user/logic/user-cubit/user_cubit.dart';
import 'package:template/features/user/pages/change_password_page.dart';
import 'package:template/features/user/pages/edit_user_page.dart';
import 'package:template/features/user/pages/user_page.dart';
import 'package:template/features/user/pages/view_profile_page.dart';
import 'package:template/injector.dart';

class AppRouter extends Equatable {
  static const landing = 'landing';

  // auth related

  static const splashPage = 'splashPage';
  static const loginEntry = 'loginEntry';
  static const login = 'login';
  static const signUp = 'signUp';

  static const passResetToken = 'passResetToken';
  static const verifyPassToken = 'verifyPassToken';
  static const resetPass = 'resetPass';

  static const categories = 'categories';
  static const categoryViewMore = 'categoryViewMore';
  static const mockTest = 'mockTest';
  // static const home = 'home';
  //shell routes
  static const dashboard = 'dashboard';
  static const favourite = 'favourite';
  static const dashboardCoursCategory = 'dashboardCoursCategory';
  static const searchCourse = 'searchCourse';

  // user related
  static const user = 'user';
  static const viewProfile = 'viewProfile';
  static const editUser = 'editUser';
  static const changePassword = 'changePassword';

  // course related
  static const course = 'course';
  static const createCourse = 'createCourse';
  static const courseOperation = 'courseOperation';
  static const courseDetails = 'courseDetails';
  static const courseContent = 'courseContent';

  static const editCourse = 'editCourse';
  static const courseCategorySettings = 'courseCategorySettings';

  @override
  List<Object?> get props => [
        landing,
        loginEntry,
        login,
        signUp,
        course,
        createCourse,
        courseDetails,
        courseContent,
        editCourse,
        categories,
      ];
}

final publicRoutes = <String>[
  // '/loginEntry',
  // '/login',
  '/signUp',
  '/password-reset-token',
  '/password-reset-token/verify-password-token',
  '/password-reset-token/reset-password',
];

final appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode || kProfileMode,
  initialLocation: '/',
  redirect: (context, state) {
    final authCubit = context.read<AuthCubit>();
    final authState = authCubit.state;

    final isLoginPage = state.matchedLocation == '/login';
    final isSplashPage = state.matchedLocation == '/';
    final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);
    // final pagePath = state.fullPath;

    if ((authState is AuthLoading || authState is AuthInitial) &&
        !isLoginPage) {
      return isSplashPage ? null : '/';
    }

    if (authState is AuthUnAuthenticated) {
      return isGoingToPublicRoute ? null : '/login';
    }

    if (authState is AuthUnAuthenticated) {
      if (!isLoginPage && !isSplashPage) return '/login';
      return null;
    }

    if (authState is AuthLoginSuccess) {
      if (isLoginPage || isSplashPage) return '/dashboard';
      return null;
    }

    if (authState is AuthFailure) {
      // if (!isLoginPage && !isSplashPage) return '/loginEntry';
      return null;
    }

    if (authState is AuthLoginSuccess) {
      return isGoingToPublicRoute ? '/dashboard' : null;
    }

    return null;
  },
  refreshListenable: getIt<AuthCubit>(),
  routes: [
    GoRoute(
      path: '/',
      name: AppRouter.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/loginEntry',
      name: AppRouter.loginEntry,
      builder: (context, state) => const LoginEntryPage(),
    ),
    GoRoute(
      path: '/login',
      name: AppRouter.login,
      builder: (context, state) {
        final data = state.extra as String?;
        return LoginPage(userType: data ?? UserType.student);
      },
    ),
    GoRoute(
      path: '/signUp',
      name: AppRouter.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (context) => getIt<DashboardCubit>(),
          child: HomePage(child: child),
        );
      },
      routes: [
        // dashboard
        GoRoute(
          path: '/dashboard',
          name: AppRouter.dashboard,
          builder: (context, state) => const DashboardPage(),
          routes: [
            // dashboardCoursCategory

            GoRoute(
              path: 'dashboardCoursCategory',
              name: AppRouter.dashboardCoursCategory,
              builder: (context, state) {
                final data = state.extra as String?;
                if (data != null) {
                  return DashboardCoursCategory(category: data);
                } else {
                  return const Center(child: Text('Error Fetching Data'));
                }
              },
            ),
          ],
        ),

        GoRoute(
          path: '/searchcourse',
          name: AppRouter.searchCourse,
          builder: (context, state) => const SearchCourse(),
        ),

        // course
        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => getIt<CourseCubit>(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/course',
              name: AppRouter.course,
              builder: (context, state) => const CoursePage(),
              routes: [
                GoRoute(
                  path: 'course-details',
                  name: AppRouter.courseDetails,
                  builder: (context, state) {
                    final id = state.extra as String?;
                    if (id != null && id.isNotEmpty) {
                      return CourseDetailPage(courseId: id);
                    } else {
                      return const Center(
                        child: Text('Error Fetching Course Content'),
                      );
                    }
                  },
                ),
                GoRoute(
                  path: 'courses-operation',
                  name: AppRouter.courseOperation,
                  builder: (context, state) => const CourseOperationPage(),
                ),
                GoRoute(
                  path: 'create-courses',
                  name: AppRouter.createCourse,
                  builder: (context, state) => const CreateCoursePage(),
                ),
                GoRoute(
                  path: 'edit-course',
                  name: AppRouter.editCourse,
                  builder: (context, state) {
                    final id = state.extra as String?;
                    if (id != null && id.isNotEmpty) {
                      return EditCoursePage(courseId: id);
                    } else {
                      return const Center(
                        child: Text('Error Fetching Course'),
                      );
                    }
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/courseContent',
              name: AppRouter.courseContent,
              builder: (context, state) {
                final data = state.extra as String?;
                if (data != null) {
                  return CourseContentPage(courseId: data);
                } else {
                  return const Center(child: Text('Error Fetching Data'));
                }
              },
            ),
            GoRoute(
              path: '/categories',
              name: AppRouter.categories,
              builder: (context, state) => const CategoriesPage(),
            ),
            GoRoute(
              path: '/categoryViewMore',
              name: AppRouter.categoryViewMore,
              builder: (context, state) {
                final data = state.extra as String?;
                if (data != null) {
                  return CategoryViewMorePage(category: data);
                } else {
                  return const Center(child: Text('Error Fetching Data'));
                }
              },
            ),
            GoRoute(
              path: '/course-category-settings',
              name: AppRouter.courseCategorySettings,
              builder: (context, state) => const CourseCategorySettings(),
            ),
          ],
        ),

        GoRoute(
          path: '/mockTest',
          name: AppRouter.mockTest,
          builder: (context, state) {
            final data = state.extra as CourseModel?;
            // if (data != null) {
            //   return MockTestPage(courseModel: data);
            // } else {
            //   return const Center(child: Text('Error Fetching Data'));
            // }
            return const MockTestPage();
          },
        ),

        // Landing
        GoRoute(
          path: '/landing',
          name: AppRouter.landing,
          builder: (context, state) => const LandingPage(),
        ),
        // GoRoute(
        //   path: '/favourite',
        //   name: AppRouter.favourite,
        //   builder: (context, state) => const FavouritePage(),
        // ),

        // user
        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => getIt<UserCubit>(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/user',
              name: AppRouter.user,
              builder: (context, state) => const UserPage(),
              routes: [
                GoRoute(
                  path: 'view-profile',
                  name: AppRouter.viewProfile,
                  builder: (context, state) => const ViewProfilePage(),
                ),
                GoRoute(
                  path: 'edit-user',
                  name: AppRouter.editUser,
                  builder: (context, state) => const EditUserPage(),
                ),
                GoRoute(
                  path: 'change-password',
                  name: AppRouter.changePassword,
                  builder: (context, state) => const ChangePasswordPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/password-reset-token',
      name: AppRouter.passResetToken,
      builder: (context, state) => const PasswordResetTokenPage(),
      routes: [
        GoRoute(
          path: 'verify-password-token',
          name: AppRouter.verifyPassToken,
          builder: (context, state) => const VerifyPasswordResetPage(),
        ),
        GoRoute(
          path: 'reset-password',
          name: AppRouter.resetPass,
          builder: (context, state) => const ResetPasswordPage(),
        ),
      ],
    ),
  ],
);

//     redirect logic just provide this to redirect params

//     String? authRedirect(BuildContext context, GoRouterState state) {

//   final isLoggedIn = context.read<AuthCubit>().state;
//   final isLogin = state.matchedLocation == '/login';

//   if (!isLoggedIn && !isLogin) return '/login';
//   if (isLoggedIn && isLogin) return '/home';

//   return null;
// }

// String? authRedirect(BuildContext context, GoRouterState state) {
//   final authState = context.read<AuthCubit>().state;

//   final loggingIn = state.location == '/login';

//   if (authState is AuthAuthenticated && loggingIn) return '/dashboard';
//   if (authState is AuthUnauthenticated && !loggingIn) return '/login';

//   return null; // no redirect
// }

// final GoRouter _router = GoRouter(
//   initialLocation: '/',

//   routes: [
//     GoRoute(
//       path: '/',
//       name: 'splash',
//       builder: (context, state) => const SplashScreen(),
//     ),
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (context, state) => const LoginPage(),
//     ),
//     GoRoute(
//       path: '/dashboard',
//       name: 'dashboard',
//       builder: (context, state) => const DashboardPage(),
//     ),
//   ],
// );
