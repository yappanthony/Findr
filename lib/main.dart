import 'package:findr/widgets/routing.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kzaezxyufvydztpdnxeo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt6YWV6eHl1ZnZ5ZHp0cGRueGVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNTE4NzAsImV4cCI6MjA0NjcyNzg3MH0.gB49-HRM31IJb7QSXLPN98tZe8BimN9ndF70rQUx5CY',
  );
  runApp(const ProviderScope(child: MainApp()));
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Findr',
      routerConfig: router,
    );
  }
}