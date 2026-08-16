import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/teacher/presentation/screens/teacher_list_screen.dart';
import '../../features/teacher/presentation/screens/teacher_detail_screen.dart';
import '../../features/teacher/presentation/screens/add_teacher_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/teachers', builder: (_, __) => const TeacherListScreen()),
    GoRoute(
      path: '/teachers/add',
      builder: (_, __) => const AddTeacherScreen(),
    ),
    GoRoute(
      path: '/teachers/:id',
      builder: (_, state) => TeacherDetailScreen(
        teacherId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
