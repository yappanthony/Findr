import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = user?.userMetadata?['full_name'];
final authID = user?.id;

class Home extends StatefulWidget {
  const Home({super.key, this.route, required String title});

  final String? route;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> dbSearchQueries = [];
  bool showSearchHistory = false;

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchSearchHistory();
  }

  Future<List<Map<String, dynamic>>> fetchItems() {
    return supabase
        .from('items')
        .select('id, name, date_reported, description, location, images(image_url), reporter_name, claimed, visible')
        .or('name.ilike.%$_searchQuery%,description.ilike.%$_searchQuery%')
        .eq('visible', true)
        .then((response) => List<Map<String, dynamic>>.from(response));
  }

  Future<void> fetchSearchHistory() async {
    try {
      final response = await supabase.from('search_history').select('*');

      dbSearchQueries = [{"query": "good to know :)"}];

      // dbSearchQueries = List<Map<String, dynamic>>.from(response);
      // print(dbSearchQueries);
    
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Lost & Found",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _searchController,
                onTap: () {
                  setState(() {
                    showSearchHistory = true;
                  });
                  fetchSearchHistory();
                },
                onTapOutside: (event) {
                  setState(() {
                    showSearchHistory = false;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    _searchQuery = value;
                    // POST new query 
                    fetchItems();
                  });
                },
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
            if (showSearchHistory)
              Expanded(
                child: ListView.builder(
                  itemCount: dbSearchQueries.length,
                  itemBuilder: (context, index) {
                    final search_query = dbSearchQueries[index];

                    return Container(
                      child: Text(search_query["query"]),
                    );
                  },
                ),
              ),
            if (!showSearchHistory)
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data'));
                    }

                    final items = snapshot.data ?? [];

                    return items.isEmpty
                        ? const Center(child: Text('No items found'))
                        : GridView.builder(
                            padding: const EdgeInsets.all(15),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: .6, // Adjust this value to control the height
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    widget.route!,
                                    extra: item,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: const Color(0xFF96775A).withOpacity(.34)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 200,
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                ),
                                                child: Image.network(
                                                  item['images'][0]['image_url'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: const Color.fromARGB(1000, 48, 38, 29).withOpacity(.70),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                child: Text(
                                                  item['claimed'] != null && item['claimed'] ? "Claimed" : "Unclaimed",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(1000, 48, 38, 29),
                                              ),
                                            ),
                                            Text(
                                              item['description'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(1000, 48, 38, 29).withOpacity(.70),
                                              ),
                                            ),
                                          ]  
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
