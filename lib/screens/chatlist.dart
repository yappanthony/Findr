
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = user?.userMetadata?['full_name'];

class Chatlist extends StatelessWidget {
  const Chatlist({super.key, required this.route, required String title});

  final String? route;
  final List<Map<String, dynamic>> gridData = const [
    {'avatar': 'assets/image.png', 'name': 'John Doe', 'chat': 'Hey, how are you?'},
    {'avatar': 'assets/image.png', 'name': 'Jane Smith', 'chat': 'Are we still meeting tomorrow?'},
    {'avatar': 'assets/image.png', 'name': 'Alice Johnson', 'chat': 'I found your notebook.'},
    {'avatar': 'assets/image.png', 'name': 'Bob Brown', 'chat': 'Can you call me back?'},
    {'avatar': 'assets/image.png', 'name': 'Charlie Davis', 'chat': 'I left my keys at your place.'},
    {'avatar': 'assets/image.png', 'name': 'Diana Evans', 'chat': 'Did you get my email?'},
    {'avatar': 'assets/image.png', 'name': 'Eve Foster', 'chat': 'Let’s catch up soon!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: const Color(0xFF96775A).withOpacity(.34)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: const Color(0xFF96775A).withOpacity(.34)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                ),
                ),
            ),
            Expanded(
                child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 5, // Adjust this value to control the height
                ),
                itemCount: gridData.length,
                itemBuilder: (context, index) {
                  final item = gridData[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(route!);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFF96775A).withOpacity(.34)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage('assets/image.png'),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(1000, 48, 38, 29),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.chat_outlined, size: 12,color: Color.fromARGB(1000, 48, 38, 29),),
                                     Text(
                                      item['chat'],
                                      style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(1000, 48, 38, 29),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
