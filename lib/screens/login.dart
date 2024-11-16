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
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                          colors: [
                            Color(0xFF96775B),
                            Color(0xFF451B0A),
                          ],
                        ),
                    ),
                    ),
                    ),
                    const Spacer(),
                    ClipPath(
                    clipper: MyClipper2(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft ,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF96775B),
                            Color(0xFF451B0A),
                          ],
                        ),
                    ),
                    ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    Image.asset('assets/logo.png', height: 50),
                    GradientText(
                      'Findr',
                      style: const TextStyle(
                        fontSize: 40,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: Colors.white,
        ),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF451B0A),
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}


class MyClipper extends CustomClipper<Path> { 
@override 
Path getClip(Size size) { 
	var path = Path(); 
  path.lineTo(size.width * 0.3, 0); 
	path.lineTo(size.width * 0.8, 30); 
	path.lineTo(size.width * 0.2, 50); 
	path.lineTo(size.width * 0.23, size.height * 0.7); 
  path.lineTo(size.width * 0.1, 40); 
	path.lineTo(size.width * 0.15, size.height); 
  path.lineTo(0, size.height * 0.71); 
	path.close(); 
	return path; 
} 


@override 
bool shouldReclip(CustomClipper<Path> oldClipper) { 
	return false; 
} 
}

class MyClipper2 extends CustomClipper<Path> { 
@override 
Path getClip(Size size) { 
	var path = Path();
  path.moveTo(size.width, size.height);
  path.lineTo(size.width, size.height*.8);
  path.lineTo(size.width*.92 , size.height*.9);
  path.lineTo(50, 150);
  path.lineTo(size.width*.6, size.height);
	path.close();
	return path;
} 


@override 
bool shouldReclip(CustomClipper<Path> oldClipper) { 
	return false; 
} 
}
