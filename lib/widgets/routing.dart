
import 'package:findr/screens/chat.dart';
import 'package:findr/screens/chatlist.dart';
import 'package:findr/screens/details.dart';
import 'package:findr/screens/home.dart';
import 'package:findr/screens/profile.dart';
import 'package:findr/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BottomNavBar(shell: shell),
      branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const Home(
            title: "Lost & Found",
            route: '/details',
          ),
        ),
        GoRoute(
          path: "/details",
          builder: (context, state) => const Details(),
        )
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/chatlist",
          builder: (context, state) => const Chatlist(
            title: "Chat List",
            route: '/chat'
          ),
        ),
        GoRoute(
          path: "/chat",
          builder: (context, state) => const Chat(),
        )
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: "/profile",
          builder: (context, state) => const Profile(),
        )
      ])
    ])
]);