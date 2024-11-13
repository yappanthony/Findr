import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = user?.userMetadata?['full_name'];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$fullName, you are home. You are safe.",
              style: const TextStyle(
                fontSize: 50,
              )
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 124, 168),
              ),
              onPressed: () async {
                await supabase.auth.signOut();
              }, 
              child: const Text(
                'Logout',
                style:TextStyle(
                  color: Colors.black,
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}