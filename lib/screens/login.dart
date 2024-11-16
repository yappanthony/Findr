import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

final supabase = Supabase.instance.client;

Future<AuthResponse> _googleSignIn(BuildContext context) async {
  /// Web Client ID that you registered with Google Cloud.
  const webClientId = '145855038865-q12e8af3cqf6ufbvk3k3dk69ju4bi0op.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

   // Perform the Supabase sign-in
    final authResponse = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (authResponse.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()), 
      );
    } else {
      throw 'Failed to sign in with Google.';
    }

  return authResponse;
}

// Get user data
final user = supabase.auth.currentUser;
final profileImageUrl = user?.userMetadata?['avatar_url'];
final fullName = user?.userMetadata?['full_name'];


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/logo.png', fit: BoxFit.cover),
              GradientText(
                'Findr',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'JuliusSansOne',
                ),
                colors: const [
                  Color(0xFF96775B),
                  Color.fromARGB(1000, 48, 38, 29),
                ],
              ),
              const Text(
                'Home of the wayward tresures', 
                style: TextStyle(
                  color: Color.fromARGB(1000, 48, 38, 29),
                  fontFamily: 'Roboto',
                  )
                ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  _googleSignIn(context);
                },
                icon: FontAwesomeIcons.google,
                label: 'Sign in with Google',
              ),
              const SizedBox(height: 15),
              CustomButton(
                onPressed: () {
                  // Add Guest sign-in logic here
                },
                icon: FontAwesomeIcons.solidUser,
                label: 'Sign in as Guest',
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const CustomButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(
        icon,
        color: Colors.white,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(1000, 48, 38, 29),
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
