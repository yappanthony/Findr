import 'package:findr/screens/details.dart';
import 'package:findr/screens/login.dart';
import 'package:findr/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kzaezxyufvydztpdnxeo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt6YWV6eHl1ZnZ5ZHp0cGRueGVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNTE4NzAsImV4cCI6MjA0NjcyNzg3MH0.gB49-HRM31IJb7QSXLPN98tZe8BimN9ndF70rQUx5CY',
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

/*
  Use a FutureBuilder to fetch the data when the home page loads and display the query result in a ListView.
*/

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/home',
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(),
        '/details': (context) => const Details(),
      },
    );
  }
}

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   final _items = supabase.from('items').stream(primaryKey: ['id']);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _items,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           final items = snapshot.data!;

//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(items[index]['name'])
//               );
//             }
//           );
//         }
//       )
//     );
//   }
// }

