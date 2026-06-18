import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router_notifier.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/auth/pages/confirm_signup_email_page.dart';
import 'package:mevtech/features/auth/pages/login_entry_page.dart';
import 'package:mevtech/features/auth/pages/login_page.dart';
import 'package:mevtech/features/auth/pages/password_reset_token_page.dart';
import 'package:mevtech/features/auth/pages/reset_password_page.dart';
import 'package:mevtech/features/auth/pages/sign_up_page.dart';
import 'package:mevtech/features/auth/pages/splash_page.dart';
import 'package:mevtech/features/auth/pages/verify_password_reset_page.dart';
import 'package:mevtech/features/chat/data/chat-data/chat_data_cubit.dart';
import 'package:mevtech/features/chat/logic/chat_cubit.dart';
import 'package:mevtech/features/chat/pages/chat_page.dart';
import 'package:mevtech/features/course/logic/course-content-cubit/course_content_cubit.dart';
import 'package:mevtech/features/course/logic/course-cubit/course_cubit.dart';
import 'package:mevtech/features/course/logic/selected_course_cubit.dart';
import 'package:mevtech/features/course/pages/course_content_page.dart';
import 'package:mevtech/features/course/pages/course_contentlist_page.dart';
import 'package:mevtech/features/course/pages/course_detail_page.dart';
import 'package:mevtech/features/course/pages/course_operation_page.dart';
import 'package:mevtech/features/course/pages/course_page.dart';
import 'package:mevtech/features/course/pages/create_course_content_page.dart';
import 'package:mevtech/features/course/pages/create_course_page.dart';
import 'package:mevtech/features/course/pages/edit_course_page.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/home/home_page.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_cours_category.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_page.dart';
import 'package:mevtech/features/presentation/dashboard/search_course.dart';
import 'package:mevtech/features/presentation/landing/landing_page.dart';
import 'package:mevtech/features/presentation/pages/categories_page.dart';
import 'package:mevtech/features/presentation/pages/category_view_more_page.dart';
import 'package:mevtech/features/presentation/pages/course_category_settings.dart';
import 'package:mevtech/features/presentation/pages/mock_test_page.dart';
import 'package:mevtech/features/quiz/logic/quiz_cubit.dart';
import 'package:mevtech/features/quiz/pages/quiz_mode.dart';
import 'package:mevtech/features/quiz/pages/quiz_page.dart';
import 'package:mevtech/features/quiz/pages/quiz_result_page.dart';
import 'package:mevtech/features/user/logic/user-cubit/user_cubit.dart';
import 'package:mevtech/features/user/pages/change_password_page.dart';
import 'package:mevtech/features/user/pages/edit_user_page.dart';
import 'package:mevtech/features/user/pages/payment_page.dart';
import 'package:mevtech/features/user/pages/subscription_page.dart';
import 'package:mevtech/features/user/pages/user_notification_page.dart';
import 'package:mevtech/features/user/pages/user_page.dart';
import 'package:mevtech/features/user/pages/view_notification_page.dart';
import 'package:mevtech/features/user/pages/view_profile_page.dart';
import 'package:mevtech/injector.dart';

class AppRouter extends Equatable {
  static const landing = 'landing';
  static const quizMode = 'quizMode';
  static const quiz = 'quiz';
  static const quizResult = 'quizResult';
  static const chat = 'chat';

  // auth related

  static const splashPage = 'splashPage';
  static const loginEntry = 'loginEntry';
  static const login = 'login';
  static const signUp = 'signUp';
  static const confirmSignupEmail = 'confirmSignupEmail';

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
  static const subscription = 'subscription';
  static const payment = 'payment';
  static const notification = 'notification';
  static const viewNotification = 'viewNotification';

  // course related
  static const course = 'course';
  static const createCourse = 'createCourse';
  static const courseOperation = 'courseOperation';
  static const courseDetails = 'courseDetails';

  static const courseContentlist = 'courseContentlist';
  static const courseContent = 'courseContent';
  static const createCourseContent = 'createCourseContent';

  static const editCourse = 'editCourse';
  static const courseCategorySettings = 'courseCategorySettings';

  @override
  List<Object?> get props => [
    landing,
    loginEntry,
    login,
    signUp,
    confirmSignupEmail,
    course,
    createCourse,
    courseDetails,
    courseContentlist,
    courseContent,
    editCourse,
    createCourseContent,
    categories,
    quizMode,
    quiz,
    quizResult,
    chat,
  ];
}

final publicRoutes = <String>[
  // '/loginEntry',
  // '/login',
  '/signUp',
  '/confirmSignupEmail',
  '/password-reset-token',
  '/password-reset-token/verify-password-token',
  '/password-reset-token/reset-password',
];

final GoRouter appRouter = _createRouter();

GoRouter _createRouter() {
  return GoRouter(
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
    // refreshListenable: getIt<AuthCubit>(),
    refreshListenable: getIt<AuthRouterNotifier>(),
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
      GoRoute(
        path: '/confirmSignupEmail',
        name: AppRouter.confirmSignupEmail,
        builder: (context, state) => const ConfirmSignupEmailPage(),
      ),

      // main shell
      ShellRoute(
        builder: (context, state, child) {
          // return BlocProvider(
          //   create: (context) => getIt<DashboardCubit>(),
          //   child: HomePage(child: child),
          // );

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<DashboardCubit>()),
              BlocProvider(create: (_) => getIt<HomeCubit>()),
              BlocProvider(create: (_) => getIt<SelectedCourseCubit>()),
              BlocProvider(create: (_) => getIt<ChatDataCubit>()),
            ],
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
                  // GoRoute(
                  //   path: 'course-details',
                  //   name: AppRouter.courseDetails,
                  //   builder: (context, state) {
                  //     final id = state.extra as String?;
                  //     if (id != null && id.isNotEmpty) {
                  //       return CourseDetailsPage(courseId: id);
                  //     } else {
                  //       return const Center(
                  //         child: Text('Error Fetching Course Content'),
                  //       );
                  //     }
                  //   },
                  // ),
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

                  GoRoute(
                    path: 'Create-CourseContent',
                    name: AppRouter.createCourseContent,
                    builder: (context, state) {
                      final id = state.extra as String?;
                      if (id != null && id.isNotEmpty) {
                        return CreateCourseContentPage(courseId: id);
                      } else {
                        return const Center(
                          child: Text('Error Fetching Course'),
                        );
                      }
                    },
                  ),
                ],
              ),

              // GoRoute(
              //   path: '/details/:id',
              //   builder: (context, state) {
              //     final id = state.params['id']!;
              //     return CourseDetailsPage(courseId: id);
              //   },
              // ),
              GoRoute(
                path: '/course-details/:id',
                name: AppRouter.courseDetails,
                builder: (context, state) {
                  // final id = state.path;
                  final id = state.pathParameters['id'];
                  if (id != null && id.isNotEmpty) {
                    return CourseDetailsPage(courseId: id);
                  } else {
                    return const Center(
                      child: Text('Error Fetching Course Details'),
                    );
                  }
                },
              ),

              ShellRoute(
                builder: (context, state, child) {
                  return BlocProvider(
                    create: (context) => getIt<CourseContentCubit>(),
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: '/courseContentlist',
                    name: AppRouter.courseContentlist,
                    builder: (context, state) {
                      final data = state.extra as String?;
                      if (data != null) {
                        return CourseContentlistPage(courseId: data);
                      } else {
                        return const Center(child: Text('Error Fetching Data'));
                      }
                    },
                  ),
                  GoRoute(
                    path: '/courseContent',
                    name: AppRouter.courseContent,
                    builder: (context, state) {
                      final data = state.extra as String?;
                      if (data != null) {
                        return CourseContentPage(id: data);
                      } else {
                        return const Center(child: Text('Error Fetching Data'));
                      }
                    },
                  ),
                ],
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
              final data = state.extra as String?;
              // if (data != null) {
              //   return MockTestPage(courseModel: data);
              // } else {
              //   return const Center(child: Text('Error Fetching Data'));
              // }
              // return CourseYoutubePlayer(videoId: data ?? '');
              return const MockTestPage();
            },
          ),

          // Landing
          GoRoute(
            path: '/landing',
            name: AppRouter.landing,
            builder: (context, state) => const LandingPage(),
          ),
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => getIt<QuizCubit>(),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/quizMode',
                name: AppRouter.quizMode,
                builder: (context, state) => const QuizModeScreen(),
              ),
              GoRoute(
                path: '/quiz/:mode',
                name: AppRouter.quiz,
                builder: (context, state) {
                  final data = state.extra as String?;
                  final mode = state.pathParameters['mode'];

                  return QuizPage(selectedSubject: data, mode: mode ?? '');
                },
              ),
              GoRoute(
                path: '/quizResult:mode',
                name: AppRouter.quizResult,
                builder: (context, state) {
                  final data = state.extra as String?;
                  final mode = state.pathParameters['mode'];
                  final isAutoSubmit =
                      state.uri.queryParameters['auto_submit'] == 'true';

                  return QuizResultPage(
                    selectedSubject: data,
                    mode: mode ?? '',
                    showReasonDialog: isAutoSubmit,
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: '/chat', // :channelId
            name: AppRouter.chat,
            builder: (context, state) {
              // final channelId = state.pathParameters['channelId'];
              return BlocProvider(
                create: (_) => getIt<ChatCubit>(),
                child: const ChatPage(),
              );
            },
          ),

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

          GoRoute(
            path: '/subscription',
            name: AppRouter.subscription,
            builder: (context, state) => const SubscriptionPage(),
          ),

          GoRoute(
            path: '/payment',
            name: AppRouter.payment,
            builder: (context, state) {
              final data = state.extra as String?;
              return PaymentPage(paymentUrl: data ?? '');
            },
          ),

          GoRoute(
            path: '/notification',
            name: AppRouter.notification,
            builder: (context, state) => const UserNotificationPage(),
          ),

          GoRoute(
            path: '/viewNotification',
            name: AppRouter.viewNotification,
            builder: (context, state) {
              final data = state.extra as String?;
              return ViewNotificationPage(id: data ?? '');
            },
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
}

// final appRouter =

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
