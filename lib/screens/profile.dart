
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = (user?.isAnonymous ?? true) ? 'Anonymous' : user?.userMetadata?['full_name'];
final avatar = fullName == 'Anonymous' ? 'https://kzaezxyufvydztpdnxeo.supabase.co/storage/v1/object/public/items/user.png' : user!.userMetadata!['avatar_url'];


class Profile extends StatelessWidget {
  const Profile({super.key, this.route, required String title});

  final String? route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatar),
            ),
            const SizedBox(height: 20),
            if (fullName != null)
              Text(
                'Hi, $fullName',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (route != null) {
                    context.go(route!);
                  }
                },
                label: const Text('Contact Admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF451B0A),
                  shadowColor: Colors.transparent,
                  side: const BorderSide(color: Color(0xFF451B0A)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton.icon(
                onPressed: () async {
                          await supabase.auth.signOut();
                          context.go('/');
                        },
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shadowColor: Colors.transparent,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}