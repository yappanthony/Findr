import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                  // Add Google sign-in logic here
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF96775B), Color.fromARGB(1000, 48, 38, 29)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: Colors.white,
        ),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}
