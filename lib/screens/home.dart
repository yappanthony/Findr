import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final authID = user?.id ?? '';

final fullName = user?.userMetadata?['full_name'];

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
      final response = await supabase.from('search_history').select('*').eq('user_id', authID).order('created_at', ascending: false);

      dbSearchQueries = List<Map<String, dynamic>>.from(response);
      print(dbSearchQueries);
    
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> addSearchHistory() async {
    try {
      if (_searchQuery.isEmpty) return;
      if (dbSearchQueries.any((element) => element['query'] == _searchQuery)) {
        await supabase.from('search_history')
          .update({'created_at': DateTime.now().toIso8601String()})  
          .eq('query', _searchQuery)  
          .eq('user_id', authID); 
        fetchSearchHistory();
      } else {
        await supabase.from('search_history')
          .insert([{'query': _searchQuery}]
        );
      }

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
                onSubmitted: (value) {
                  setState(() {
                    showSearchHistory = false;
                    _searchQuery = value;
                    // POST new query 
                    addSearchHistory();
                    fetchSearchHistory();
                    fetchItems();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: showSearchHistory || _searchQuery.isNotEmpty
                      ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        showSearchHistory = false;
                        FocusScope.of(context).unfocus();
                        });
                      },
                      )
                    : null,
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
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.text = search_query["query"];
                          _searchQuery = search_query["query"];
                          showSearchHistory = false;
                          addSearchHistory();
                          fetchSearchHistory();
                          fetchItems();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                  child: FaIcon(
                                    FontAwesomeIcons.clockRotateLeft,
                                    size: 20,
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                ),
                                Text(
                                  search_query["query"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController.text = search_query["query"];
                                      _searchQuery = search_query["query"];
                                    });
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.arrowUp,
                                    size: 20,
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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
