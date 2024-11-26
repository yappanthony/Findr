import 'package:findr/screens/chat.dart';
import 'package:findr/screens/details.dart';
import 'package:findr/screens/home.dart';
import 'package:findr/screens/profile.dart';
import 'package:findr/screens/login.dart'; // Import the login screen
import 'package:findr/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const Login(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BottomNavBar(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) => const Home(
              title: "Lost & Found",
              route: '/details',
            ),
          ),
          GoRoute(
            path: "/details",
            builder: (context, state) => Details(
              item: state.extra as Map<String, dynamic>,
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/profile",
            builder: (context, state) => const Profile(
              title: "Profile",
              route: '/chat',
            ),
          ),
          GoRoute(
            path: "/chat",
            builder: (context, state) => const Chat(),
          ),
        ]),
      ],
    ),
  ],
);