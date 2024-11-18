
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = user?.userMetadata?['full_name'];


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user?.userMetadata?['avatar_url'] != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.userMetadata!['avatar_url']),
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
                onPressed: () async {
                  await supabase.auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF451B0A),
                  shadowColor: Colors.transparent,
                  side: const BorderSide(color: Color(0xFF451B0A)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}